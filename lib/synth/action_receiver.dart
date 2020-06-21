import 'dart:math';

import '../controller/keyboard/keyboard_action.dart';
import 'scales.dart';
import 'synthesizer.dart';

class ActionReceiver {
  ActionReceiver(Stream<KeyboardAction> input) {
    input.listen(actionHandler);
  }

  List<int> scale = Scales.dorian;

  Synthesizer _synth = new Synthesizer();

  double _getFreqFromKeyNumber(double keyNumber) {
    return 440 * pow(2, (keyNumber - 49) / 12);
  }

  double _convertStepOffsetToPianoKey(double stepOffset, int baseKey) {
    int stepNumber = stepOffset.floor();
    int octaveOffset = (stepNumber ~/ scale.length);
    int chromaticStepsOffset = scale[stepNumber % scale.length];
    int semitonesOffset = (octaveOffset * 12) + chromaticStepsOffset;
    return (baseKey + semitonesOffset).floorToDouble();
  }

  double _getFreqFromStepOffset(double step, int baseKey) {
    return _getFreqFromKeyNumber(_convertStepOffsetToPianoKey(step, baseKey));
  }

  VoiceParams _getVoiceParams(KeyboardAction action) =>
    VoiceParams(
      freq: _getFreqFromStepOffset(action.stepOffset, action.preset.baseKey),
      gain: action.pressure,
      modulation: action.modulation,
    );

  void actionHandler(KeyboardAction action) {
    switch (action.type) {
      case KeyboardActionType.start:
        _synth.newVoice(
          action.voiceId,
          _getVoiceParams(action)
        );
        break;
      case KeyboardActionType.modify:
        _synth.modifyVoice(
          action.voiceId,
          _getVoiceParams(action)
        );
        break;
      case KeyboardActionType.stop:
        _synth.stopVoice(action.voiceId);
        break;
      default:
        throw UnimplementedError('Unknown action: neither start, modify nor stop');
    }
  }
}
