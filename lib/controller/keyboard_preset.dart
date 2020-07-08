import 'package:flutter/material.dart';

class KeyboardPreset {
  final ColorSwatch color;
  final int baseKey;
  final SynthPreset synthPreset;
  KeyboardPreset({
    this.color = Colors.pink,
    this.baseKey = 49,
    this.synthPreset,
  });
}

class SynthPreset {
  final Map<String, double> params;
  SynthPreset(this.params);

  operator [](String key) => params[key];
  operator []=(String key, double value) {
    params[key] = value;
  }
}
