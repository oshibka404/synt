
import 'package:flutter/material.dart';

import '../../recorder/recorder.dart';
import '../keyboard_preset.dart';
import 'preset_button.dart';

class PresetSelector extends StatelessWidget {
  PresetSelector({
    @required this.size,
    @required this.currentPreset,
    @required this.setPreset,
    @required this.keyboardPresets,
  });
  final Size size;
  final KeyboardPreset currentPreset;
  final Function setPreset;
  final List<KeyboardPreset> keyboardPresets;

  List<PresetButton> _buildPresetButtons() {
    List<PresetButton> presetButtons = new List<PresetButton>();
    keyboardPresets.forEach((KeyboardPreset preset) {
      presetButtons.add(
        new PresetButton(
          onTapDown: () {
            setPreset(preset);
            Recorder().startRec();
          },
          onTapUp: Recorder().startRec,
          active: currentPreset == preset,
          size: Size(size.height / 3, size.width),
          color: preset.color,
        )
      );
    });
    return presetButtons;
  }

  Widget build(BuildContext context) {
    return Column(
      children: _buildPresetButtons(),
    );
  }
}
