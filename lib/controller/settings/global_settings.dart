import 'package:perfect_first_synth/scales/scale_patterns.dart';

import 'settings.dart';

class GlobalSettings extends Settings {
  String fileName = 'global.json';

  double _tempo = 120;
  double get tempo => _tempo;
  set tempo(double tempo) {
    _tempo = tempo;
    save();
  }

  bool _poSync = false;
  bool get poSync => _poSync;
  set poSync(bool poSync) {
    _poSync = poSync;
    save();
  }

  ScalePattern _scale;
  ScalePattern get scale => _scale;
  set scale(ScalePattern scale) {
    _scale = scale;
    save();
  }

  applyValues(Map<String, dynamic> raw) {
    _poSync = raw['po_sync'];
    _tempo = raw['tempo'];
    _scale = ScalePattern.values[raw['scale']];
  }

  Map<String, dynamic> toJson() {
    return {
      'po_sync': poSync,
      'tempo': tempo,
      'scale': scale.index,
    };
  }
}

/// Settings file example:
/// {
///   'po_sync': true,
///   'tempo': 90
/// }
