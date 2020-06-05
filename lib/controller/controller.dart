import 'package:flutter/material.dart';
import 'package:perfect_first_synth/controller/keyboard_mode.dart';

import 'package:perfect_first_synth/controller/mode_selector/mode_selector.dart';
import 'package:perfect_first_synth/controller/keyboard/keyboard.dart';

class Controller extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ControllerState();
}

class _ControllerState extends State<Controller> {
  static List<KeyboardMode> keyboardModes = [
    KeyboardMode(
      baseFreq: 440,
      baseKey: 49,
      color: Colors.blue,
    ),
    KeyboardMode(
      baseFreq: 220,
      baseKey: 37,
      color: Colors.green,
    ),
    KeyboardMode(
      baseFreq: 110,
      baseKey: 25,
      color: Colors.red,
    ),
  ];

  KeyboardMode currentMode = keyboardModes[0];
  void setMode(KeyboardMode mode) {
    currentMode = mode;
  }
  
  bool isRecording = false;
  void startRec() {
    setState(() {
      isRecording = true;
    });
  }
  void stopRec() {
    setState(() {
      isRecording = false;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double controlPanelWidth = constraints.maxHeight / 3;
        return Row(
          children: [
            ModeSelector(
              size: Size(controlPanelWidth, constraints.maxHeight),
              currentMode: currentMode,
              startRec: startRec,
              stopRec: stopRec,
              setMode: setMode,
              modes: keyboardModes,
            ),
            Keyboard(
              size: Size(constraints.maxWidth - controlPanelWidth, constraints.maxHeight),
              offset: Offset(controlPanelWidth, 0),
              mode: currentMode,
              isRecording: isRecording,
            ),
          ],
        );
      },
    );
  }
}