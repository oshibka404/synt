import 'dart:async';
import 'package:perfect_first_synth/arpeggiator/arpeggio_bank.dart';

import '../tempo_controller/tempo_controller.dart';

import 'arpeggio.dart';

/// Service streaming [Arpeggio] from a given note, according to given [_tempo]
///
/// There is always only one voice per arpeggio and one arpeggio per voice.
class Arpeggiator {
  Arpeggiator(this.tempo, this.arpeggioBank);
  TempoController tempo;
  var _outputController = StreamController<PlayerAction>();
  Stream<PlayerAction> get output => _outputController.stream;

  StreamSubscription<Tick> _tempoSubscription;

  ArpeggioBank arpeggioBank;

  var _isPlaying = false;

  Arpeggio _currentArpeggio;

  /// Starts sending stream of [PlayerAction]s into [output]
  ///
  /// The arpeggio to play is chosen from internal bank of arpeggios
  /// according to the given [intensity].
  void play(double intensity,
      {double baseStep, double modulation, double velocity}) {
    _currentArpeggio = arpeggioBank
        .getBy(intensity: intensity)
        .withOffset(baseStep)
        .withModulation(modulation)
        .withVelocity(velocity);

    if (!_isPlaying) {
      _isPlaying = true;
      _tempoSubscription = tempo.clock.listen((tick) {
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
