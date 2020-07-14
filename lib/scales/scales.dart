import 'scale_patterns.dart';

enum Key { C, Cs, D, Ds, E, F, Fs, G, Gs, A, As, B }

class Scale {
  final Key key;
  final ScalePattern pattern;
  Scale(this.key, this.pattern);

  List<int> get intervals => ScalePatterns.getScale(pattern);
}
