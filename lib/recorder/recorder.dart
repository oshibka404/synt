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

  var _stateStreamController = StreamController<RecorderState>();
  Stream<RecorderState> get stateStream {
    return _stateStreamController.stream;
  }

  void startRec(Offset initialPosition) {
    _stateStreamController.add(RecorderState.recording);
    _currentRecord = Record(startPoint: initialPosition, startTime: DateTime.now());
  }

  void stopRec() {
    _stateStreamController.add(RecorderState.playing);
    records[_currentRecord.startTime] = _currentRecord;
    _currentRecord = null;
  }
}
