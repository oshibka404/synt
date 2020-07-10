import 'scale_patterns.dart';

enum Key { C, Cs, D, Ds, E, F, Fs, G, Gs, A, As, B }

class Scale {
  Scale(this.key, this.pattern);
  final Key key;
  final ScalePattern pattern;

  List<int> get intervals => ScalePatterns.getScale(pattern);
}
