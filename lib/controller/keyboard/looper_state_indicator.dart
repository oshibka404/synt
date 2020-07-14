import 'package:flutter/material.dart';

import '../../synt_localizations.dart';

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
        _getRecordingStatusText(SyntLocalizations.of(context)),
      ),
    );
  }

  String _getRecordingStatusText(SyntLocalizations localizations) {
    if (isRecording) {
      return localizations.getLocalized('Recording');
    } else if (isInRecordingMode) {
      return localizations.getLocalized('Ready to record');
    } else {
      return '';
    }
  }
}
