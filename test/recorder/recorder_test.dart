import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:perfect_first_synth/controller/keyboard/keyboard_action.dart';
import 'package:perfect_first_synth/recorder/recorder.dart';
import 'package:perfect_first_synth/recorder/state.dart';

void main() {
  group('Recorder state: ', () {
    test('Default initial state is "playing"', () {
      var recorder = Recorder(input: Stream.empty());
      recorder.stateStream.last.then((value) {
        expect(value, RecorderState.playing);
      });
    });

    test('Initial state is "recording" when explicitly defined so', () {
      var recorder = Recorder(input: Stream.empty(), initialState: RecorderState.recording);
      recorder.stateStream.last.then((value) {
        expect(value, RecorderState.recording);
      });
    });

    test('Sets recording state', () {
      var recorder = Recorder(input: Stream.empty());
      recorder.startRec(Offset(0, 0));
      expect(recorder.stateStream, emitsInOrder([
        RecorderState.playing, // initial state
        RecorderState.recording,
      ]));
    });

    test('Goes to playing state after being stopped', () {
      var recorder = Recorder(input: Stream.empty());
      recorder.startRec(Offset(0, 0));
      recorder.stopRec();
      expect(recorder.stateStream, emitsInOrder([
        RecorderState.playing, // initial state
        RecorderState.recording,
        RecorderState.playing,
      ]));
    });
  });
  
  group('Recording: ', () {

    test('Bypasses all signals in correct order', () {
      var actions = [
        KeyboardAction(time: DateTime.now(), type: KeyboardActionType.start, voiceId: 1),
        KeyboardAction(time: DateTime.now(), type: KeyboardActionType.modify, voiceId: 1),
        KeyboardAction(time: DateTime.now(), type: KeyboardActionType.start, voiceId: 2),
      ];
      var controller = StreamController<KeyboardAction>();
      var recorder = Recorder(input: controller.stream);
      actions.forEach((element) {
        controller.add(element);
      });
      expect(recorder.output, emitsInOrder(actions));
      controller.close();
    });
  });
}
