import 'state.dart';

/// Singleton class providing API to record sequences of actions
/// performed on controller.
class Recorder {
  static final Recorder _recorder = Recorder._internal();

  factory Recorder() {
    return _recorder;
  }

  Recorder._internal();

  void startRec() {
    this.state = RecorderState.recording;
  }

  void setReadyToRec() {
    this.state = RecorderState.ready;
  }

  void stopRec() {
    this.state = RecorderState.playing;
  }
  
  RecorderState state = RecorderState.playing;
}
