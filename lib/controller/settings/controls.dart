import 'dart:convert';

import 'package:flutter/material.dart';

import '../../faust_ui/faust_control.dart';
import '../../faust_ui/faust_ui.dart';
import '../../synth/dsp_api.dart';
import 'synth_controls.dart';

/// Settings screen
class Controls extends StatefulWidget {
  @override
  State<Controls> createState() => ControlsState();
}

class ControlsState extends State<Controls> {
  FaustUi faustUi;

  List<FaustControl> get controls => faustUi.items;

  @override
  Widget build(context) {
    if (faustUi == null) return Center();

    return SynthControls.fromFaustUi(faustUi);
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
}
