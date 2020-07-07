import 'dart:convert';

import 'package:flutter/material.dart';
import '../faust_ui/faust_ui.dart';
import '../faust_ui/faust_control.dart';
import '../synth/dsp_api.dart';

/// Settings screen
class Controls extends StatefulWidget {
  @override
  State<Controls> createState() => ControlsState();
}

class Param {
  Param(
      this.label, this.initialValue, this.min, this.max, this.step, this.type);
  double get value => _value ?? initialValue;
  double _value;
  set value(double newValue) => _value = newValue;
  final double min;
  final double max;
  final double initialValue;
  final double step;
  final String label;
  final String type; // enum
}

class ControlsState extends State<Controls> {
  FaustUi faustUi;

  List<FaustControl> get controls => faustUi.items;

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

  @override
  Widget build(context) {
    if (faustUi == null) return Center();

    return SynthControls.fromFaustUi(faustUi);
  }
}

class SynthControls extends StatefulWidget {
  final FaustUi uiDescription;
  SynthControls.fromFaustUi(this.uiDescription);
  @override
  State<StatefulWidget> createState() => SynthControlsState();
}

class SynthControlsState extends State<SynthControls> {
  Map<String, double> params = {};

  Widget _buildGroup(FaustGroup group) {
    return Column(
      children: [
        Text(group.label),
        ...group.items.map<Widget>((control) => _buildControl(control)),
      ],
    );
  }

  Widget _buildSlider(FaustSlider slider) {
    return Row(children: [
      Text(slider.label),
      Slider(
          value: params[slider.address] ?? slider.initialValue,
          min: slider.min,
          max: slider.max,
          divisions: (slider.max - slider.min) ~/ slider.step,
          onChanged: (newValue) => _setParam(slider.address, newValue)),
    ]);
  }

  Widget _buildControl(FaustControl control) {
    if (control is FaustGroup) return _buildGroup(control);
    if (control is FaustSlider) return _buildSlider(control);
    return Container();
  }

  void _setParam(String address, double value) {
    DspApi.setParamValueByPath(address, value);
    setState(() {
      params[address] = value;
    });
  }

  build(context) {
    return ListView(
      children: widget.uiDescription.items
          .map<Widget>((control) => _buildControl(control))
          .toList(),
    );
  }
}
