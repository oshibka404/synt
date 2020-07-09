enum Scale {
  chromatic,
  pentatonic,
  blues,
  harmonicMinor,
  melodicMinor,
  ionian,
  dorian,
  phrygian,
  lydian,
  myxolydian,
  aeolian,
  locrian,
  major,
  minor,
}

class Scales {
  static Map<Scale, List<int>> _scales = {
    Scale.chromatic: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11],

    Scale.pentatonic: [0, 3, 5, 7, 10],
    Scale.blues: [0, 3, 5, 6, 7, 10],

    Scale.harmonicMinor: [0, 2, 3, 5, 7, 8, 11],
    Scale.melodicMinor: [0, 2, 3, 5, 7, 9, 11],

    // Diatonic scales
    Scale.ionian: [0, 2, 4, 5, 7, 9, 11],
    Scale.dorian: [0, 2, 3, 5, 7, 9, 10],
    Scale.phrygian: [0, 1, 3, 5, 7, 8, 10],
    Scale.lydian: [0, 2, 4, 6, 7, 9, 11],
    Scale.myxolydian: [0, 2, 4, 5, 7, 9, 10],
    Scale.aeolian: [0, 2, 3, 5, 7, 8, 10],
    Scale.locrian: [0, 1, 3, 5, 6, 8, 10],
  };

  static List<int> get major => _scales[Scale.ionian];
  static List<int> get minor => _scales[Scale.aeolian];

  static List<int> getScale(Scale scale) {
    if (scale == Scale.minor) return minor;
    if (scale == Scale.major) return major;
    return _scales[scale];
  }
}
