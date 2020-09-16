import 'keyboard_colors.dart';
import 'synth_preset.dart';

class KeyboardPreset {
  final KeyboardColors color;
  final int baseKey;
  final SynthPreset synthPreset;
  final String arpeggio;
  KeyboardPreset({
    this.color,
    this.baseKey = 49,
    this.synthPreset,
    this.arpeggio,
  });
}
