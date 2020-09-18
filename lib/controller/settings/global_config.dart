import '../../scales/scale_patterns.dart';

import 'config.dart';

class GlobalConfig extends Config {
  String fileName = 'global.json';

  double _tempo = 120;
  bool _poSync = false;
  ScalePattern _scale;

  bool get poSync => _poSync;
  set poSync(bool poSync) {
    _poSync = poSync;
    save();
  }

  ScalePattern get scale => _scale;

  set scale(ScalePattern scale) {
    _scale = scale;
    save();
  }

  double get tempo => _tempo;
  set tempo(double tempo) {
    _tempo = tempo;
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
///   'tempo': 90.5,
///   'scale': 4
/// }
