import 'package:flutter/material.dart';
import 'package:perfect_first_synth/synt_localizations.dart';

import '../../scales/scale_patterns.dart';

class GlobalSettingsView extends StatelessWidget {
  final ScalePattern _scale;
  final Function _setScale;

  final bool _syncEnabled;
  final Function _setSyncEnabled;

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
  final void Function() clearAll;

  GlobalSettingsView(this._tempo, this._setTempo, this._scale, this._setScale,
      this.clearAll, this._syncEnabled, this._setSyncEnabled);

  Widget build(BuildContext context) {
    String tempoString = SyntLocalizations.of(context).getLocalized("Tempo");
    String syncWithPoString =
        SyntLocalizations.of(context).getLocalized("Sync with Pocket Operator");

    return Column(
      children: [
        Row(
          children: [
            Text("$tempoString: "),
            Text("${_tempo.toStringAsFixed(0)}"), // TODO: use TextField
            Text(" bpm"),
          ],
        ),
        Slider(
          min: 60,
          max: 180,
          value: _tempo,
          activeColor: Colors.black,
          inactiveColor: Colors.grey,
          onChanged: (tempo) => _setTempo(tempo.roundToDouble()),
        ),
        Row(
          children: [
            Checkbox(value: _syncEnabled, onChanged: _setSyncEnabled),
            Text(syncWithPoString),
          ],
        ),
        Text(SyntLocalizations.of(context).getLocalized("Scale")),
        DropdownButton<ScalePattern>(
            value: _scale,
            items: scaleNames.keys
                .map<DropdownMenuItem<ScalePattern>>(
                    (scale) => DropdownMenuItem<ScalePattern>(
                          value: scale,
                          child: Text(SyntLocalizations.of(context)
                              .getLocalized(scaleNames[scale])),
                        ))
                .toList(),
            onChanged: _setScale),
        RaisedButton(
            child: Text(
                SyntLocalizations.of(context).getLocalized("Delete all loops")),
            onPressed: clearAll),
      ],
    );
  }
}
