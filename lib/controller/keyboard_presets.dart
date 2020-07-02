import 'package:flutter/material.dart';

import 'keyboard_preset.dart';

List<KeyboardPreset> keyboardPresets = [
  KeyboardPreset(
    baseKey: 61,
    color: ColorSwatch<int>(0xFF3885ED, {
      200: Color(0xFF3885ED),
      900: Color(0xFF2f74d0),
    }),
  ),
  KeyboardPreset(
    baseKey: 37,
    color: ColorSwatch<int>(0xFFfbf043, {
      200: Color(0xFFfbf043),
      900: Color(0xFFe7dc33),
    }),
  ),
  KeyboardPreset(
    baseKey: 13,
    color: ColorSwatch<int>(0xFFf7642c, {
      200: Color(0xFFf7642c),
      900: Color(0xFFda4d17),
    }),
  ),
];
