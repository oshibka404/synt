import 'package:flutter/material.dart';

import 'keyboard_colors.dart';
import 'keyboard_preset.dart';
import 'synth_preset.dart';

List<KeyboardPreset> keyboardPresets = [
  KeyboardPreset(
    baseKey: 61,
    color: KeyboardColors(0xFF3885ED, {
      'light': Color(0xFF3885ED),
      'main': Color(0xFF2f74d0),
    }),
    arpeggio: 'melody',
    synthPreset: SynthPreset({
      'Pulse/Level': 0.3,
      'Triangle/Level': 1,
      'Saw/Level': 0.2,
      'Pulse/Attack': 1,
      'Saw/Attack': 1,
      'Pulse/Duty': 0.5,
      'Triangle/Attack': 1,
      'Pulse/Sustain': 1,
      'Filter/Cutoff': 4000,
      'Envelope/Attack': 1,
    }),
  ),
  KeyboardPreset(
    baseKey: 37,
    color: KeyboardColors(0xFFfbf043, {
      'light': Color(0xFFfbf043),
      'main': Color(0xFFe7dc33),
    }),
    arpeggio: 'harmony',
    synthPreset: SynthPreset({
      'Pulse/Level': 0.5,
      'Triangle/Level': 0.4,
      'Saw/Level': 0.3,
      'Pulse/Attack': 0.1,
      'Pulse/Duty': 0.25,
      'Triangle/Attack': 0.1,
      'Saw/Attack': 0.2,
      'Pulse/Sustain': 0.2,
      'Filter/Cutoff': 2000,
    }),
  ),
  KeyboardPreset(
    baseKey: 13,
    color: KeyboardColors(0xFFf7642c, {
      'light': Color(0xFFf7642c),
      'main': Color(0xFFda4d17),
    }),
    arpeggio: 'bass',
    synthPreset: SynthPreset({
      'Pulse/Level': 1,
      'Triangle/Level': 1,
      'Saw/Level': 1,
      'Pulse/Duty': 0.5,
      'Pulse/Attack': 0.001,
      'Pulse/Decay': 0.5,
      'Pulse/Sustain': 0.3,
      'Pulse/Release': 0.1,
      'Triangle/Attack': 0.2,
      'Triangle/Decay': 1,
      'Triangle/Sustain': 1,
      'Triangle/Release': .2,
      'Saw/Attack': 0.1,
      'Saw/Decay': 0.3,
      'Saw/Sustain': 0.1,
      'Saw/Release': 0.3,
      'Filter/Cutoff': 700,
    }),
  ),
];
