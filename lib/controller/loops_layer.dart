import 'package:flutter/material.dart';
import 'package:perfect_first_synth/controller/inverting_button.dart';

import 'loop_view.dart';

class LoopsLayer extends StatelessWidget {
  LoopsLayer(
      {@required this.size,
      @required this.loops,
      @required this.deleteLoop,
      @required this.toggleLoop});
  final Map<DateTime, LoopView> loops;
  final Size size;
  final Function toggleLoop;
  final Function deleteLoop;

  Widget build(context) {
    return Column(
      children: [
        ..._getRecordButtons(context),
      ],
    );
  }

  List<Widget> _getRecordButtons(BuildContext context) {
    List<Widget> buttons = [];
    loops.forEach((time, loop) {
      IconData icon = Icons.play_arrow;
      if (loop.isRecording) {
        icon = Icons.fiber_manual_record;
      } else if (loop.isPlaying) {
        icon = Icons.pause;
      }

      buttons.add(InvertingButton(
        color: loop.preset.color,
        iconData: icon,
        onTap: () {
          toggleLoop(time);
        },
        onLongPress: () {
          deleteLoop(time);
        },
        size: Size.square(size.shortestSide),
      ));
    });
    return buttons;
  }
}
