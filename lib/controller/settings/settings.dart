import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

abstract class Settings {
  Settings();

  String fileName;

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _globalSettingsFile async {
    final path = await _localPath;
    return File('$path/$fileName');
  }

  void save() async {
    final file = await _globalSettingsFile;
    var encodedSettings = jsonEncode(this);
    file.writeAsString(encodedSettings);
  }

  Future<void> load() async {
    final file = await _globalSettingsFile;
    String contents = await file.readAsString();

    Map<String, dynamic> rawSettings = jsonDecode(contents);

    applyValues(rawSettings);
  }

  void applyValues(Map<String, dynamic> rawSettings);
  Map<String, dynamic> toJson();
}
