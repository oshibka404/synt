import 'package:flutter/material.dart';

import 'keyboard_preset.dart';

class LoopView {
  final Offset position;

  final KeyboardPreset preset;

  final bool isPlaying;
  final bool isRecording;
  LoopView(this.position, this.preset, this.isPlaying, this.isRecording);
  LoopView assign({position, preset, isPlaying, isRecording}) {
    return LoopView(
      position ?? this.position,
      preset ?? this.preset,
      isPlaying ?? this.isPlaying,
      isRecording ?? this.isRecording,
    );
  }
}
