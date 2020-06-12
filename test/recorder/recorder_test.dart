import 'package:flutter_test/flutter_test.dart';
import 'package:perfect_first_synth/recorder/recorder.dart';
import 'package:perfect_first_synth/recorder/state.dart';

void main() {
  group('Recorder state: ', () {
    test('Initial state is "playing"', () async {
      var recorder = Recorder(input: Stream.empty());
      recorder.stateStream.last.then((value) {
        expect(value, RecorderState.playing);
      });
    });
    
    test('Sets ready to recording state', () async {
      var recorder = Recorder(input: Stream.empty());
      recorder.setReadyToRec();
      expect(recorder.stateStream, emitsInOrder([
        RecorderState.playing, // initial state
        RecorderState.ready,
      ]));
    });

    test('Sets recording state', () async {
      var recorder = Recorder(input: Stream.empty());
      recorder.startRec(Offset(0, 0));
      expect(recorder.stateStream, emitsInOrder([
        RecorderState.playing, // initial state
        RecorderState.recording,
      ]));
    });

    test('Goes to playing state after being stopped', () async {
      var recorder = Recorder(input: Stream.empty());
      recorder.setReadyToRec();
      recorder.startRec(Offset(0, 0));
      recorder.stopRec();
      expect(recorder.stateStream, emitsInOrder([
        RecorderState.playing, // initial state
        RecorderState.ready,
        RecorderState.recording,
        RecorderState.playing,
      ]));
    });
  });
}
