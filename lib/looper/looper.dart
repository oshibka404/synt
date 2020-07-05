import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../controller/keyboard/keyboard_action.dart';
import '../controller/keyboard_preset.dart';
import '../tempo_controller/tempo_controller.dart';
import 'loop.dart';
import 'sample.dart';

/// Receives stream [input] of [KeyboardAction]s, creates loops and plays them
/// into [output].
class Looper {
  final Stream<KeyboardAction> input;

  final TempoController tempo;

  final loops = Map<DateTime, Loop>();

  Loop _currentLoop;

  var _outputController = StreamController<Sample>();

  bool _isLooping = false;

  Looper({@required this.input, this.tempo}) {
    input.listen(_inputListener);
  }

  Duration get barDuration => tempo?.bar;

  bool get isLooping => _isLooping;

  Stream<Sample> get output {
    return _outputController.stream;
  }

  void delete(Loop loop) {
    stop(loop);
    loops.remove(loop.startTime);
  }

  void start(Loop loop) {
    loop.play().listen((action) {
      _outputController.add(action);
    });
    Future.delayed(loop.duration, () {
      if (loop.isPlaying) {
        start(loop);
      }
    });
  }

  /// Creates [Loop] and starts writing actions received from [input] to it.
  /// Returns start time to be used as the loop's id.
  DateTime startRec(Offset initialPosition, KeyboardPreset preset) {
    var startTime = DateTime.now();
    _isLooping = true;
    _currentLoop =
        Loop(startPoint: initialPosition, startTime: startTime, preset: preset);
    return startTime;
  }

  void stop(Loop loop) {
    loop.stop();
  }

  /// Stops looping, decorates the finished loop with [Loop..duration]
  /// and adds it to [loops].
  void stopRec() {
    _isLooping = false;

    if (_currentLoop == null || _currentLoop.isEmpty) return;

    var loopedDuration = DateTime.now().difference(_currentLoop.startTime);

    _currentLoop.duration = _computeIntendedDuration(loopedDuration);

    loops[_currentLoop.startTime] = _currentLoop;

    _currentLoop.close();

    Duration delayBeforePlay = _currentLoop.duration >= loopedDuration
        ? _currentLoop.duration - loopedDuration
        : _currentLoop.duration * 2 - loopedDuration;

    var startTime = _currentLoop.startTime;

    Future.delayed(delayBeforePlay, () => start(loops[startTime]));

    _currentLoop = null;
  }

  Duration _computeIntendedDuration(Duration loopedDuration) {
    if (loopedDuration == barDuration) {
      return loopedDuration;
    }

    Duration intendedDuration;
    double measuresInLoop =
        loopedDuration.inMicroseconds / barDuration.inMicroseconds;

    int bars =
        measuresInLoop > 1 ? pow(2, (log(measuresInLoop) / ln2).round()) : 1;

    intendedDuration =
        Duration(microseconds: barDuration.inMicroseconds * bars);
    return intendedDuration;
  }

  void _inputListener(KeyboardAction action) {
    if (_currentLoop != null) {
      _currentLoop.add(action);
    }
    _outputController.add(Sample.from(action));
  }
}
