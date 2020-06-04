import 'package:perfect_first_synth/synth/dsp_api.dart';

class Voice {
  int _id = 0;

  Map<String, double> _params = {};

  Map<String, double> get params => _params;
  
  Voice(Map<String, double> params) {
    _initVoice(params);
  }

  Future<void> _initVoice(Map<String, double> params) async {
    if (!await DspApi.isRunning()) {
      DspApi.start();
    }
    _id = await DspApi.newVoice();
    params.forEach((param, value) async {
      if (value == null) return;
      _params[param] = value;
      await DspApi.setVoiceParamByPath(_id, param, value);
    });
  }

  Future<void> _modify(Map<String, double> newParams) {
    newParams.forEach((param, value) async {
      if (value == null) return;
      _params[param] = value;
      await DspApi.setVoiceParamByPath(_id, param, value);
    });
    return null;
  }

  void stop() {
    DspApi.deleteVoice(_id);
  }
}

class Synthesizer {
  Map<int, Voice> voices = {};

  Voice newVoice(int id, VoiceParams voiceParams) {

    voices[id] = new Voice({
      'freq': voiceParams.freq,
      'gain': voiceParams.gain,
      'gate': 1,
      'osc/noise/level': voiceParams.noiseLevel,
      'osc/saw/level': voiceParams.sawLevel,
    });
    return voices[id];
  }

  Future<Voice> modifyVoice(int id, VoiceParams voiceParams) async {
    await voices[id]._modify({
      'freq': voiceParams.freq,
      'gain': voiceParams.gain,
      'gate': voiceParams.gate,
      'osc/noise/level': voiceParams.noiseLevel,
      'osc/saw/level': voiceParams.sawLevel,
    });
    return voices[id];
  }

  Future<void> stopVoice(int id) async {
    return voices[id].stop();
  }
  
  Future<double> getCpuLoad() => DspApi.getCpuLoad();
}

class VoiceParams {
  VoiceParams({
    this.gain,
    this.gate,
    this.freq,
    this.sawLevel,
    this.noiseLevel,
  });
  final double gain;
  final double gate;
  final double freq;
  final double sawLevel;
  final double noiseLevel;
}