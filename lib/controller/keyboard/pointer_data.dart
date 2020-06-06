import 'package:flutter/material.dart';
import '../../synth/synthesizer.dart';

class PointerData {
  PointerData({this.position, this.voice});
  Offset position;
  Voice voice;
}