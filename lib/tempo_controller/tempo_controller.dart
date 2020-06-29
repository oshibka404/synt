import 'dart:async';

class TempoController {
  TempoController({
    this.tempo = 80,
  });

  /// BPM, Number of quarter notes played per minute
  double tempo;

  Duration get sixteenth =>
      Duration(microseconds: Duration.microsecondsPerMinute ~/ (tempo * 4));

  Stream<Tick> _internalStream;

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

  Tick _tick(int i) {
    return Tick(division: i % 16, tempo: tempo);
  }
}

class Tick {
  Tick({this.division, this.tempo});

  /// Current division from 0 to 15
  final int division;
  final double tempo;
}
