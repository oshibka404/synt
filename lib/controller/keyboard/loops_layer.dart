import 'package:flutter/material.dart';
import 'package:perfect_first_synth/controller/loop_view.dart';

class LoopsLayer extends StatelessWidget {
  final Map<DateTime, LoopView> loops;
  final Size size;
  final double pixelsPerStep;
  final Function toggleLoop;
  final Function deleteRecord;
  final double _iconSize = 24;
  final double sidePadding;

  final double _buttonPadding = 8;
  LoopsLayer(
      {@required this.size,
      @required this.loops,
      @required this.deleteRecord,
      @required this.pixelsPerStep,
      @required this.sidePadding,
      @required this.toggleLoop});
  get _buttonSize => _iconSize + 2 * _buttonPadding;

  // TODO: use something other than Offset for normalized positions
  Widget build(context) {
    return Stack(
      children: _getRecordButtons(context),
    );
  }

  Offset _getDenormalizedOffset(Offset normalizedPosition) {
    return Offset(normalizedPosition.dx * pixelsPerStep + sidePadding,
        (1 - normalizedPosition.dy) * size.height);
  }

  List<Widget> _getRecordButtons(BuildContext context) {
    List<Widget> buttons = [];
    loops.forEach((time, loop) {
      var offsetInPixels = _getDenormalizedOffset(loop.position);

      IconData icon = Icons.play_arrow;
      if (loop.isRecording) {
        icon = Icons.fiber_manual_record;
      } else if (loop.isPlaying) {
        icon = Icons.pause;
      }

      buttons.add(Positioned(
          left: offsetInPixels.dx - _buttonSize / 2,
          top: offsetInPixels.dy - _buttonSize / 2,
          child: GestureDetector(
            child: Container(
              decoration: ShapeDecoration(
                gradient: LinearGradient(colors: [
                  loop.preset.color[200],
                  loop.preset.color[900],
                ]),
                shape: CircleBorder(),
              ),
              child: Icon(
                icon,
                color: Theme.of(context).backgroundColor,
                size: _iconSize,
              ),
              padding: EdgeInsets.all(_buttonPadding),
            ),
            onTap: () {
              toggleLoop(time);
            },
            onLongPress: () {
              deleteRecord(time);
            },
          )));
    });
    return buttons;
  }
}
