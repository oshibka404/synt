import 'dart:math';

import 'package:perfect_first_synth/controller/keyboard_preset.dart';

import '../controller/keyboard/keyboard_action.dart';
import 'synthesizer.dart';

class ActionReceiver {
  ActionReceiver(Stream<KeyboardAction> input) {
    input.listen(actionHandler);
  }

  Synthesizer _synth = new Synthesizer();

  /// Intervals of a minor scale in semitones
  List<int> minorScaleIntervals = [0, 2, 3, 5, 7, 8, 10];

  double _getFreqFromKeyNumber(double keyNumber) {
    return 440 * pow(2, (keyNumber - 49) / 12);
  }

  double _convertStepOffsetToPianoKey(double stepOffset, int baseKey) {
    int stepNumber = stepOffset.floor();
    int keyOffset = minorScaleIntervals[stepNumber % 7];
    return (baseKey + keyOffset).floorToDouble();
  }

  double _getFreqFromStepOffset(double step, int baseKey) {
    return _getFreqFromKeyNumber(_convertStepOffsetToPianoKey(step, baseKey));
  }

  VoiceParams _getVoiceParams(KeyboardAction action) =>
    VoiceParams(
      freq: _getFreqFromStepOffset(action.stepOffset, action.preset.baseKey),
      gain: action.pressure,
      noiseLevel: 1 - action.modulation,
      sawLevel: action.modulation,
    );

  void actionHandler(KeyboardAction action) {
    switch (action.type) {
      case KeyboardActionType.start:
        _synth.newVoice(
          action.voiceId,
          VoiceParams(
            freq: _getFreqFromStepOffset(action.stepOffset, action.preset.baseKey),
            gain: action.pressure,
            noiseLevel: 1 - action.modulation,
            sawLevel: action.modulation,
          )
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
