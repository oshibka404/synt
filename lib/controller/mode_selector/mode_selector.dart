
import 'package:flutter/material.dart';
import 'package:perfect_first_synth/controller/mode_selector/mode_button.dart';

class TabsPanel extends StatefulWidget {
  TabsPanel({this.size});
  final Size size;
  @override
  _TabsPanelState createState() => _TabsPanelState();
}

class _TabsPanelState extends State<TabsPanel> {

  List<KeyboardMode> keyboardModes = [
    KeyboardMode(
      baseFreq: 440,
      baseKey: 49,
      color: Color.fromRGBO(255, 99, 119, 1),
    ),
    KeyboardMode(
      baseFreq: 220,
      baseKey: 37,
      color: Color.fromRGBO(200, 188, 245, 1),
    ),
    KeyboardMode(
      baseFreq: 110,
      baseKey: 25,
      color: Color.fromRGBO(101, 214, 209, 1),
    ),
  ];

  KeyboardMode currentPad;

  void _triggerPad(KeyboardMode element) {
    setState(() {
      currentPad = (currentPad == element) ? null : element;
    });
  }

  List<ModeButton> _buildPadModeButtons() {
    List<ModeButton> pads = new List<ModeButton>();
    keyboardModes.forEach((KeyboardMode element) {
      pads.add(
        new ModeButton(
          onTap: () => _triggerPad(element),
          active: currentPad == element,
          size: Size(widget.size.height / 3, widget.size.width),
          color: element.color,
        )
      );
    });
    return pads;
  }

  Widget build(BuildContext context) {
    return Column(
      children: _buildPadModeButtons(),
    );
  }
}

class KeyboardMode {
  KeyboardMode({
    this.color = Colors.pink,
    this.baseFreq = 440,
    this.baseKey = 49,
  });
  final Color color;
  final double baseFreq;
  final int baseKey;
}
