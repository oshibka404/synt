import 'package:flutter/material.dart';
import 'package:perfect_first_synth/controller/record_view.dart';

class RecordsLayer extends StatelessWidget {
  final Map<DateTime, RecordView> recordViews;
  final Size size;
  final double pixelsPerStep;
  final Function toggleRecord;
  final Function deleteRecord;
  final double _iconSize = 24;

  final double _buttonPadding = 8;
  RecordsLayer(
      {@required this.size,
      @required this.recordViews,
      @required this.deleteRecord,
      @required this.pixelsPerStep,
      @required this.toggleRecord});
  get _buttonSize => _iconSize + 2 * _buttonPadding;

  // TODO: use something other than Offset for normalized positions
  Widget build(context) {
    return Stack(
      children: _getRecordButtons(context),
    );
  }

  Offset _getDenormalizedOffset(Offset normalizedPosition) {
    return Offset(normalizedPosition.dx * pixelsPerStep,
        (1 - normalizedPosition.dy) * size.height);
  }

  List<Widget> _getRecordButtons(BuildContext context) {
    List<Widget> buttons = [];
    recordViews.forEach((time, recordView) {
      var offsetInPixels = _getDenormalizedOffset(recordView.position);

      IconData icon = Icons.play_arrow;
      if (recordView.isRecording) {
        icon = Icons.fiber_manual_record;
      } else if (recordView.isPlaying) {
        icon = Icons.pause;
      }

      buttons.add(Positioned(
          left: offsetInPixels.dx - _buttonSize / 2,
          top: offsetInPixels.dy - _buttonSize / 2,
          child: GestureDetector(
            child: Container(
              decoration: ShapeDecoration(
                gradient: LinearGradient(colors: [
                  recordView.preset.color[200],
                  recordView.preset.color[900],
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
              toggleRecord(time);
            },
            onLongPress: () {
              deleteRecord(time);
            },
          )));
    });
    return buttons;
  }
}
