import 'dart:async';

import 'package:flutter/material.dart';
import 'package:perfect_first_synth/controller/keyboard/keyboard_action.dart';

import 'record.dart';
import 'state.dart';

/// Class providing API to record sequences of actions
/// performed on controller.
class Recorder {
  Recorder({
    this.initialState = RecorderState.playing,
    @required this.input,
  }) {
    _stateStreamController.add(initialState);
    input.listen(inputListener);
  }

  final RecorderState initialState;

  final Stream<KeyboardAction> input;

  final records = Map<DateTime, Record>();

  void inputListener(KeyboardAction action) {
    if (_currentRecord != null) {
      _currentRecord.actions.add(action);
    }
    _outputController.add(action);
  }

  Record _currentRecord;

  var _outputController = StreamController<KeyboardAction>();
  
  Stream<KeyboardAction> get output {
    return _outputController.stream;
  }

  void play(Record record) {
    record.actions.forEach((action) {
      var delayFromPlayStartTime = action.time.difference(record.startTime);
      Future.delayed(delayFromPlayStartTime, () {
        _outputController.add(action);
      });
    });
    Future.delayed(record.duration, () {
      play(record);
    });
  }

  var _stateStreamController = StreamController<RecorderState>();
  Stream<RecorderState> get stateStream {
    return _stateStreamController.stream;
  }

  /// Creates [Record] and starts writing actions received from [input] to it.
  /// Returns start time to be used as the record's id.
  DateTime startRec(Offset initialPosition) {
    var startTime = DateTime.now();
    _stateStreamController.add(RecorderState.recording);
    _currentRecord = Record(startPoint: initialPosition, startTime: startTime);
    return startTime;
  }

  /// Stops recording, decorates the finished record with [Record..duration] 
  /// and adds it to [records].
  void stopRec() {
    _stateStreamController.add(RecorderState.playing);
    _currentRecord.duration = DateTime.now().difference(_currentRecord.startTime);
    records[_currentRecord.startTime] = _currentRecord;
    play(_currentRecord);
    _currentRecord = null;
  }
}
