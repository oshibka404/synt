import 'package:flutter/material.dart';

import 'keyboard_colors.dart';
import 'synth_preset.dart';

class KeyboardPreset {
  final KeyboardColors color;
  final int baseKey;
  final SynthPreset synthPreset;
  final String arpeggio;
  KeyboardPreset({
    this.color = const KeyboardColors(
      0x0000,
      {
        'light': Colors.pink,
        'main': Colors.pinkAccent,
      },
    ),
    this.baseKey = 49,
    this.synthPreset,
    this.arpeggio,
  });
}
