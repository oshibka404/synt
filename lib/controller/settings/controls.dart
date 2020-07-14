import 'package:flutter/material.dart';

import '../../scales/scale_patterns.dart';
import '../keyboard_preset.dart';
import 'global_controls.dart';

/// Settings screen
class Controls extends StatelessWidget {
  final KeyboardPreset preset;
  final double tempo;
  final Function setTempo;
  final ScalePattern scale;
  final Function setScale;

  final void Function() clearAll;

  Controls(this.preset, this.tempo, this.setTempo, this.scale, this.setScale,
      this.clearAll);

  @override
  Widget build(context) {
    return ListView(
      children: [
        GlobalControls(tempo, setTempo, scale, setScale, clearAll),
      ],
    );
  }
}
