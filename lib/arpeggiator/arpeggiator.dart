import 'dart:async';
import 'dart:math';

import '../tempo_controller/tempo_controller.dart';

import 'arpeggio.dart';

/// Service streaming [Arpeggio] from a given note, according to given [_tempo]
///
/// There is always only one voice per arpeggio and one arpeggio per voice.
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
      PlayerAction(stepOffset: 2),
      null,
      PlayerAction.stop(),
      null,
      PlayerAction(stepOffset: 4),
      null,
      PlayerAction.stop(),
      null,
      PlayerAction(stepOffset: 2),
      null,
      PlayerAction.stop(),
      null,
    ]),
    Arpeggio([
      PlayerAction(),
      null,
      PlayerAction.stop(),
      null,
      PlayerAction(stepOffset: 2),
      PlayerAction(stepOffset: 3),
      PlayerAction.stop(),
      null,
      PlayerAction(stepOffset: 4),
      null,
      PlayerAction.stop(),
      null,
      PlayerAction(stepOffset: 2),
      null,
      PlayerAction.stop(),
      PlayerAction(stepOffset: 1),
    ]),
    Arpeggio([
      PlayerAction(),
      null,
      PlayerAction.stop(),
      PlayerAction(stepOffset: 1),
      PlayerAction(stepOffset: 2),
      null,
      PlayerAction.stop(),
      PlayerAction(stepOffset: 3),
      PlayerAction(stepOffset: 4),
      null,
      PlayerAction.stop(),
      null,
      PlayerAction(stepOffset: 5),
      PlayerAction(stepOffset: 4),
      PlayerAction.stop(),
      null,
    ]),
    Arpeggio([
      PlayerAction(),
      null,
      PlayerAction.stop(),
      PlayerAction(stepOffset: 1),
      PlayerAction(stepOffset: 2),
      null,
      PlayerAction.stop(),
      PlayerAction(stepOffset: 3),
      PlayerAction(stepOffset: 4),
      null,
      PlayerAction.stop(),
      PlayerAction(stepOffset: 4),
      PlayerAction(stepOffset: 5),
      null,
      PlayerAction.stop(),
      PlayerAction(stepOffset: -1),
    ]),
    Arpeggio([
      PlayerAction(),
      null,
      PlayerAction.stop(),
      PlayerAction(stepOffset: 2),
      PlayerAction(stepOffset: 4),
      null,
      PlayerAction.stop(),
      PlayerAction(stepOffset: 5),
      PlayerAction(stepOffset: 7),
      null,
      PlayerAction.stop(),
      PlayerAction(stepOffset: 4),
      PlayerAction(stepOffset: 5),
      null,
      PlayerAction.stop(),
      PlayerAction(stepOffset: 1),
    ]),
    Arpeggio([
      PlayerAction(),
      null,
      PlayerAction(stepOffset: 2),
      PlayerAction.stop(),
      PlayerAction(stepOffset: 2),
      null,
      PlayerAction(stepOffset: 4),
      PlayerAction.stop(),
      PlayerAction(stepOffset: 4),
      null,
      PlayerAction(stepOffset: 5),
      null,
      PlayerAction(stepOffset: 4),
      PlayerAction.stop(),
      PlayerAction(stepOffset: 3),
      PlayerAction.stop(),
    ]),
    Arpeggio([
      PlayerAction(),
      PlayerAction.stop(),
      PlayerAction(stepOffset: 2),
      PlayerAction.stop(),
      PlayerAction(stepOffset: 2),
      PlayerAction.stop(),
      PlayerAction(stepOffset: 4),
      PlayerAction.stop(),
      PlayerAction(stepOffset: 4),
      PlayerAction.stop(),
      PlayerAction(stepOffset: 5),
      PlayerAction.stop(),
      PlayerAction(stepOffset: 4),
      PlayerAction.stop(),
      PlayerAction(stepOffset: 3),
      PlayerAction.stop(),
    ]),
  ];

  var _isPlaying = false;

  Arpeggio _currentArpeggio;

  /// Starts sending stream of [PlayerAction]s into [output]
  ///
  /// The arpeggio to play is chosen from internal bank of arpeggios
  /// according to the given [complexity].
  void play(double complexity,
      {double baseStep, double modulation, double velocity}) {
    if (complexity < 0 || complexity > 1) {
      throw ArgumentError.value(complexity, 'complexity');
    }

    complexity = min(complexity, .999);

    var arpeggioId = (complexity * _arpeggios.length).floor();
    _currentArpeggio = _arpeggios[arpeggioId]
        .withOffset(baseStep)
        .withModulation(modulation)
        .withVelocity(velocity);

    if (!_isPlaying) {
      _isPlaying = true;
      _tempoSubscription = _tempo.clock.listen((tick) {
        var actionToPerform = _currentArpeggio[tick.division];
        if (actionToPerform != null) {
          _outputController.add(actionToPerform);
        }
      });
    }
  }

  void stop() {
    _outputController.add(PlayerAction.stop());
    _tempoSubscription.cancel();
  }
}
