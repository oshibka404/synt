class GlobalSettings {
  Map<String, dynamic> _settings;

  // TODO: parse and save keys one by one
  Map<String, dynamic> toJson() {
    return _settings;
  }

  GlobalSettings.fromJson(Map<String, dynamic> json) : _settings = json;

  dynamic operator [](String key) {
    return _settings[key];
  }

  operator []=(String key, dynamic value) {
    _settings[key] = value;
  }
}

/// Settings file example:
/// {
///   'po_sync': true
/// }
