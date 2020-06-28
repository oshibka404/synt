import 'dart:async';
import 'dart:math';

import '../tempo_controller/tempo_controller.dart';

import 'arpeggio.dart';

/// Service streaming [Arpeggio] from a given note, according to given [_tempo]
///
/// There is always only one voice per arpeggio and one arpeggio per voice.
class Arpeggiator {
  Arpeggiator(this._id, this._tempo);
  TempoController _tempo;
  var _outputController = StreamController<PlayerAction>();
  Stream<PlayerAction> get output => _outputController.stream;

  final int _id;

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

  var _isPlaying = false;

  Arpeggio _currentArpeggio;

  /// Starts sending stream of [PlayerAction]s into [output]
  ///
  /// The arpeggio to play is chosen from internal bank of arpeggios
  /// of the given [complexity].
  void play(double complexity, {double baseStep}) {
    if (complexity < 0 || complexity > 1) {
      throw ArgumentError.value(complexity, 'complexity');
    }

    complexity = min(complexity, .999);

    var arpeggioId = (complexity * _arpeggios.length).floor();
    _currentArpeggio = _arpeggios[arpeggioId].withOffset(baseStep);

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
