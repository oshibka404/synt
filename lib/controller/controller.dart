import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../arpeggiator/arpeggiator.dart';
import '../arpeggiator/arpeggio.dart';
import '../arpeggiator/arpeggio_bank.dart';
import '../recorder/recorder.dart';
import '../recorder/recorded_action.dart';
import '../tempo_controller/tempo_controller.dart';
import '../synth/action_receiver.dart';
import '../synth/scales.dart';
import '../synth/dsp_api.dart';
import 'keyboard/keyboard_action.dart';
import 'keyboard/keyboard.dart';
import 'keyboard_preset.dart';
import 'preset_selector/preset_selector.dart';
import 'settings.dart';

class Controller extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ControllerState();
}

class _ControllerState extends State<Controller> {
  static List<KeyboardPreset> keyboardPresets = [
    KeyboardPreset(
      baseKey: 61,
      color: ColorSwatch<int>(0xFF3885ED, {
        200: Color(0xFF3885ED),
        900: Color(0xFF2f74d0),
      }),
    ),
    KeyboardPreset(
      baseKey: 37,
      color: ColorSwatch<int>(0xFFfbf043, {
        200: Color(0xFFfbf043),
        900: Color(0xFFe7dc33),
      }),
    ),
    KeyboardPreset(
      baseKey: 13,
      color: ColorSwatch<int>(0xFFf7642c, {
        200: Color(0xFFf7642c),
        900: Color(0xFFda4d17),
      }),
    ),
  ];

  Map<int, Arpeggiator> _arpeggiators = {};

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

  void _keyboardHandler(action) {
    if (_isReadyToRecord && !recorder.isRecording) {
      // TODO: save records in record store
      recorder.startRec(
          Offset(action.stepOffset, action.modulation), currentPreset);
    }
    _recorderLoopController.add(action);
  }

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

  void _addArpeggiator(RecordedAction action) {
    _arpeggiators[action.pointerId] =
        Arpeggiator(_tempoController, ArpeggioBank());
    _arpeggiators[action.pointerId].output.listen((playerAction) {
      _outputController.add(_playerActionToSynthCommand(
          playerAction, action.pointerId, action.preset));
    });
  }

  var _recorderLoopController = StreamController<KeyboardAction>();

  Recorder recorder;

  bool _isReadyToRecord = false;

  TempoController _tempoController;

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

  List<int> _scale = Scales.dorian;

  double _getFreqFromKeyNumber(double keyNumber) {
    return 440 * pow(2, (keyNumber - 49) / 12);
  }

  double _convertStepOffsetToPianoKey(double stepOffset, int baseKey) {
    int stepNumber = stepOffset.floor();
    int octaveOffset = (stepNumber ~/ _scale.length);
    int chromaticStepsOffset = _scale[stepNumber % _scale.length];
    int semitonesOffset = (octaveOffset * 12) + chromaticStepsOffset;
    return (baseKey + semitonesOffset).floorToDouble();
  }

  double _getFreqFromStepOffset(double step, int baseKey) {
    return _getFreqFromKeyNumber(_convertStepOffsetToPianoKey(step, baseKey));
  }

  KeyboardPreset currentPreset = keyboardPresets[0];
  void setPreset(KeyboardPreset preset) {
    setState(() {
      currentPreset = preset;
    });
  }

  bool _settingsOpen = false;

  void toggleSettings() {
    setState(() {
      _settingsOpen = !_settingsOpen;
      DspApi.allNotesOff();
    });
  }

  void setReady(bool ready) {
    if (!ready) {
      recorder.stopRec();
    }
    setState(() {
      _isReadyToRecord = ready;
    });
  }

  var _outputController = StreamController<SynthCommand>();
  var _keyboardController = StreamController<KeyboardAction>();

  @override
  void dispose() {
    _outputController.close();
    _keyboardController.close();
    super.dispose();
  }

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
          isReadyToRecord: _isReadyToRecord,
          isRecording: recorder.isRecording,
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
}
