import 'dart:async';
import 'dart:math';

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
    this.measureDuration,
  }) {
    _stateStreamController.add(initialState);
    _state = initialState;
    input.listen(_inputListener);
  }

  final RecorderState initialState;

  Duration measureDuration;

  final Stream<KeyboardAction> input;

  final records = Map<DateTime, Record>();

  void _inputListener(KeyboardAction action) {
    if (_currentRecord != null) {
      _currentRecord.add(action);
    }
    _outputController.add(action);
  }

  Record _currentRecord;

  var _outputController = StreamController<KeyboardAction>();
  
  Stream<KeyboardAction> get output {
    return _outputController.stream;
  }

  RecorderState _state;

  get state => _state;

  set state(value) {
    _state = value;
    _stateStreamController.add(value);
  }

  // TODO: create class Looper/Loop
  void loop(Record record) {
    print(record.startTime);
    record.play().listen((action) {
      _outputController.add(action);
    });
    Future.delayed(record.duration, () {
      loop(record);
    });
  }

  var _stateStreamController = StreamController<RecorderState>();
  Stream<RecorderState> get stateStream {
    return _stateStreamController.stream;
  }

  Duration _computeIntendedDuration(Duration recordedDuration) {
    if (recordedDuration == measureDuration) {
      return recordedDuration;
    }
    
    Duration intendedDuration;
    double measuresInRecord = recordedDuration.inMicroseconds / measureDuration.inMicroseconds;

    // TODO: compute fractions (ln 2 not initialized)
    int bars = measuresInRecord > 1 ? pow(2, (log(measuresInRecord) / ln2).round()) : 1;
    
    intendedDuration = Duration(
      microseconds: measureDuration.inMicroseconds * bars
    );
    return intendedDuration;
  }

  /// Creates [Record] and starts writing actions received from [input] to it.
  /// Returns start time to be used as the record's id.
  DateTime startRec(Offset initialPosition) {
    var startTime = DateTime.now();
    state = RecorderState.recording;
    _currentRecord = Record(startPoint: initialPosition, startTime: startTime);
    return startTime;
  }

  // TODO: simplify, split, shorten
  /// Stops recording, decorates the finished record with [Record..duration] 
  /// and adds it to [records].
  void stopRec() {
    state = RecorderState.playing;

    if (_currentRecord == null || _currentRecord.isEmpty) return;
    
    var recordedDuration = DateTime.now().difference(_currentRecord.startTime);

    if (measureDuration == null) {
      measureDuration = recordedDuration;
    }

    _currentRecord.duration = _computeIntendedDuration(recordedDuration);

    records[_currentRecord.startTime] = _currentRecord;

    _currentRecord.close();

    Duration delayBeforePlay = _currentRecord.duration >= recordedDuration ?
      _currentRecord.duration - recordedDuration :
      _currentRecord.duration * 2 - recordedDuration;

    var startTime = _currentRecord.startTime;

    Future.delayed(delayBeforePlay, () => loop(records[startTime]));
    _currentRecord = null;
  }
}
