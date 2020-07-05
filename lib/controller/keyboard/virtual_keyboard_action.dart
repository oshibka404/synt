import 'package:flutter/material.dart';

import '../keyboard_preset.dart';

class VirtualKeyboardAction {
  VirtualKeyboardAction(this.origin, this.preset, this.pressure, this.position);

  // stepOffset + modulation
  final Offset origin;
  final KeyboardPreset preset;
  final double pressure;

  // stepOffset + modulation
  final Offset position;
}
