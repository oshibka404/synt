import 'package:flutter/material.dart';

import '../keyboard/presets/keyboard_preset.dart';
import 'preset_button.dart';

class PresetSelector extends StatelessWidget {
  final Size size;
  final KeyboardPreset currentPreset;
  final Function setPreset;
  final List<KeyboardPreset> keyboardPresets;
  final Function onTapDown;
  final Function onTapUp;
  PresetSelector({
    @required this.size,
    @required this.currentPreset,
    @required this.setPreset,
    @required this.keyboardPresets,
    this.onTapDown,
    this.onTapUp,
  });

  Widget build(BuildContext context) {
    return Column(
      children: _buildPresetButtons(),
    );
  }

  List<PresetButton> _buildPresetButtons() {
    List<PresetButton> presetButtons = new List<PresetButton>();
    keyboardPresets.forEach((KeyboardPreset preset) {
      presetButtons.add(new PresetButton(
        onTapDown: () {
          setPreset(preset);
          if (onTapDown != null) {
            onTapDown();
          }
        },
        onTapUp: onTapUp,
        active: currentPreset == preset,
        size: Size(size.height / 3, size.width),
        color: preset.color,
      ));
    });
    return presetButtons;
  }
}
