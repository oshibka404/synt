import 'dsp_api.dart';

/// Handles voices and calls underlying [DspApi].
class Synthesizer {
  Map<int, Voice> voices = {};

  Future<double> getCpuLoad() => DspApi.getCpuLoad();

  Future<Voice> modifyVoice(int id, VoiceParams voiceParams) async {
    await voices[id]._modify({
      'freq': voiceParams.freq,
      'gain': voiceParams.gain,
      'gate': voiceParams.gate,
      'modulation': voiceParams.modulation,
      ...voiceParams.params,
    });
    return voices[id];
  }

  Voice newVoice(int id, VoiceParams voiceParams) {
    voices[id] = new Voice({
      'freq': voiceParams.freq,
      'gain': voiceParams.gain,
      'gate': 1,
      'modulation': voiceParams.modulation,
      ...voiceParams.params,
    });
    return voices[id];
  }

  Future<void> stopVoice(int id) async {
    if (voices[id] == null) return;
    return voices[id].stop();
  }
}

class Voice {
  int _id = 0;

  Map<String, double> _params = {};

  Voice(Map<String, double> params) {
    _initVoice(params);
  }

  Map<String, double> get params => _params;

  Future<void> stop() async {
    if (_id == 0) {
      await Future.delayed(const Duration(milliseconds: 10), () {
        stop();
      });
    }
    return DspApi.deleteVoice(_id);
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
      if (value == null || _id == 0) return;
      _params[param] = value;
      await DspApi.setVoiceParamByPath(_id, param, value);
    });
    return null;
  }
}

class VoiceParams {
  final double gain;
  final double gate;
  final double freq;
  final double modulation;
  final Map<String, double> params;
  VoiceParams({
    this.gain,
    this.gate,
    this.freq,
    this.modulation,
    this.params,
  });
}
