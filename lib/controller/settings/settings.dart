import 'dart:ui';

import 'package:flutter/material.dart';

import '../../scales/scale_patterns.dart';
import '../../synt_localizations.dart';
import '../keyboard/presets/keyboard_preset.dart';
import 'global_settings.dart';

class Settings extends StatelessWidget {
  final KeyboardPreset preset;
  final double tempo;
  final Function setTempo;
  final ScalePattern scale;
  final Function setScale;
  final bool syncEnabled;
  final Function setSyncEnabled;

  final void Function() clearAll;

  Settings(
    this.preset,
    this.tempo,
    this.setTempo,
    this.scale,
    this.setScale,
    this.clearAll,
    this.syncEnabled,
    this.setSyncEnabled,
  );

  @override
  Widget build(context) {
    return Stack(
      children: [
        ListView(
          children: [
            GlobalSettings(
              tempo,
              setTempo,
              scale,
              setScale,
              clearAll,
              syncEnabled,
              setSyncEnabled,
            ),
          ],
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Text(
            SyntLocalizations.of(context).getLocalized('Synt by Ozornin'),
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12,
              backgroundColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
