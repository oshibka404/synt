import 'dart:math';

import '../arpeggiator/player_action.dart';
import '../controller/keyboard/keyboard_action.dart';
import 'keyboard/presets/keyboard_preset.dart';
import '../looper/trig.dart';
import '../scales/scale_patterns.dart';
import '../synth/synth_command.dart';

class SynthCommandFactory {
  static SynthCommand fromKeyboardAction(KeyboardAction action, voiceId,
      KeyboardPreset preset, ScalePattern scale) {
    return action.pressure > 0
        ? SynthCommand(voiceId,
            modulation: action.modulation,
            freq: _getFreqFromStepOffset(
                action.stepOffset, preset?.baseKey, scale),
            preset: preset.synthPreset.params,
            gain: action.pressure)
        : SynthCommand.stop(voiceId);
  }

  static SynthCommand fromPlayerAction(
      PlayerAction action, voiceId, KeyboardPreset preset, ScalePattern scale) {
    return action.velocity > 0
        ? SynthCommand(voiceId,
            modulation: action.modulation,
            freq: _getFreqFromStepOffset(
                action.stepOffset, preset?.baseKey, scale),
            preset: preset.synthPreset.params,
            gain: action.velocity)
        : SynthCommand.stop(voiceId);
  }

  static SynthCommand fromTrig(Trig trig, int voiceId, ScalePattern scale) {
    return trig.pressure > 0
        ? SynthCommand(trig.pointerId,
            modulation: trig.modulation,
            freq: _getFreqFromStepOffset(
                trig.stepOffset, trig.preset?.baseKey, scale),
            preset: trig.preset.synthPreset.params,
            gain: trig.pressure)
        : SynthCommand.stop(trig.pointerId);
  }

  static double _convertStepOffsetToPianoKey(
      double stepOffset, int baseKey, ScalePattern scale) {
    List<int> scaleIntervals = ScalePatterns.getScale(scale);
    int stepNumber = stepOffset.floor();
    int octaveOffset = (stepNumber ~/ scaleIntervals.length);
    int chromaticStepsOffset =
        scaleIntervals[stepNumber % scaleIntervals.length];
    int semitonesOffset = (octaveOffset * 12) + chromaticStepsOffset;
    return (baseKey + semitonesOffset).floorToDouble();
  }

  static double _getFreqFromKeyNumber(double keyNumber) {
    return 440 * pow(2, (keyNumber - 49) / 12);
  }

  static double _getFreqFromStepOffset(
      double step, int baseKey, ScalePattern scale) {
    return _getFreqFromKeyNumber(
        _convertStepOffsetToPianoKey(step, baseKey, scale));
  }
}
