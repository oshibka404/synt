import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import 'global_settings.dart';

class SettingsController {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _globalSettingsFile async {
    final path = await _localPath;
    return File('$path/pref_po_sync.json');
  }

  void set(String key, dynamic value) async {
    var settings = await loadGlobal();
    settings[key] = value;
    saveGlobal(settings);
  }

  void saveGlobal(GlobalSettings settings) async {
    final file = await _globalSettingsFile;
    var encodedSettings = jsonEncode(settings);
    file.writeAsString(encodedSettings);
  }

  Future<GlobalSettings> loadGlobal() async {
    try {
      final file = await _globalSettingsFile;
      String contents = await file.readAsString();

      Map<String, dynamic> rawSettings = jsonDecode(contents);

      return GlobalSettings.fromJson(rawSettings);
    } catch (e) {
      return null;
    }
  }
}
