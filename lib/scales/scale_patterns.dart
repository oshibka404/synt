enum ScalePattern {
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

class ScalePatterns {
  static Map<ScalePattern, List<int>> _scalePatterns = {
    ScalePattern.chromatic: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11],

    ScalePattern.pentatonic: [0, 3, 5, 7, 10],
    ScalePattern.blues: [0, 3, 5, 6, 7, 10],

    ScalePattern.harmonicMinor: [0, 2, 3, 5, 7, 8, 11],
    ScalePattern.melodicMinor: [0, 2, 3, 5, 7, 9, 11],

    // Diatonic scales
    ScalePattern.ionian: [0, 2, 4, 5, 7, 9, 11],
    ScalePattern.dorian: [0, 2, 3, 5, 7, 9, 10],
    ScalePattern.phrygian: [0, 1, 3, 5, 7, 8, 10],
    ScalePattern.lydian: [0, 2, 4, 6, 7, 9, 11],
    ScalePattern.myxolydian: [0, 2, 4, 5, 7, 9, 10],
    ScalePattern.aeolian: [0, 2, 3, 5, 7, 8, 10],
    ScalePattern.locrian: [0, 1, 3, 5, 6, 8, 10],
  };

  static List<int> get major => _scalePatterns[ScalePattern.ionian];
  static List<int> get minor => _scalePatterns[ScalePattern.aeolian];

  static List<int> getScale(ScalePattern scale) {
    if (scale == ScalePattern.minor) return minor;
    if (scale == ScalePattern.major) return major;
    return _scalePatterns[scale];
  }
}
