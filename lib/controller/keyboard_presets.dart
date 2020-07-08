import 'package:flutter/material.dart';

import 'keyboard_preset.dart';

List<KeyboardPreset> keyboardPresets = [
  KeyboardPreset(
    baseKey: 61,
    color: ColorSwatch<int>(0xFF3885ED, {
      200: Color(0xFF3885ED),
      900: Color(0xFF2f74d0),
    }),
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
    color: ColorSwatch<int>(0xFFfbf043, {
      200: Color(0xFFfbf043),
      900: Color(0xFFe7dc33),
    }),
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
    color: ColorSwatch<int>(0xFFf7642c, {
      200: Color(0xFFf7642c),
      900: Color(0xFFda4d17),
    }),
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
