import 'dsp_api.dart';

class TempoSync {
  static const Duration busyCycle = Duration(milliseconds: 5);

  // PO sync mode expects pulse on 8th (2 ppq) so we skip every 2nd pulse
  static bool skip = true;

  static tick() {
    skip = !skip;
    if (skip) return;
    DspApi.setParamValueByPath("metronome", 1)
        .then((_) => Future.delayed(busyCycle, () {
              DspApi.setParamValueByPath("metronome", -1);
            }))
        .then((_) => Future.delayed(busyCycle, () {
              DspApi.setParamValueByPath("metronome", 0);
            }));
  }
}
