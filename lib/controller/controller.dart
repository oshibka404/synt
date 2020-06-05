import 'package:flutter/material.dart';

import 'package:perfect_first_synth/controller/mode_selector/mode_selector.dart';
import 'package:perfect_first_synth/controller/keyboard/keyboard.dart';

class Controller extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ControllerState();
}

class _ControllerState extends State<Controller> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double controlPanelWidth = constraints.maxHeight / 3;
        return Row(
          children: [
            TabsPanel(
              size: Size(controlPanelWidth, constraints.maxHeight),
            ),
            Keyboard(
              size: Size(constraints.maxWidth - controlPanelWidth, constraints.maxHeight),
              offset: Offset(controlPanelWidth, 0),
            ),
          ],
        );
      },
    );
  }
}