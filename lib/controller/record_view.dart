import 'package:flutter/material.dart';

import 'keyboard_preset.dart';

class RecordView {
  RecordView(this.position, this.preset, this.isPlaying, this.isRecording);

  RecordView assign({position, preset, isPlaying, isRecording}) {
    return RecordView(
      position ?? this.position,
      preset ?? this.preset,
      isPlaying ?? this.isPlaying,
      isRecording ?? this.isRecording,
    );
  }

  final Offset position;
  final KeyboardPreset preset;
  final bool isPlaying;
  final bool isRecording;
}
