import 'package:flutter/material.dart';

import 'loop_view.dart';

class LoopsLayer extends StatelessWidget {
  final Map<DateTime, LoopView> loops;
  final Size size;
  final Function toggleLoop;
  final Function deleteLoop;

  LoopsLayer(
      {@required this.size,
      @required this.loops,
      @required this.deleteLoop,
      @required this.toggleLoop});

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

      buttons.add(GestureDetector(
        child: Container(
          constraints: BoxConstraints.tight(Size.square(size.width)),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              loop.preset.color[200],
              loop.preset.color[900],
            ]),
          ),
          child: Icon(
            icon,
            color: Theme.of(context).backgroundColor,
          ),
        ),
        onTap: () {
          toggleLoop(time);
        },
        onLongPress: () {
          deleteLoop(time);
        },
      ));
    });
    return buttons;
  }
}
