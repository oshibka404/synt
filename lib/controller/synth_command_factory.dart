import 'dart:math';

import '../arpeggiator/arpeggio.dart';
import '../controller/keyboard/keyboard_action.dart';
import '../controller/keyboard_preset.dart';
import '../looper/sample.dart';
import '../synth/synth_command.dart';

import 'scales.dart';

class SynthCommandFactory {
  static final scale = Scales.minor;

  static SynthCommand fromPlayerAction(
      PlayerAction action, voiceId, KeyboardPreset preset) {
    return action.velocity > 0
        ? SynthCommand(voiceId,
            modulation: action.modulation,
            freq: _getFreqFromStepOffset(action.stepOffset, preset?.baseKey),
            gain: action.velocity)
        : SynthCommand.stop(voiceId);
  }

  static SynthCommand fromSample(Sample sample, voiceId) {
    return sample.pressure > 0
        ? SynthCommand(sample.pointerId,
            modulation: sample.modulation,
            freq: _getFreqFromStepOffset(
                sample.stepOffset, sample.preset?.baseKey),
            gain: sample.pressure)
        : SynthCommand.stop(sample.pointerId);
  }

  static SynthCommand fromKeyboardAction(
      KeyboardAction action, voiceId, KeyboardPreset preset) {
    return action.pressure > 0
        ? SynthCommand(voiceId,
            modulation: action.modulation,
            freq: _getFreqFromStepOffset(action.stepOffset, preset?.baseKey),
            gain: action.pressure)
        : SynthCommand.stop(voiceId);
  }

  static double _convertStepOffsetToPianoKey(double stepOffset, int baseKey) {
    int stepNumber = stepOffset.floor();
    int octaveOffset = (stepNumber ~/ scale.length);
    int chromaticStepsOffset = scale[stepNumber % scale.length];
    int semitonesOffset = (octaveOffset * 12) + chromaticStepsOffset;
    return (baseKey + semitonesOffset).floorToDouble();
  }

  static double _getFreqFromKeyNumber(double keyNumber) {
    return 440 * pow(2, (keyNumber - 49) / 12);
  }

  static double _getFreqFromStepOffset(double step, int baseKey) {
    return _getFreqFromKeyNumber(_convertStepOffsetToPianoKey(step, baseKey));
  }
}
