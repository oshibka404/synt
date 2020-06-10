import 'dart:async';

import 'state.dart';

/// Class providing API to record sequences of actions
/// performed on controller.
class Recorder {
  Recorder({
    this.initialState = RecorderState.playing,
  }) {
    _stateStreamController.add(initialState);
  }
  final RecorderState initialState;

  var _stateStreamController = StreamController<RecorderState>();
  
  Stream<RecorderState> get stateStream {
    return _stateStreamController.stream;
  }

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
