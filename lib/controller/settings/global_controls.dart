import 'package:flutter/material.dart';

import '../../scales/scale_patterns.dart';

class GlobalControls extends StatelessWidget {
  final ScalePattern _scale;
  final Function _setScale;

  final Map<ScalePattern, String> scaleNames = {
    ScalePattern.chromatic: 'Chromatic',

    ScalePattern.pentatonic: 'Pentatonic',
    ScalePattern.blues: 'Blues',

    ScalePattern.harmonicMinor: 'Harmonic minor',
    ScalePattern.melodicMinor: 'Melodic minor',

    // Diatonic scales
    ScalePattern.major: 'Major',
    ScalePattern.minor: 'Minor',
    ScalePattern.ionian: 'Ionian',
    ScalePattern.dorian: 'Dorian',
    ScalePattern.phrygian: 'Phrygian',
    ScalePattern.lydian: 'Lydian',
    ScalePattern.myxolydian: 'Myxolydian',
    ScalePattern.aeolian: 'Aeolian',
    ScalePattern.locrian: 'Locrian',
  };

  final double _tempo;
  final Function _setTempo;

  GlobalControls(this._tempo, this._setTempo, this._scale, this._setScale);

  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Tempo: ${_tempo.toStringAsFixed(0)} bpm"),
        Slider(
          min: 60,
          max: 120,
          value: _tempo,
          activeColor: Colors.black,
          inactiveColor: Colors.grey,
          onChanged: (tempo) => _setTempo(tempo.roundToDouble()),
        ),
        Text("Scale:"),
        DropdownButton<ScalePattern>(
            value: _scale,
            items: scaleNames.keys
                .map<DropdownMenuItem<ScalePattern>>(
                    (scale) => DropdownMenuItem<ScalePattern>(
                          value: scale,
                          child: Text(scaleNames[scale]),
                        ))
                .toList(),
            onChanged: _setScale),
      ],
    );
  }
}
