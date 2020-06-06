
import 'package:flutter/material.dart';
import '../keyboard_mode.dart';
import 'mode_button.dart';

class ModeSelector extends StatelessWidget {
  ModeSelector({
    @required this.size,
    @required this.currentMode,
    @required this.startRec,
    @required this.stopRec,
    @required this.setMode,
    @required this.modes,
  });
  final Size size;
  final KeyboardMode currentMode;
  final Function startRec;
  final Function stopRec;
  final Function setMode;
  final List<KeyboardMode> modes;

  List<ModeButton> _buildModeButtons() {
    List<ModeButton> modeButtons = new List<ModeButton>();
    modes.forEach((KeyboardMode mode) {
      modeButtons.add(
        new ModeButton(
          onTapDown: () {
            setMode(mode);
            startRec();
          },
          onTapUp: stopRec,
          active: currentMode == mode,
          size: Size(size.height / 3, size.width),
          color: mode.color,
        )
      );
    });
    return modeButtons;
  }

  Widget build(BuildContext context) {
    return Column(
      children: _buildModeButtons(),
    );
  }
}
