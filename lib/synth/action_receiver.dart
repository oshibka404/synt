import 'synthesizer.dart';

/// Listens to [input] and calls corresponding methods of [DspApi].
class ActionReceiver {
  Synthesizer _synth = new Synthesizer();

  var voices = Set<int>();

  ActionReceiver(Stream<SynthCommand> input) {
    input.listen(commandHandler);
  }

  void commandHandler(SynthCommand command) {
    if (command.gate) {
      if (voices.contains(command.voiceId)) {
        _synth.modifyVoice(command.voiceId, _getVoiceParams(command));
      } else {
        _synth.newVoice(command.voiceId, _getVoiceParams(command));
        voices.add(command.voiceId);
      }
    } else {
      _synth.stopVoice(command.voiceId);
      voices.remove(command.voiceId);
    }
  }

  VoiceParams _getVoiceParams(SynthCommand command) => VoiceParams(
        freq: command.freq,
        gain: command.gain,
        modulation: command.modulation,
      );
}

class SynthCommand {
  final int voiceId;
  double freq;

  double gain;
  double modulation;
  bool gate;
  SynthCommand(
    this.voiceId, {
    this.freq,
    this.gain = 1,
    this.modulation = 0,
  }) {
    gate = true;
  }

  SynthCommand.stop(this.voiceId) {
    gate = false;
  }
}
