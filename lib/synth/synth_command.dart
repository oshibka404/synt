class SynthCommand {
  final int voiceId;
  double freq;

  double gain;
  double modulation;
  bool gate;

  Map<String, double> preset;

  SynthCommand(
    this.voiceId, {
    this.freq,
    this.gain = 1,
    this.modulation = 0,
    this.preset,
  }) {
    gate = true;
  }

  SynthCommand.stop(this.voiceId) {
    gate = false;
  }
}
