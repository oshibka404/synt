import 'package:flutter/material.dart';

class RecorderStateIndicator extends StatelessWidget {
  RecorderStateIndicator({
    @required this.isRecording,
    @required this.isInRecordingMode,
  });
  final bool isRecording;
  final bool isInRecordingMode;

  String _getRecordingStatusText() {
    if (isRecording) {
      return 'Recording';
    } else if (isInRecordingMode) {
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
