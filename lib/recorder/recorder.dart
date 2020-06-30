import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../controller/keyboard/keyboard_action.dart';
import '../controller/keyboard_preset.dart';
import '../tempo_controller/tempo_controller.dart';
import 'recorded_action.dart';
import 'record.dart';

/// Class providing API to record sequences of actions
/// performed on controller.
class Recorder {
  Recorder({@required this.input, this.tempo}) {
    input.listen(_inputListener);
  }

  Duration get barDuration => tempo?.bar;

  final Stream<KeyboardAction> input;

  final TempoController tempo;

  final records = Map<DateTime, Record>();

  void _inputListener(KeyboardAction action) {
    if (_currentRecord != null) {
      _currentRecord.add(action);
    }
    _outputController.add(RecordedAction.from(action));
  }

  Record _currentRecord;

  var _outputController = StreamController<RecordedAction>();

  Stream<RecordedAction> get output {
    return _outputController.stream;
  }

  bool _isRecording = false;

  bool get isRecording => _isRecording;

  void loop(Record record) {
    record.play().listen((action) {
      _outputController.add(action);
    });
    Future.delayed(record.duration, () {
      loop(record);
    });
  }

  var _stateStreamController = StreamController<bool>();
  Stream<bool> get stateStream {
    return _stateStreamController.stream;
  }

  Duration _computeIntendedDuration(Duration recordedDuration) {
    if (recordedDuration == barDuration) {
      return recordedDuration;
    }

    Duration intendedDuration;
    double measuresInRecord =
        recordedDuration.inMicroseconds / barDuration.inMicroseconds;

    int bars = measuresInRecord > 1
        ? pow(2, (log(measuresInRecord) / ln2).round())
        : 1;

    intendedDuration =
        Duration(microseconds: barDuration.inMicroseconds * bars);
    return intendedDuration;
  }

  /// Creates [Record] and starts writing actions received from [input] to it.
  /// Returns start time to be used as the record's id.
  DateTime startRec(Offset initialPosition, KeyboardPreset preset) {
    var startTime = DateTime.now();
    _isRecording = true;
    _currentRecord = Record(
        startPoint: initialPosition, startTime: startTime, preset: preset);
    return startTime;
  }

  /// Stops recording, decorates the finished record with [Record..duration]
  /// and adds it to [records].
  void stopRec() {
    _isRecording = false;

    if (_currentRecord == null || _currentRecord.isEmpty) return;

    var recordedDuration = DateTime.now().difference(_currentRecord.startTime);

    _currentRecord.duration = _computeIntendedDuration(recordedDuration);

    records[_currentRecord.startTime] = _currentRecord;

    _currentRecord.close();

    Duration delayBeforePlay = _currentRecord.duration >= recordedDuration
        ? _currentRecord.duration - recordedDuration
        : _currentRecord.duration * 2 - recordedDuration;

    var startTime = _currentRecord.startTime;

    Future.delayed(delayBeforePlay, () => loop(records[startTime]));
    _currentRecord = null;
  }
}
