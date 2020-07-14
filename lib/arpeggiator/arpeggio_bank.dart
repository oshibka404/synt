import 'dart:math';

import 'arpeggio.dart';

/// Service providing arpeggios of a given density from [_arpeggios]
class ArpeggioBank {
  List<Arpeggio> _arpeggios;

  ArpeggioBank(this._arpeggios);
  Arpeggio getBy({double intensity}) {
    if (intensity < 0 || intensity > 1) {
      throw ArgumentError.value(intensity, 'intensity');
    }

    intensity = min(intensity, .999);
    var id = (intensity * _arpeggios.length).floor();
    return _arpeggios[id];
  }
}
