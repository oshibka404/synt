import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../arpeggiator/arpeggiator.dart';
import '../arpeggiator/arpeggio.dart';
import '../arpeggiator/arpeggio_bank.dart';
import '../recorder/recorded_action.dart';
import '../recorder/recorder.dart';
import '../synth/action_receiver.dart';
import '../synth/dsp_api.dart';
import '../synth/scales.dart';
import '../tempo_controller/tempo_controller.dart';
import 'keyboard/keyboard.dart';
import 'keyboard/keyboard_action.dart';
import 'keyboard_preset.dart';
import 'keyboard_presets.dart' show keyboardPresets;
import 'preset_selector/preset_selector.dart';
import 'record_view.dart';
import 'settings.dart';

class Controller extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ControllerState();
}

class _ControllerState extends State<Controller> {
  Map<int, Arpeggiator> _arpeggiators = {};
  Map<DateTime, RecordView> _recordViews = {};

  var _recorderLoopController = StreamController<KeyboardAction>();

  Recorder recorder;

  bool isReadyToRecord = false;

  bool isRecording = false;

  TempoController _tempoController;

  List<int> _scale = Scales.dorian;

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
        var keyboard = Keyboard(
          size: keyboardSize,
          offset: Offset(controlPanelWidth, 0),
          preset: currentPreset,
          output: _keyboardController,
          isReadyToRecord: isReadyToRecord,
          isRecording: isRecording,
          toggleRecord: toggleRecord,
          recordViews: _recordViews,
        );
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
              Stack(
                  children: _settingsOpen
                      ? [
                          keyboard,
                          Container(
                            constraints: BoxConstraints.tight(keyboardSize),
                            child: Settings(),
                            color: Theme.of(context).backgroundColor,
                          ),
                        ]
                      : [keyboard]),
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

  @override
  void dispose() {
    _outputController.close();
    _keyboardController.close();
    super.dispose();
  }

  @override
  initState() {
    super.initState();

    ActionReceiver(_outputController.stream);

    _tempoController = TempoController(tempo: 120);

    recorder = Recorder(
        input: _recorderLoopController.stream, tempo: _tempoController);

    _keyboardController.stream.listen(_keyboardHandler);

    recorder.output.listen(_recorderHandler);
  }

  void setPreset(KeyboardPreset preset) {
    setState(() {
      currentPreset = preset;
    });
  }

  void setReady(bool ready) {
    if (!ready) {
      recorder.stopRec();
      setState(() {
        isRecording = false;

        // TODO: address specific recordView instead of iterating
        _recordViews = _recordViews.map(
            (key, value) => MapEntry(key, value.assign(isRecording: false)));
      });
    }
    setState(() {
      isReadyToRecord = ready;
    });
  }

  void toggleRecord(DateTime recordId) {
    var record = recorder.records[recordId];
    if (record == null) return;
    if (record.isPlaying) {
      recorder.stop(record);
      setState(() {
        _recordViews[recordId] =
            _recordViews[recordId].assign(isPlaying: false);
      });
      print("Stopped");
    } else {
      recorder.loop(record);
      setState(() {
        _recordViews[recordId] = _recordViews[recordId].assign(isPlaying: true);
      });
      print("Play!");
    }
  }

  void toggleSettings() {
    setState(() {
      _settingsOpen = !_settingsOpen;
      DspApi.allNotesOff();
    });
  }

  void _addArpeggiator(RecordedAction action) {
    _arpeggiators[action.pointerId] =
        Arpeggiator(_tempoController, ArpeggioBank());
    _arpeggiators[action.pointerId].output.listen((playerAction) {
      _outputController.add(_playerActionToSynthCommand(
          playerAction, action.pointerId, action.preset));
    });
  }

  double _convertStepOffsetToPianoKey(double stepOffset, int baseKey) {
    int stepNumber = stepOffset.floor();
    int octaveOffset = (stepNumber ~/ _scale.length);
    int chromaticStepsOffset = _scale[stepNumber % _scale.length];
    int semitonesOffset = (octaveOffset * 12) + chromaticStepsOffset;
    return (baseKey + semitonesOffset).floorToDouble();
  }

  double _getFreqFromKeyNumber(double keyNumber) {
    return 440 * pow(2, (keyNumber - 49) / 12);
  }

  double _getFreqFromStepOffset(double step, int baseKey) {
    return _getFreqFromKeyNumber(_convertStepOffsetToPianoKey(step, baseKey));
  }

  void _keyboardHandler(action) {
    if (isReadyToRecord && !isRecording) {
      var startOffset = Offset(action.stepOffset, action.modulation);
      var startTime = recorder.startRec(startOffset, currentPreset);
      setState(() {
        _recordViews[startTime] = RecordView(
          startOffset,
          currentPreset,
          true,
          true,
        );
        isRecording = true;
      });
    }
    _recorderLoopController.add(action);
  }

  SynthCommand _playerActionToSynthCommand(
          PlayerAction action, int voiceId, KeyboardPreset preset) =>
      action.velocity > 0
          ? SynthCommand(voiceId,
              modulation: action.modulation,
              freq: _getFreqFromStepOffset(
                  action.stepOffset, preset?.baseKey ?? currentPreset.baseKey))
          : SynthCommand.stop(voiceId);

  SynthCommand _recordedActionToSynthCommand(RecordedAction action) =>
      action.pressure > 0
          ? SynthCommand(action.pointerId,
              modulation: action.modulation,
              freq: _getFreqFromStepOffset(action.stepOffset,
                  action.preset?.baseKey ?? currentPreset.baseKey))
          : SynthCommand.stop(action.pointerId);

  void _recorderHandler(RecordedAction action) {
    if (!_arpeggiators.containsKey(action.pointerId)) {
      _outputController.add(_recordedActionToSynthCommand(action));
      _addArpeggiator(action);
    }
    if (action.pressure > 0) {
      _arpeggiators[action.pointerId].play(action.modulation,
          baseStep: action.stepOffset,
          modulation: action.modulation,
          velocity: action.pressure);
    } else {
      _arpeggiators[action.pointerId].stop();
      _arpeggiators.remove(action.pointerId);
    }
  }
}
