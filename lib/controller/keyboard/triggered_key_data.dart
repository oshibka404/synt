import 'package:synt/controller/keyboard/presets/keyboard_preset.dart';

class TriggeredKeyData {
  final double velocity;
  final int keyNumber;
  final KeyboardPreset preset;
  final double modulation;

  TriggeredKeyData(this.velocity, this.keyNumber, this.modulation, this.preset);
}
