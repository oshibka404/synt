import 'package:flutter/material.dart';

import 'keyboard_preset.dart';
import 'preset_selector/preset_selector.dart';
import 'keyboard/keyboard.dart';

class Controller extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ControllerState();
}

class _ControllerState extends State<Controller> {
  static List<KeyboardPreset> keyboardModes = [
    KeyboardPreset(
      baseFreq: 440,
      baseKey: 49,
      color: Colors.blue,
    ),
    KeyboardPreset(
      baseFreq: 220,
      baseKey: 37,
      color: Colors.green,
    ),
    KeyboardPreset(
      baseFreq: 110,
      baseKey: 25,
      color: Colors.red,
    ),
  ];

  KeyboardPreset currentMode = keyboardModes[0];
  void setMode(KeyboardPreset mode) {
    currentMode = mode;
  }
  
  bool isRecording = false;
  bool isReadyToRecord = false;

  void startRec() {
    setState(() {
      isRecording = true;
    });
  }
  void setReadyToRecord() {
    setState(() {
      isReadyToRecord = true;
    });
  }
  void stopRec() {
    setState(() {
      isRecording = false;
      isReadyToRecord = false;
    });
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
              currentMode: currentMode,
              startRec: setReadyToRecord,
              stopRec: stopRec,
              setMode: setMode,
              keyboardPresets: keyboardModes,
            ),
            Keyboard(
              size: Size(constraints.maxWidth - controlPanelWidth, constraints.maxHeight),
              offset: Offset(controlPanelWidth, 0),
              mode: currentMode,
              isRecording: isRecording,
              isReadyToRecord: isReadyToRecord,
            ),
          ],
        );
      },
    );
  }
}