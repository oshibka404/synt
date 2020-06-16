import 'dart:async';

import 'package:flutter/material.dart';

import 'keyboard_preset.dart';
import 'preset_selector/preset_selector.dart';
import 'keyboard/keyboard.dart';

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
      color: Colors.green,
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
  
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double controlPanelWidth = constraints.maxHeight / 3;
        return Row(
          children: [
            PresetSelector(
              size: Size(controlPanelWidth, constraints.maxHeight),
              currentPreset: currentPreset,
              setPreset: setPreset,
              keyboardPresets: keyboardPresets,
              onTapDown: enableRecordMode,
              onTapUp: disableRecordMode,
            ),
            Keyboard(
              size: Size(constraints.maxWidth - controlPanelWidth, constraints.maxHeight),
              offset: Offset(controlPanelWidth, 0),
              preset: currentPreset,
              recordModeSwitchStream: _recordModeSwitchStream,
            ),
          ],
        );
      },
    );
  }
}
