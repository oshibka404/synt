import 'package:flutter/material.dart';

class KeyboardMode {
  KeyboardMode({
    this.color = Colors.pink,
    this.baseFreq = 440,
    this.baseKey = 49,
  });
  final Color color;
  final double baseFreq;
  final int baseKey;
}
