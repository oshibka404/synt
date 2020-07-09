import 'dart:convert';

import 'package:flutter/material.dart';

import '../../faust_ui/faust_ui.dart';
import '../../synth/dsp_api.dart';
import '../keyboard_preset.dart';
import '../scales.dart';
import 'synth_controls.dart';

/// Settings screen
class Controls extends StatefulWidget {
  final KeyboardPreset preset;
  final double tempo;
  final Function setTempo;
  final Scale scale;
  final Function setScale;

  Controls(this.preset, this.tempo, this.setTempo, this.scale, this.setScale);

  @override
  State<Controls> createState() => ControlsState();
}

class ControlsState extends State<Controls> {
  FaustUi faustUi;

  bool _advancedExpanded = false;

  @override
  Widget build(context) {
    if (faustUi == null) return Center();

    return ListView(
      children: [
        GlobalControls(
            widget.tempo, widget.setTempo, widget.scale, widget.setScale),
        RaisedButton(
            color: widget.preset.color,
            child: Text('›ﬁÔÓ ˘¯Âı˜Â˝'),
            onPressed: _toggleAdvancedSettings),
        if (_advancedExpanded)
          SynthControls.fromFaustUi(faustUi, widget.preset),
      ],
    );
  }

  @override
  void initState() {
    _getInitialParams();
    super.initState();
  }

  void _getInitialParams() async {
    String jsonUi = await DspApi.getJsonUi();
    Map<String, dynamic> uiParams = jsonDecode(jsonUi);
    setState(() {
      faustUi = FaustUi.fromJson(uiParams);
    });
  }

  _toggleAdvancedSettings() {
    setState(() {
      _advancedExpanded = !_advancedExpanded;
    });
  }
}

class GlobalControls extends StatelessWidget {
  final Scale _scale;
  final Function _setScale;

  final Map<Scale, String> scaleNames = {
    Scale.chromatic: 'Chromatic',

    Scale.pentatonic: 'Pentatonic',
    Scale.blues: 'Blues',

    Scale.harmonicMinor: 'Harmonic minor',
    Scale.melodicMinor: 'Melodic minor',

    // Diatonic scales
    Scale.major: 'Major',
    Scale.minor: 'Minor',
    Scale.ionian: 'Ionian',
    Scale.dorian: 'Dorian',
    Scale.phrygian: 'Phrygian',
    Scale.lydian: 'Lydian',
    Scale.myxolydian: 'Myxolydian',
    Scale.aeolian: 'Aeolian',
    Scale.locrian: 'Locrian',
  };

  final double _tempo;
  final Function _setTempo;
  GlobalControls(this._tempo, this._setTempo, this._scale, this._setScale);
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Tempo: ${_tempo.toStringAsFixed(0)}"),
        Slider(
          min: 60,
          max: 240,
          value: _tempo,
          onChanged: (tempo) => _setTempo(tempo.roundToDouble()),
        ),
        Text("Scale:"),
        DropdownButton<Scale>(
            value: _scale,
            items: scaleNames.keys
                .map<DropdownMenuItem<Scale>>(
                    (scale) => DropdownMenuItem<Scale>(
                          value: scale,
                          child: Text(scaleNames[scale]),
                        ))
                .toList(),
            onChanged: _setScale)
      ],
    );
  }
}
