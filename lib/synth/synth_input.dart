import 'synth_command.dart';
import 'synthesizer.dart';

/// Listens to [input] and calls corresponding methods of [Synthesizer].
class SynthInput {
  Synthesizer _synth = new Synthesizer();

  var voices = Set<int>();

  SynthInput.connect(Stream<SynthCommand> input) {
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
