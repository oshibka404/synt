import 'package:perfect_first_synth/synth/dsp_api.dart';

class Voice {
  int _id;

  Map<String, double> _params;

  Map<String, double> get params => _params;
  
  Voice(Map<String, double> params) {
    _initVoice(params);
  }

  void _initVoice(Map<String, double> params) async {
    _id = await DspApi.newVoice();
    params.forEach((param, value) {
      DspApi.setVoiceParamByPath(_id, param, value);
    });
  }

  void _modify(Map<String, double> newParams) {
    newParams.forEach((param, value) {
      DspApi.setVoiceParamByPath(_id, param, value);
    });
  }

  void stop() {
    DspApi.deleteVoice(_id);
  }
}

class Synthesizer {
  Map<int, Voice> voices = {};

  Future<Voice> newVoice(int id, {double freq, double gain}) async {
    voices[id] = new Voice({
      'freq': freq,
      'gain': gain,
      'gate': 1
    });
    return voices[id];
  }

  Future<Voice> modifyVoice(int id, {double freq, double gain}) async {
    DspApi.setParamValueByPath('gain', gain);
    DspApi.setParamValueByPath('freq', freq);
    voices[id]._modify({
      'freq': freq,
      'gain': gain,
      'gate': 1
    });
    return voices[id];
  }

  void stopVoice(int id) async {
    return voices[id].stop();
  }
}