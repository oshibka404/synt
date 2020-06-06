import 'package:flutter/material.dart';
import 'mode.dart';

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

  KeyboardPreset currentPreset = keyboardPresets[0];
  void setPreset(KeyboardPreset preset) {
    currentPreset = preset;
  }
  
  Mode mode;

  void startRec() {
    setState(() {
      mode = Mode.recording;
    });
  }
  void setReadyToRecord() {
    setState(() {
      mode = Mode.ready;
    });
  }
  void stopRec() {
    setState(() {
      mode = Mode.playing;
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
              currentPreset: currentPreset,
              startRec: setReadyToRecord,
              stopRec: stopRec,
              setPreset: setPreset,
              keyboardPresets: keyboardPresets,
            ),
            Keyboard(
              size: Size(constraints.maxWidth - controlPanelWidth, constraints.maxHeight),
              offset: Offset(controlPanelWidth, 0),
              preset: currentPreset,
              mode: mode,
            ),
          ],
        );
      },
    );
  }
}