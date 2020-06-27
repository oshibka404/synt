import 'package:flutter/material.dart';
import '../../recorder/state.dart';

class RecorderStateIndicator extends StatelessWidget {
  RecorderStateIndicator({
    @required this.state,
    @required this.isInRecordingMode,
  });
  final RecorderState state;
  final bool isInRecordingMode;

  String _getRecordingStatusText() {
    if (state == RecorderState.recording) {
      return 'Recording';
    } else if (state == RecorderState.playing && isInRecordingMode) {
      return 'Ready to record';
    } else {
      return '';
    }
  }

  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _getRecordingStatusText(),
            style: Theme.of(context).textTheme.headline4,
          )
        ],
      ),
    );
  }
}
