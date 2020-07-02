import 'dart:math';

import 'arpeggio.dart';

class ArpeggioBank {
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

  // TODO: this should be somewhere in JSON
  Arpeggio getBy({double intensity}) {
    if (intensity < 0 || intensity > 1) {
      throw ArgumentError.value(intensity, 'intensity');
    }

    intensity = min(intensity, .999);
    var id = (intensity * _arpeggios.length).floor();
    return _arpeggios[id];
  }
}
