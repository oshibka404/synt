class Scales {
  static const List<int> chromatic = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];

  // Diatonic scales
  static const List<int> ionian = [0, 2, 4, 5, 7, 9, 11];
  static const List<int> dorian = [0, 2, 3, 5, 7, 9, 10];
  static const List<int> phrygian = [0, 1, 3, 5, 7, 8, 10];
  static const List<int> lydian = [0, 2, 4, 6, 7, 9, 11];
  static const List<int> myxolydian = [0, 2, 4, 5, 7, 9, 10];
  static const List<int> aeolian = [0, 2, 3, 5, 7, 8, 10];
  static const List<int> locrian = [0, 1, 3, 5, 6, 8, 10];

  static List<int> get minor => aeolian;
  static List<int> get major => ionian;

  static const List<int> harmonicMinor = [0, 2, 3, 5, 7, 8, 11];
  static const List<int> melodicMinor = [0, 2, 3, 5, 7, 9, 11];

  static const List<int> blues = [0, 3, 5, 6, 7, 10];
}
