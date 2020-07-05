import 'package:flutter/material.dart';
import 'package:perfect_first_synth/controller/keyboard_preset.dart';

import 'pointer_data.dart';

class VirtualPointerData implements PointerData {
  VirtualPointerData(
    this.origin,
    this.preset,
    this.pressure,
    this.position,
  );
  final Offset origin;
  final KeyboardPreset preset;
  final double pressure;
  final Offset position;
}
