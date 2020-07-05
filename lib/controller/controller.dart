import 'dart:async';

import 'package:flutter/material.dart';
import 'keyboard/virtual_keyboard_action.dart';
import 'synth_command_factory.dart';
import '../synth/synth_command.dart';

import '../arpeggiator/arpeggiator.dart';
import '../arpeggiator/arpeggio_bank.dart';
import '../looper/sample.dart';
import '../looper/looper.dart';
import '../synth/synth_input.dart';
import '../synth/dsp_api.dart';
import '../tempo_controller/tempo_controller.dart';
import 'controls.dart';
import 'keyboard/keyboard.dart';
import 'keyboard/keyboard_action.dart';
import 'keyboard_preset.dart';
import 'keyboard_presets.dart' show keyboardPresets;
import 'preset_selector/preset_selector.dart';
import 'loop_view.dart';

class Controller extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ControllerState();
}

class _ControllerState extends State<Controller> {
  Map<int, Arpeggiator> _arpeggiators = {};
  Map<DateTime, LoopView> _loopViews = {};
  Map<int, VirtualKeyboardAction> _virtualActions = {};

  var _loopController = StreamController<KeyboardAction>();

  Looper looper;

  bool isReadyToRecord = false;

  bool isRecording = false;

  TempoController _tempoController;

  KeyboardPreset currentPreset = keyboardPresets[0];
  bool _settingsOpen = false;

  var _outputController = StreamController<SynthCommand>();

  var _keyboardController = StreamController<KeyboardAction>();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double controlPanelWidth = constraints.maxHeight / 3;
        var keyboardSize = Size(
            constraints.maxWidth - controlPanelWidth, constraints.maxHeight);
        return Scaffold(
          body: Row(
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
                  toggleLoop: toggleLoop,
                  loopViews: _loopViews,
                  deleteRecord: deleteLoop,
                  virtualKeyboardActions: _virtualActions,
                ),
                if (_settingsOpen)
                  Container(
                    constraints: BoxConstraints.tight(keyboardSize),
                    child: Controls(),
                    color: Theme.of(context).backgroundColor,
                  ),
              ]),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: currentPreset.color,
            onPressed: toggleSettings,
            tooltip: 'Sound settings',
            child: const Icon(Icons.settings),
          ),
        );
      },
    );
  }

  void deleteLoop(DateTime id) {
    looper.delete(looper.loops[id]);
    _loopViews.remove(id);
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
    _tempoController = TempoController(tempo: 120);

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

  void toggleLoop(DateTime id) {
    var loop = looper.loops[id];
    if (loop == null) return;
    if (loop.isPlaying) {
      looper.stop(loop);
      setState(() {
        _loopViews[id] = _loopViews[id].assign(isPlaying: false);
      });
      print("Stopped $id");
    } else {
      looper.start(loop);
      setState(() {
        _loopViews[id] = _loopViews[id].assign(isPlaying: true);
      });
      print("Play $id!");
    }
  }

  void toggleSettings() {
    setState(() {
      _settingsOpen = !_settingsOpen;
      DspApi.allNotesOff();
    });
  }

  void _addArpeggiator(Sample sample) {
    _arpeggiators[sample.pointerId] =
        Arpeggiator(_tempoController, ArpeggioBank());
    _arpeggiators[sample.pointerId].output.listen((playerAction) {
      _outputController.add(SynthCommandFactory.fromPlayerAction(
          playerAction, sample.pointerId, sample.preset ?? currentPreset));
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
          sample, sample.pointerId, sample.preset ?? currentPreset));
    }
    if (sample.pressure > 0) {
      _arpeggiators[sample.pointerId].play(sample.modulation,
          baseStep: sample.stepOffset,
          modulation: sample.modulation,
          velocity: sample.pressure);
      setState(() {
        _virtualActions[sample.pointerId] = VirtualKeyboardAction(
            sample.origin,
            sample.preset,
            sample.pressure,
            Offset(sample.stepOffset, sample.modulation));
      });
    } else {
      _arpeggiators[sample.pointerId].stop();
      _arpeggiators.remove(sample.pointerId);
      setState(() {
        _virtualActions.remove(sample.pointerId);
      });
    }
  }
}
