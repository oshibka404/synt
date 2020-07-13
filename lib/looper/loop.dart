import 'dart:async';

import 'package:flutter/material.dart';

import '../controller/keyboard/keyboard_action.dart';
import '../controller/keyboard_preset.dart';
import 'sample.dart';

/// Timeline with sequence of [KeyboardAction]s
///
/// produces stream of [Sample]s.
class Loop {
  final Offset startPoint;
  final DateTime startTime;
  final List<KeyboardAction> _actions = [];
  final KeyboardPreset preset;
  bool _isPlaying = false;

  Set<int> _pressedPointers = Set<int>();
  Duration duration;

  Loop({
    @required this.startTime,
    @required this.startPoint,
    @required this.preset,
  });

  bool get isEmpty => _actions.isEmpty;

  bool get isPlaying => _isPlaying;

  /// Saves [action] to this [Record].
  ///
  /// takes care of counting number of currently pressed pointers
  void add(KeyboardAction action) {
    if (action.pressure > 0) {
      _pressedPointers.add(action.pointerId);
    } else {
      _pressedPointers.remove(action.pointerId);
    }
    _actions.add(Sample.from(action, preset: preset));
  }

  /// Ensures that all pointers have been released
  void close() {
    Set.from(_pressedPointers).forEach((pointerId) {
      add(KeyboardAction.release(pointerId));
    });
  }

  /// Returns a stream and starts playing this record into it.
  ///
  /// Starts playing [after] given duration or [at] given time.
  /// When no params given or [at] is in past, starts immediately.
  Stream<Sample> play({DateTime at, Duration after}) async* {
    if (after != null) {
      await Future.delayed(after);
      yield* play();
    } else if (at != null && at.isAfter(DateTime.now())) {
      yield* play(after: at.difference(DateTime.now()));
    } else {
      _isPlaying = true;
      var iterator = _actions.iterator;
      var playbackStartTime = DateTime.now();
      while (iterator.moveNext() && _isPlaying) {
        var action = iterator.current;
        if (action.pressure > 0) {
          _pressedPointers.add(action.pointerId);
        } else {
          _pressedPointers.remove(action.pointerId);
        }
        var timeFromPlaybackStart =
            DateTime.now().difference(playbackStartTime);
        var relativeActionTimePoint = action.time.difference(startTime);
        await Future.delayed(relativeActionTimePoint - timeFromPlaybackStart);
        yield action;
      }

      var pointersToRelease = _pressedPointers.toList();
      for (var i = 0; i < _pressedPointers.length; i++) {
        yield Sample.from(KeyboardAction.release(pointersToRelease[i]));
      }
      _pressedPointers.clear();
    }
  }

  void stop() {
    _isPlaying = false;
  }
}
