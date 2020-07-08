import 'package:flutter/material.dart';
import 'package:perfect_first_synth/controller/keyboard_preset.dart';

import '../../faust_ui/faust_control.dart';
import '../../faust_ui/faust_ui.dart';
import '../../synth/dsp_api.dart';

class SynthControls extends StatefulWidget {
  final FaustUi uiDescription;
  final KeyboardPreset preset;
  SynthControls.fromFaustUi(this.uiDescription, this.preset);
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
    String sliderKey = widget.preset.synthPreset.params.keys
        .firstWhere((key) => slider.address.contains(key), orElse: () => null);
    double sliderValue =
        sliderKey != null ? widget.preset.synthPreset.params[sliderKey] : null;

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(slider.label),
      Slider(
          value: params[slider.address] ?? sliderValue ?? slider.initialValue,
          min: slider.min,
          max: slider.max,
          divisions: (slider.max - slider.min) ~/ slider.step,
          activeColor: widget.preset.color,
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
