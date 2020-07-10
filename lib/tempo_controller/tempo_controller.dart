import 'dart:async';

class TempoController {
  /// BPM, Number of quarter notes played per minute
  double tempo;

  Timer _internalTimer;

  var _outputController = StreamController<Tick>.broadcast();

  Stream<Tick> get _output => _outputController.stream;

  TempoController({
    this.tempo = 80,
  });
  Duration get bar => sixteenth * 16;

  Stream<Tick> get clock {
    if (_internalTimer == null) {
      _outputController.onListen = startTimer;
    }
    return _output;
  }

  Duration get sixteenth =>
      Duration(microseconds: Duration.microsecondsPerMinute ~/ (tempo * 4));

  void setTempo(double newTempo) {
    this.tempo = newTempo;
    if (_internalTimer != null) {
      _internalTimer.cancel();
      startTimer();
    }
  }

  void startTimer() {
    _internalTimer = Timer.periodic(sixteenth, _tick);
    _outputController.add(Tick(division: 0, tempo: tempo));
    _outputController.onCancel = () {
      _internalTimer.cancel();
      _internalTimer = null;
    };
  }

  void _tick(Timer timer) {
    _outputController.add(Tick(division: timer.tick % 16, tempo: tempo));
  }
}

class Tick {
  /// Current division from 0 to 15
  final int division;

  final double tempo;
  Tick({this.division, this.tempo});

  @override
  String toString() {
    return '#$division at $tempo bpm';
  }
}
