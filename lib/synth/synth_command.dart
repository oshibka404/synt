import 'dart:math';

import 'package:perfect_first_synth/arpeggiator/arpeggio.dart';
import 'package:perfect_first_synth/controller/keyboard_preset.dart';
import 'package:perfect_first_synth/recorder/recorded_action.dart';

import 'scales.dart';

class SynthCommand {
  final int voiceId;
  double freq;

  double gain;
  double modulation;
  bool gate;

  List<int> _scale = Scales.dorian;

  SynthCommand(
    this.voiceId, {
    this.freq,
    this.gain = 1,
    this.modulation = 0,
  }) {
    gate = true;
  }

  SynthCommand.fromPlayerAction(
      PlayerAction action, this.voiceId, KeyboardPreset preset) {
    action.velocity > 0
        ? SynthCommand(voiceId,
            modulation: action.modulation,
            freq: _getFreqFromStepOffset(
                // action.stepOffset, preset?.baseKey ?? currentPreset.baseKey))
                action.stepOffset,
                preset?.baseKey))
        : SynthCommand.stop(voiceId);
  }

  SynthCommand.fromRecordedAction(RecordedAction action, this.voiceId) {
    action.pressure > 0
        ? SynthCommand(action.pointerId,
            modulation: action.modulation,
            freq: _getFreqFromStepOffset(
                action.stepOffset,
                // action.preset?.baseKey ?? currentPreset.baseKey))
                action.preset?.baseKey))
        : SynthCommand.stop(action.pointerId);
  }

  SynthCommand.stop(this.voiceId) {
    gate = false;
  }

  double _convertStepOffsetToPianoKey(double stepOffset, int baseKey) {
    int stepNumber = stepOffset.floor();
    int octaveOffset = (stepNumber ~/ _scale.length);
    int chromaticStepsOffset = _scale[stepNumber % _scale.length];
    int semitonesOffset = (octaveOffset * 12) + chromaticStepsOffset;
    return (baseKey + semitonesOffset).floorToDouble();
  }

  double _getFreqFromKeyNumber(double keyNumber) {
    return 440 * pow(2, (keyNumber - 49) / 12);
  }

  double _getFreqFromStepOffset(double step, int baseKey) {
    return _getFreqFromKeyNumber(_convertStepOffsetToPianoKey(step, baseKey));
  }
}
