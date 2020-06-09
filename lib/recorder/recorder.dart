import 'dart:async';

import 'state.dart';

/// Singleton class providing API to record sequences of actions
/// performed on controller.
class Recorder {
  static final Recorder _recorder = Recorder._internal();

  factory Recorder() {
    return _recorder;
  }

  var _stateStreamController = StreamController<RecorderState>();
  
  Stream<RecorderState> get stateStream {
    return _stateStreamController.stream;
  }

  Recorder._internal();

  void startRec() {
    _stateStreamController.add(RecorderState.recording);
  }

  void setReadyToRec() {
    _stateStreamController.add(RecorderState.ready);
  }

  void stopRec() {
    _stateStreamController.add(RecorderState.playing);
  }
}
