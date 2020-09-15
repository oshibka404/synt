import 'package:flutter_test/flutter_test.dart';
import 'package:perfect_first_synth/tempo_controller/tempo_controller.dart';

void main() {
  Function getBeatMatcher(int beat) {
    return (Tick tick) {
      return beat == tick.division;
    };
  }

  List<Function> getConsequentBeatMatchers(int to, [int from = 0]) {
    List<Function> matchers = [];
    for (int i = from; i <= to; i++) {
      matchers.add(getBeatMatcher(i));
    }
    return matchers;
  }

  group("Tempo controller", () {
    test("counts 0 immediately on start", () async {
      var tempoController = TempoController(tempo: 120);
      await Future.delayed(Duration(milliseconds: 1));
      expect(tempoController.clock, emits((tick) => tick.division == 0));
    });

    test("counts in time", () async {
      var bpm = 120.0;
      var expectedTicksCount = 5;
      var tempoController = TempoController(tempo: bpm);
      await Future.delayed(Duration(
          milliseconds:
              (Duration.millisecondsPerSecond * 60 / bpm * expectedTicksCount)
                  .ceil()));
      expect(tempoController.clock,
          emitsInOrder(getConsequentBeatMatchers(expectedTicksCount)));
    });

    test("counts 0 to 15 and then 0 to 15 again", () async {
      var bpm = 1000.0;
      var expectedTicksCount = 32;

      /// two full bars
      var tempoController = TempoController(tempo: bpm);
      await Future.delayed(Duration(
          milliseconds:
              (Duration.millisecondsPerSecond * 60 / bpm * expectedTicksCount)
                  .ceil()));
      expect(
          tempoController.clock,
          emitsInOrder(getConsequentBeatMatchers(15)
            ..addAll(getConsequentBeatMatchers(15))));
    });
  }, skip: true);
}
