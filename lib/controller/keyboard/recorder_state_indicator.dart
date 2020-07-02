import 'package:flutter/material.dart';

class RecorderStateIndicator extends StatelessWidget {
  final bool isRecording;
  final bool isInRecordingMode;
  RecorderStateIndicator({
    @required this.isRecording,
    @required this.isInRecordingMode,
  });

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

  String _getRecordingStatusText() {
    if (isRecording) {
      return 'Recording';
    } else if (isInRecordingMode) {
      return 'Ready to record';
    } else {
      return '';
    }
  }
}
