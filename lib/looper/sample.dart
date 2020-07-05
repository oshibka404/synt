import 'package:flutter/material.dart';
import 'package:perfect_first_synth/controller/keyboard_preset.dart';

import '../controller/keyboard/keyboard_action.dart';

/// [KeyboardAction] with fixed [preset] and
class Sample extends KeyboardAction {
  KeyboardPreset preset;
  Offset origin; // modulation + stepOffset
  Sample.from(KeyboardAction action, {this.preset, this.origin})
      : super.assign(action);
}
