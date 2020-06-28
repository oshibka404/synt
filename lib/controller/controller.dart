import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:perfect_first_synth/arpeggiator/arpeggiator.dart';
import 'package:perfect_first_synth/arpeggiator/arpeggio.dart';
import 'package:perfect_first_synth/tempo_controller/tempo_controller.dart';

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
      color: Colors.blue,
    ),
    KeyboardPreset(
      baseKey: 37,
      color: Colors.amber,
    ),
    KeyboardPreset(
      baseKey: 13,
      color: Colors.red,
    ),
  ];

  Map<int, Arpeggiator> _arpeggiators = {};

  @override
  initState() {
    super.initState();
    ActionReceiver(_outputController.stream);

    _tempoController = TempoController(tempo: 120);

    _keyboardController.stream.listen((action) {
      if (!_arpeggiators.containsKey(action.pointerId)) {
        _arpeggiators[action.pointerId] = Arpeggiator(_tempoController);
        _outputController.add(_keyboardActionToSynthCommand(action));
        _arpeggiators[action.pointerId].output.listen((playerAction) {
          _outputController
              .add(_playerActionToSynthCommand(playerAction, action.pointerId));
        });
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
    });
  }

  TempoController _tempoController;

  SynthCommand _playerActionToSynthCommand(PlayerAction action, int voiceId) =>
      action.velocity > 0
          ? SynthCommand(voiceId,
              modulation: action.modulation,
              freq: _getFreqFromStepOffset(
                  action.stepOffset, currentPreset.baseKey))
          : SynthCommand.stop(voiceId);

  SynthCommand _keyboardActionToSynthCommand(KeyboardAction action) =>
      action.pressure > 0
          ? SynthCommand(action.pointerId,
              modulation: action.modulation,
              freq: _getFreqFromStepOffset(
                  action.stepOffset, currentPreset.baseKey))
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
        );
        return Scaffold(
          body: Row(
            children: [
              PresetSelector(
                size: Size(controlPanelWidth, constraints.maxHeight),
                currentPreset: currentPreset,
                setPreset: setPreset,
                keyboardPresets: keyboardPresets,
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
            onPressed: toggleSettings,
            tooltip: 'Sound settings',
            child: const Icon(Icons.settings),
          ),
        );
      },
    );
  }
}
