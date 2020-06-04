
import 'package:flutter/material.dart';
import 'package:perfect_first_synth/trigger.dart';

class RecordControlPanel extends StatefulWidget {
  RecordControlPanel({Key key}) : super(key: key);

  @override
  _RecordControlPanelState createState() => _RecordControlPanelState();
}

class _RecordControlPanelState extends State<RecordControlPanel> {

  List<PadConfig> padConfigs = [
    PadConfig(440, Color.fromRGBO(255, 99, 119, 1)),
    PadConfig(440, Color.fromRGBO(200, 188, 245, 1)),
    PadConfig(440, Color.fromRGBO(101, 214, 209, 1)),
  ];

  PadConfig currentPad;

  void _triggerPad(PadConfig element) {
    setState(() {
      currentPad = (currentPad == element) ? null : element;
    });
  }

  List<Trigger> _buildPadTriggers(double height) {
    List<Trigger> pads = new List<Trigger>();
    padConfigs.forEach((PadConfig element) {
      pads.add(
        new Trigger(
          onTap: () => _triggerPad(element),
          active: currentPad == element,
          size: Size.square(height / padConfigs.length),
          color: element.color,
        )
      );
    });
    return pads;
  }

  Widget build(BuildContext context) {
    return Column(
      children: _buildPadTriggers(MediaQuery.of(context).size.height),
    );
  }
}

class PadConfig {
  PadConfig(this.pitch, this.color);
  final double pitch;
  final Color color;
}
