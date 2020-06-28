import 'synthesizer.dart';

/// Listens to [input] and calls corresponding methods of [DspApi].
class ActionReceiver {
  ActionReceiver(Stream<SynthCommand> input) {
    input.listen(commandHandler);
  }

  Synthesizer _synth = new Synthesizer();

  VoiceParams _getVoiceParams(SynthCommand command) => VoiceParams(
        freq: command.freq, // TODO: use absolute key numbers here
        gain: command.gain,
        modulation: command.modulation,
      );

  var voices = Set<int>();

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
}

class SynthCommand {
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

  final int voiceId;
  double freq;
  double gain;
  double modulation;

  bool gate;
}
