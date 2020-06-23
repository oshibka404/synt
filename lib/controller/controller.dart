import 'dart:async';

import 'package:flutter/material.dart';
import 'package:perfect_first_synth/synth/dsp_api.dart';

import 'keyboard_preset.dart';
import 'preset_selector/preset_selector.dart';
import 'keyboard/keyboard.dart';
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

  bool isInRecordMode = false;

  KeyboardPreset currentPreset = keyboardPresets[0];
  void setPreset(KeyboardPreset preset) {
    setState(() {
      currentPreset = preset;
    });
  }

  var _recordModeSwitchStreamController = StreamController<bool>();
  Stream<bool> get _recordModeSwitchStream {
    return _recordModeSwitchStreamController.stream;
  }

  void enableRecordMode() {
    _recordModeSwitchStreamController.add(true);
  }

  void disableRecordMode() {
    _recordModeSwitchStreamController.add(false);
  }

  bool _settingsOpen = false;

  void toggleSettings() {
    setState(() {
      _settingsOpen = !_settingsOpen;
      DspApi.allNotesOff();
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double controlPanelWidth = constraints.maxHeight / 3;
        var keyboardSize = Size(constraints.maxWidth - controlPanelWidth, constraints.maxHeight);
        var keyboard = Keyboard(
          size: keyboardSize,
          offset: Offset(controlPanelWidth, 0),
          preset: currentPreset,
          recordModeSwitchStream: _recordModeSwitchStream,
        );
        return Scaffold(
          body: Row(
            children: [
              PresetSelector(
                size: Size(controlPanelWidth, constraints.maxHeight),
                currentPreset: currentPreset,
                setPreset: setPreset,
                keyboardPresets: keyboardPresets,
                onTapDown: enableRecordMode,
                onTapUp: disableRecordMode,
              ),
              Stack(
                children: _settingsOpen ? [
                  keyboard,
                  Container(
                    constraints: BoxConstraints.tight(keyboardSize),
                    child: Settings(),
                    color: Theme.of(context).backgroundColor,
                  ),
                ] : [keyboard]
              ),
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
