import 'dart:async';

class TempoController {
  /// BPM, Number of quarter notes played per minute
  double tempo;

  Stream<Tick> _internalStream;

  TempoController({
    this.tempo = 80,
  });
  Duration get bar => sixteenth * 16;

  Stream<Tick> get clock {
    if (_internalStream == null) {
      _internalStream = Stream.periodic(sixteenth, _tick).asBroadcastStream(
          onCancel: (subscription) {
        subscription.cancel();
        _internalStream = null;
      });
    }
    return _internalStream;
  }

  Duration get sixteenth =>
      Duration(microseconds: Duration.microsecondsPerMinute ~/ (tempo * 4));

  Tick _tick(int i) {
    return Tick(division: i % 16, tempo: tempo);
  }
}

class Tick {
  /// Current division from 0 to 15
  final int division;

  final double tempo;
  Tick({this.division, this.tempo});
}
