import 'dart:async';

class TempoController {
  TempoController({
    this.tempo = 80,
  }) {
    _initController();
  }

  /// Number of quarter notes played per minute
  double tempo;
  final int _divisionsPerBar = 16;
  bool _isRunning = false;
  Timer _internalTimer;
  StreamController<Tick> _controller;
  Stream<Tick> get clock => _controller.stream;

  Duration get sixteenth =>
      Duration(microseconds: Duration.microsecondsPerMinute ~/ (tempo * 4));

  void _initController() {
    _controller = StreamController<Tick>(
      onListen: _start,
      onPause: _pause,
      onResume: _start,
      onCancel: _stop,
    );
  }

  void _tick(Timer timer) {
    _controller.add(Tick(
        division: timer.tick % _divisionsPerBar,
        tempo: tempo)); // Ask stream to send counter values as event.
    if (!_isRunning) {
      _internalTimer.cancel();
      _controller.close(); // Ask stream to shut down and tell listeners.
    }
  }

  void _start() {
    _internalTimer = Timer.periodic(sixteenth, _tick);
  }

  void _pause() {
    if (_internalTimer != null) {
      _internalTimer.cancel();
      _internalTimer = null;
    }
  }

  void _stop() {
    if (_internalTimer != null) {
      _internalTimer.cancel();
    }
    _controller.close(); // Ask stream to shut down and tell listeners.
  }
}

class Tick {
  Tick({this.division, this.tempo});

  /// Current division from 0 to 15
  int division;
  double tempo;
}
