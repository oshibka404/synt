class SynthPreset {
  final Map<String, double> params;
  SynthPreset(this.params);

  operator [](String key) => params[key];
  operator []=(String key, double value) {
    params[key] = value;
  }
}
