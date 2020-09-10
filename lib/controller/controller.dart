import 'dart:async';

import 'package:flutter/material.dart';
import 'package:perfect_first_synth/controller/inverting_button.dart';
import 'package:perfect_first_synth/scales/scale_patterns.dart';

import '../arpeggiator/arpeggiator.dart';
import '../arpeggiator/arpeggio_bank.dart';
import '../arpeggiator/arpeggio_banks.dart' show arpeggioBank;
import '../looper/looper.dart';
import '../looper/sample.dart';
import '../synth/dsp_api.dart';
import '../synth/synth_command.dart';
import '../synth/synth_input.dart';
import '../tempo_controller/tempo_controller.dart';
import 'keyboard/keyboard.dart';
import 'keyboard/keyboard_action.dart';
import 'keyboard_preset.dart';
import 'keyboard_presets.dart' show keyboardPresets;
import 'loop_view.dart';
import 'loops_layer.dart';
import 'preset_selector/preset_selector.dart';
import 'settings/controls.dart';
import 'synth_command_factory.dart';

class Controller extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ControllerState();
}

class _ControllerState extends State<Controller> {
  Map<int, Arpeggiator> _arpeggiators = {};
  Map<DateTime, LoopView> _loopViews = {};

  var _loopController = StreamController<KeyboardAction>();

  Looper looper;

  bool isReadyToRecord = false;

  bool isRecording = false;

  TempoController _tempoController;

  KeyboardPreset currentPreset = keyboardPresets[2];
  bool _settingsOpen = false;

  var _outputController = StreamController<SynthCommand>();

  var _keyboardController = StreamController<KeyboardAction>();

  double _tempo = 120;

  bool syncEnabled = false;

  ScalePattern _scale = ScalePattern.minor;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final int presetsCount = keyboardPresets.length;
        final double controlPanelWidth = constraints.maxHeight / presetsCount;
        final int maxLoopCount = 8;
        final double loopPanelWidth = constraints.maxHeight / maxLoopCount;
        var keyboardSize = Size(
            constraints.maxWidth - controlPanelWidth - loopPanelWidth,
            constraints.maxHeight);
        return Row(
          children: [
            PresetSelector(
              size: Size(controlPanelWidth, constraints.maxHeight),
              currentPreset: currentPreset,
              setPreset: setPreset,
              keyboardPresets: keyboardPresets,
              onTapDown: () => setReady(true),
              onTapUp: () => setReady(false),
            ),
            Stack(children: [
              Keyboard(
                size: keyboardSize,
                offset: Offset(controlPanelWidth, 0),
                preset: currentPreset,
                output: _keyboardController,
                isReadyToRecord: isReadyToRecord,
                isRecording: isRecording,
                scaleLength: ScalePatterns.getScale(_scale).length,
              ),
              if (_settingsOpen)
                Container(
                  padding: EdgeInsets.all(16),
                  constraints: BoxConstraints.tight(keyboardSize),
                  child: Controls(currentPreset, _tempo, setTempo, _scale,
                      setScale, _clearAll, syncEnabled, setSyncEnabled),
                  color: Theme.of(context).backgroundColor,
                ),
            ]),
            Container(
              decoration: BoxDecoration(color: Colors.black),
              child: Column(
                children: [
                  Expanded(
                    child: LoopsLayer(
                      size: Size(loopPanelWidth,
                          constraints.maxHeight - loopPanelWidth),
                      loops: _loopViews,
                      toggleLoop: toggleLoop,
                      deleteLoop: deleteLoop,
                    ),
                  ),
                  InvertingButton(
                    onTap: toggleSettings,
                    size: Size.square(loopPanelWidth),
                    color: Colors.black,
                    iconData: Icons.settings,
                  )
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  void setSyncEnabled(bool syncEnabled) {
    DspApi.setParamValueByPath("po_sync_enabled", syncEnabled ? 1 : 0);
    setState(() {
      this.syncEnabled = syncEnabled;
    });
  }

  void deleteLoop(DateTime id) {
    looper.delete(looper.loops[id]);
    setState(() {
      _loopViews.remove(id);
    });
  }

  @override
  void dispose() {
    _outputController.close();
    _keyboardController.close();
    super.dispose();
  }

  @override
  initState() {
    super.initState();
    _tempoController = TempoController(tempo: _tempo);

    _keyboardController.stream.listen(_keyboardHandler);

    looper = Looper(input: _loopController.stream, tempo: _tempoController);
    looper.output.listen(_looperHandler);

    SynthInput.connect(_outputController.stream);
  }

  void setPreset(KeyboardPreset preset) {
    setState(() {
      currentPreset = preset;
    });
  }

  void setReady(bool ready) {
    if (!ready) {
      looper.stopRec();
      setState(() {
        isRecording = false;

        // TODO: address specific loopView instead of iterating
        _loopViews = _loopViews.map(
            (key, value) => MapEntry(key, value.assign(isRecording: false)));
      });
    }
    setState(() {
      isReadyToRecord = ready;
    });
  }

  void setScale(ScalePattern newScale) {
    setState(() {
      _scale = newScale;
    });
  }

  void setTempo(double newTempo) {
    _tempoController.setTempo(newTempo);
    setState(() {
      _tempo = newTempo;
    });
  }

  void toggleLoop(DateTime id) {
    var loop = looper.loops[id];
    if (loop == null) return;
    if (loop.isPlaying) {
      looper.stop(loop);
      setState(() {
        _loopViews[id] = _loopViews[id].assign(isPlaying: false);
      });
    } else {
      looper.start(loop);
      setState(() {
        _loopViews[id] = _loopViews[id].assign(isPlaying: true);
      });
    }
  }

  void toggleSettings() {
    setState(() {
      _settingsOpen = !_settingsOpen;
      DspApi.allNotesOff();
    });
  }

  void _addArpeggiator(Sample sample) {
    _arpeggiators[sample.pointerId] = Arpeggiator(
        _tempoController,
        ArpeggioBank(
            arpeggioBank[sample.preset?.arpeggio ?? currentPreset.arpeggio]));
    _arpeggiators[sample.pointerId].output.listen((playerAction) {
      _outputController.add(SynthCommandFactory.fromPlayerAction(playerAction,
          sample.pointerId, sample.preset ?? currentPreset, _scale));
    });
  }

  _clearAll() {
    _loopViews.keys.toSet().forEach((loopId) {
      deleteLoop(loopId);
    });
  }

  void _keyboardHandler(KeyboardAction action) {
    if (isReadyToRecord && !isRecording) {
      var startOffset = Offset(action.stepOffset, action.modulation);
      var startTime = looper.startRec(startOffset, currentPreset);
      setState(() {
        _loopViews[startTime] = LoopView(
          startOffset,
          currentPreset,
          true,
          true,
        );
        isRecording = true;
      });
    }
    _loopController.add(action);
  }

  void _looperHandler(Sample sample) {
    if (!_arpeggiators.containsKey(sample.pointerId)) {
      _addArpeggiator(sample);
      _outputController.add(SynthCommandFactory.fromKeyboardAction(
          sample, sample.pointerId, sample.preset ?? currentPreset, _scale));
    }
    if (sample.pressure > 0) {
      _arpeggiators[sample.pointerId].play(sample.modulation,
          baseStep: sample.stepOffset, modulation: sample.pressure);
    } else {
      _arpeggiators[sample.pointerId].stop();
      _arpeggiators.remove(sample.pointerId);
    }
  }
}
