import 'package:flutter_test/flutter_test.dart';
import 'package:perfect_first_synth/controller/keyboard/keyboard_action.dart';
import 'package:perfect_first_synth/recorder/record.dart';

void main() {
  bool isStartAction(KeyboardAction action) => action.type == KeyboardActionType.start;
  bool isModifyAction(KeyboardAction action) => action.type == KeyboardActionType.modify;
  bool isStopAction(KeyboardAction action) => action.type == KeyboardActionType.stop;
  bool hasId(KeyboardAction action, int id) => action.voiceId == id;
  group("Record", () {
    test("is initially empty", () {
      var record = Record(
        startTime: DateTime.now(),
        startPoint: Offset.zero,
      );
      expect(record.isEmpty, true);
    });

    test("is not empty after added some actions", () {
      var record = Record(
        startTime: DateTime.now(),
        startPoint: Offset.zero,
      );

      record.add(KeyboardAction.start(voiceId: 1));
      expect(record.isEmpty, false);
    });

    test("actually records and plays events in corect order", () {
      var record = Record(
        startTime: DateTime.now(),
        startPoint: Offset.zero,
      );

      List<KeyboardAction> actions = [
        KeyboardAction.start(voiceId: 1),
        KeyboardAction.modify(voiceId: 1, stepOffset: 2),
        KeyboardAction.modify(voiceId: 1, stepOffset: 3),
        KeyboardAction.stop(1),
      ];

      actions.forEach((element) {
        record.add(element);
      });
      
      expect(record.play(), emitsInOrder([
        isStartAction,
        (KeyboardAction action) => isModifyAction(action) && action.stepOffset == 2,
        (KeyboardAction action) => isModifyAction(action) && action.stepOffset == 3,
        isStopAction
      ]));
    });

    test("automaticaly adds start action in beginning if needed", () {
      var record = Record(
        startTime: DateTime.now(),
        startPoint: Offset.zero,
      );

      List<KeyboardAction> actions = [
        KeyboardAction.modify(voiceId: 1, stepOffset: 2),
        KeyboardAction.modify(voiceId: 1, stepOffset: 3),
        KeyboardAction.stop(1),
      ];

      actions.forEach((element) {
        record.add(element);
      });
      
      expect(record.play(), emitsInOrder([
        (action) => isStartAction(action) && action.voiceId == 1,
        isModifyAction,
        isModifyAction,
        isStopAction
      ]));
    });

    test("automaticaly adds stop action on close", () {
      var record = Record(
        startTime: DateTime.now(),
        startPoint: Offset.zero,
      );

      List<KeyboardAction> actions = [
        KeyboardAction.start(voiceId: 1),
        KeyboardAction.modify(voiceId: 1, stepOffset: 2),
        KeyboardAction.modify(voiceId: 1, stepOffset: 3),
      ];

      actions.forEach((element) {
        record.add(element);
      });

      record.close();
      
      expect(record.play(), emitsInOrder([
        isStartAction,
        isModifyAction,
        isModifyAction,
        (action) => isStopAction(action) && action.voiceId == 1,
      ]));
    });

    test("automaticaly adds stop actions to all unstopped voices", () {
      var record = Record(
        startTime: DateTime.now(),
        startPoint: Offset.zero,
      );

      List<KeyboardAction> actions = [
        KeyboardAction.start(voiceId: 1),
        KeyboardAction.start(voiceId: 2),
      ];

      actions.forEach((element) {
        record.add(element);
      });

      record.close();

      expect(record.play(), emitsInOrder([
        isStartAction,
        isStartAction,
        (action) => isStopAction(action),
        (action) => isStopAction(action),
      ]));

      expect(record.play(), emitsInAnyOrder([
        isStartAction,
        isStartAction,
        (action) => isStopAction(action) && hasId(action, 1),
        (action) => isStopAction(action) && hasId(action, 2),
      ]));
    });

  });
}
