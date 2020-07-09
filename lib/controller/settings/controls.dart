import 'dart:convert';

import 'package:flutter/material.dart';

import '../../faust_ui/faust_ui.dart';
import '../../synth/dsp_api.dart';
import '../keyboard_preset.dart';
import 'synth_controls.dart';

/// Settings screen
class Controls extends StatefulWidget {
  final KeyboardPreset preset;

  Controls(this.preset);

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
        GlobalControls(),
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
  // TODO: implement build
  Widget build(BuildContext context) => Container();
}
