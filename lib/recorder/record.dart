import 'dart:async';

import 'package:flutter/material.dart';
import '../controller/keyboard_preset.dart';

import '../controller/keyboard/keyboard_action.dart';

/// Timeline with sequence of [KeyboardAction]s
class Record {
  Record({
    @required this.startTime,
    @required this.startPoint,
    @required this.preset,
  });
  final Offset startPoint;
  final DateTime startTime;
  final List<KeyboardAction> _actions = [];
  final KeyboardPreset preset;

  bool get isEmpty => _actions.isEmpty;

  /// Returns a stream and starts playing this record into it.
  ///
  /// Starts playing [after] given duration or [at] given time.
  /// When no params given or [at] is in past, starts immediately.
  Stream<KeyboardAction> play({DateTime at, Duration after}) async* {
    if (after != null) {
      await Future.delayed(after);
      yield* play();
    } else if (at != null && at.isAfter(DateTime.now())) {
      yield* play(after: at.difference(DateTime.now()));
    } else {
      var iterator = _actions.iterator;
      var playbackStartTime = DateTime.now();
      while (iterator.moveNext()) {
        var action = iterator.current;
        var timeFromPlaybackStart =
            DateTime.now().difference(playbackStartTime);
        var relativeActionTimePoint = action.time.difference(startTime);
        await Future.delayed(relativeActionTimePoint - timeFromPlaybackStart);
        yield action;
      }
    }
  }

  /// Saves [action] to this [Record].
  ///
  /// takes care of counting number of currently pressed pointers
  void add(KeyboardAction action) {
    if (action.pressure > 0) {
      _pressedPointers.add(action.pointerId);
    } else {
      _pressedPointers.remove(action.pointerId);
    }
    _actions.add(action);
  }

  Set<int> _pressedPointers = Set<int>();

  /// Ensures that all pointers have been released
  void close() {
    Set.from(_pressedPointers).forEach((pointerId) {
      add(KeyboardAction.release(pointerId));
    });
  }

  Duration duration;
}
