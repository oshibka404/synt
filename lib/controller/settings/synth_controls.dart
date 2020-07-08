import 'package:flutter/material.dart';

import '../../faust_ui/faust_control.dart';
import '../../faust_ui/faust_ui.dart';
import '../../synth/dsp_api.dart';

class SynthControls extends StatefulWidget {
  final FaustUi uiDescription;
  SynthControls.fromFaustUi(this.uiDescription);
  @override
  State<StatefulWidget> createState() => SynthControlsState();
}

class SynthControlsState extends State<SynthControls> {
  Map<String, double> params = {};

  build(context) {
    return ListView(
      children: widget.uiDescription.items
          .map<Widget>((control) => _buildControl(control))
          .toList(),
    );
  }

  Widget _buildControl(FaustControl control) {
    if (control is FaustGroup) return _buildGroup(control);
    if (control is FaustSlider) return _buildSlider(control);
    return Container();
  }

  Widget _buildGroup(FaustGroup group) {
    return Column(
      children: [
        if (group.items.length > 1)
          Text(
            group.label,
            style: TextStyle(height: 1.5, fontWeight: FontWeight.bold),
          ),
        ...group.items.map<Widget>((control) => _buildControl(control)),
      ],
    );
  }

  Widget _buildSlider(FaustSlider slider) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(slider.label),
      Slider(
          value: params[slider.address] ?? slider.initialValue,
          min: slider.min,
          max: slider.max,
          divisions: (slider.max - slider.min) ~/ slider.step,
          onChanged: (newValue) => _setParam(slider.address, newValue)),
    ]);
  }

  void _setParam(String address, double value) {
    DspApi.setParamValueByPath(address, value);
    setState(() {
      params[address] = value;
    });
  }
}
