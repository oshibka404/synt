import 'package:flutter/material.dart';

class KeyboardColors extends ColorSwatch<String> {
  const KeyboardColors(int primary, Map<String, Color> swatch)
      : super(primary, swatch);
  Color get main => this['main'];
  Color get light => this['light'];
  Color get heavy => this['heavy'];
}
