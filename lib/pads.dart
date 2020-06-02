
import 'package:flutter/material.dart';

class PadsPanel extends StatefulWidget {
  PadsPanel({Key key}) : super(key: key);

  @override
  _PadsPanelState createState() => _PadsPanelState();
}

class _PadsPanelState extends State<PadsPanel> {

  List<PadConfig> padConfigs = [
    PadConfig(440, Color(0xFFFF0000)),
    PadConfig(440, Color(0xFF00FF00)),
    PadConfig(440, Color(0xFF0000FF)),
  ];

  PadConfig currentPad;

  void _triggerPad(PadConfig element) {
    setState(() {
      currentPad = (currentPad == element) ? null : element;
    });
  }

  List<_Trigger> _buildPadTriggers(double height) {
    List<_Trigger> pads = new List<_Trigger>();
    padConfigs.forEach((PadConfig element) {
      pads.add(
        new _Trigger(
          element, 
          () => _triggerPad(element),
          currentPad == element,
          Size.square(height / padConfigs.length),
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

// TODO: abstract away Trigger from Pads
class _Trigger extends StatelessWidget {
  _Trigger(this.padConfig, this.onTrigger, this.triggered, this.size);
  final PadConfig padConfig;
  final Function onTrigger;
  final bool triggered;
  final Size size;
  
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTrigger,
      child: ConstrainedBox(
        constraints: BoxConstraints.tight(size),
        child: DecoratedBox(
          decoration: new BoxDecoration(
            // Flutter doesn't support inner shadows
            // hack from https://stackoverflow.com/questions/54061964/inner-shadow-effect-in-flutter
            color: Colors.transparent,
            boxShadow: [
              BoxShadow(
                color: triggered ? Colors.transparent : padConfig.color,
              ),
              BoxShadow(
                color: padConfig.color,
                spreadRadius: -8.0,
                blurRadius: 8.0,
              ),
            ],
          )
        )
      ),
    ) ;
  }
}

class PadConfig {
  PadConfig(this.pitch, this.color);
  final double pitch;
  final Color color;
}
