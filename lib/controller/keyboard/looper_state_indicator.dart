import 'package:flutter/material.dart';

class LooperStateIndicator extends StatelessWidget {
  final bool isRecording;
  final bool isInRecordingMode;
  LooperStateIndicator({
    @required this.isRecording,
    @required this.isInRecordingMode,
  });

  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(6.0),
      child: Text(
        _getRecordingStatusText(),
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
