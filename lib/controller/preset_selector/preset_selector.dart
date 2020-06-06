
import 'package:flutter/material.dart';
import '../keyboard_preset.dart';
import 'preset_button.dart';

class PresetSelector extends StatelessWidget {
  PresetSelector({
    @required this.size,
    @required this.currentMode,
    @required this.startRec,
    @required this.stopRec,
    @required this.setMode,
    @required this.keyboardPresets,
  });
  final Size size;
  final KeyboardPreset currentMode;
  final Function startRec;
  final Function stopRec;
  final Function setMode;
  final List<KeyboardPreset> keyboardPresets;

  List<ModeButton> _buildModeButtons() {
    List<ModeButton> modeButtons = new List<ModeButton>();
    keyboardPresets.forEach((KeyboardPreset mode) {
      modeButtons.add(
        new ModeButton(
          onTapDown: () {
            setMode(mode);
            startRec();
          },
          onTapUp: stopRec,
          active: currentMode == mode,
          size: Size(size.height / 3, size.width),
          color: mode.color,
        )
      );
    });
    return modeButtons;
  }

  Widget build(BuildContext context) {
    return Column(
      children: _buildModeButtons(),
    );
  }
}
