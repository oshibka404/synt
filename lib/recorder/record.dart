import 'dart:async';

import 'package:flutter/material.dart';
import 'package:perfect_first_synth/controller/keyboard/keyboard_action.dart';

/// Timeline with sequence of [KeyboardAction]s
class Record {
  Record({
    @required this.startTime,
    @required this.startPoint,
  });
  final Offset startPoint;
  final DateTime startTime;
  final List<KeyboardAction> _actions = [];

  bool get isEmpty => _actions.isEmpty;

  /// Returns a stream and starts playing this record into it.
  /// 
  /// Starts playing [after] given duration or [at] given time.
  /// When no params given or [at] is in past, starts immediately.
  Stream<KeyboardAction> play({DateTime at, Duration after}) async* {
    if (after != null) {
      Future.delayed(after, play);
    } else if (at != null && at.isAfter(DateTime.now())) {
      play(after: at.difference(DateTime.now()));
    } else {
      var iterator = _actions.iterator;
      var previousActionTime = startTime;
      while (iterator.moveNext()) {
        // TODO: use absolute time offset instead of relative
        await Future.delayed(iterator.current.time.difference(previousActionTime));
        previousActionTime = iterator.current.time;
        yield iterator.current;
      }
    }
  }

  /// Saves [action] to this [Record].
  /// 
  /// First ensures that it starts with [KeyboardActionType.start].
  /// If it doesn't, it either recursively adds the [KeyboardActionType.start]
  /// or 
  void add(KeyboardAction action) {
    switch (action.type) {
      case KeyboardActionType.start:
        _recordingVoices.add(action.voiceId);
        break;
      case KeyboardActionType.stop:
        if (!_recordingVoices.remove(action.voiceId)) { // if no such voice
          return;
        }
        break;
      case KeyboardActionType.modify:
        if (!_recordingVoices.contains(action.voiceId)) {
          add(KeyboardAction.assign(action, type: KeyboardActionType.start));
        }
        break;
      default:
        throw UnimplementedError("Method `add` not implemented for type ${action.type}");
    }
    
    _actions.add(action);
  }
  Set<int> _recordingVoices = Set<int>();

  /// Ensures that all voices have been stopped
  void close() {
    _recordingVoices.forEach((voiceId) {
      add(KeyboardAction.stop(voiceId));
    });
  }

  Duration duration;
}