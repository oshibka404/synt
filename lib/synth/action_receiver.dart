import 'synthesizer.dart';

/// Listens to [input] and calls corresponding methods of [DspApi].
class ActionReceiver {
  ActionReceiver(Stream<SynthCommand> input) {
    input.listen(actionHandler);
  }

  Synthesizer _synth = new Synthesizer();

  VoiceParams _getVoiceParams(SynthCommand action) => VoiceParams(
        freq: action.freq, // TODO: use absolute key numbers here
        gain: action.gain,
        modulation: action.modulation,
      );

  var voices = Set<int>();

  void actionHandler(SynthCommand action) {
    if (action.gain > 0) {
      if (voices.contains(action.voiceId)) {
        _synth.modifyVoice(action.voiceId, _getVoiceParams(action));
      } else {
        _synth.newVoice(action.voiceId, _getVoiceParams(action));
      }
    } else {
      _synth.stopVoice(action.voiceId);
    }
  }
}

class SynthCommand {
  SynthCommand(
    this.voiceId, {
    this.freq,
    this.gain = 1,
    this.modulation = 0,
  });
  final int voiceId;
  final double freq;
  final double gain;
  final double modulation;
}
