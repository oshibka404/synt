import 'dart:async';

import '../tempo_controller/tempo_controller.dart';

import 'arpeggio.dart';

/// Service streaming [Arpeggio]s from a given note, according to given [_tempo]
class Arpeggiator {
  Arpeggiator(this._tempo);
  TempoController _tempo;
  var _outputController = StreamController<PlayerAction>();
  Stream<PlayerAction> get output => _outputController.stream;

  StreamSubscription<Tick> _tempoSubscription;

  List<Arpeggio> _arpeggios = [
    Arpeggio([
      PlayerAction(),
      null,
      PlayerAction.stop(),
      null,
      PlayerAction(),
      null,
      PlayerAction.stop(),
      null,
      PlayerAction(),
      null,
      PlayerAction.stop(),
      null,
      PlayerAction(),
      null,
      PlayerAction.stop(),
      null,
    ]),
    Arpeggio([
      PlayerAction(),
      null,
      null,
      null,
      PlayerAction(),
      null,
      null,
      null,
      PlayerAction(),
      null,
      null,
      null,
      PlayerAction(),
      null,
      null,
      null,
    ]),
    Arpeggio([
      PlayerAction(),
      null,
      PlayerAction(),
      PlayerAction.stop(),
      PlayerAction(),
      null,
      PlayerAction(),
      PlayerAction.stop(),
      PlayerAction(),
      null,
      PlayerAction(),
      null,
      PlayerAction(),
      PlayerAction.stop(),
      PlayerAction(),
      PlayerAction.stop(),
    ]),
    Arpeggio([
      PlayerAction(),
      PlayerAction.stop(),
      PlayerAction(),
      PlayerAction.stop(),
      PlayerAction(),
      PlayerAction.stop(),
      PlayerAction(),
      PlayerAction.stop(),
      PlayerAction(),
      PlayerAction.stop(),
      PlayerAction(),
      PlayerAction.stop(),
      PlayerAction(),
      PlayerAction.stop(),
      PlayerAction(),
      PlayerAction.stop(),
    ]),
  ];

  /// Starts sending stream of [PlayerAction]s into [output]
  ///
  /// The arpeggio to play is chosen from internal bank of arpeggios
  /// of the given [complexity].
  void play(double complexity, {double baseStep}) {
    if (complexity < 0 || complexity > 1) {
      throw ArgumentError.value(complexity, 'complexity');
    }

    var arpeggioId = (complexity * _arpeggios.length).floor();
    var arpeggio = _arpeggios[arpeggioId];
    _play(arpeggio, baseStep: baseStep);
  }

  void _play(Arpeggio arpeggio, {double baseStep}) {
    _tempoSubscription = _tempo.clock.listen((tick) {
      if (arpeggio[tick.division] != null) {
        _outputController.add(arpeggio[tick.division]);
      }
    });
  }

  void stop() {
    _tempoSubscription.cancel();
  }
}
