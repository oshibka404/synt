import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SyntLocalizations {
  SyntLocalizations(this.locale);

  final Locale locale;

  static SyntLocalizations of(BuildContext context) {
    return Localizations.of<SyntLocalizations>(context, SyntLocalizations);
  }

  static Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'Synt': 'Synt',
      'Ready to record': 'Ready to record',
      'Recording': 'Recording',
      'Tempo': 'Tempo',
      'Scale': 'Scale',
      'Delete all loops': 'Delete all loops',

      // Scales
      'Chromatic': 'Chromatic',
      'Pentatonic': 'Pentatonic',
      'Blues': 'Blues',
      'Harmonic minor': 'Harmonic minor',
      'Melodicminor': 'Melodic minor',
      'Major': 'Major',
      'Minor': 'Minor',
      'Ionian': 'Ionian',
      'Dorian': 'Dorian',
      'Phrygian': 'Phrygian',
      'Lydian': 'Lydian',
      'Myxolydian': 'Myxolydian',
      'Aeolian': 'Aeolian',
      'Locrian': 'Locrian',
    },
    'ru': {
      'Synt': 'Синт',
      'Ready to record': 'Готов записывать',
      'Recording': 'Запись',
      'Tempo': 'Темп',
      'Scale': 'Гамма',
      'Delete all loops': 'Удалить все лупы',

      // Scales
      'Chromatic': 'Хроматическая',
      'Pentatonic': 'Пентатоника',
      'Blues': 'Блюзовая',
      'Harmonic minor': 'Гармонический минор',
      'Melodic minor': 'Мелодический минор',
      'Major': 'Мажор',
      'Minor': 'Минор',
      'Ionian': 'Ионийский лад',
      'Dorian': 'Дорийский лад',
      'Phrygian': 'Фригийский лад',
      'Lydian': 'Лидийский лад',
      'Myxolydian': 'Миксолидийский лад',
      'Aeolian': 'Эолийский лад',
      'Locrian': 'Локрийский лад',
    },
  };

  String getLocalized(String base) {
    if (_localizedValues[locale.languageCode] == null ||
        _localizedValues[locale.languageCode][base] == null) {
      print("No ${locale.languageCode} translation for $base");
      return base;
    }
    return _localizedValues[locale.languageCode][base];
  }
}

class SyntLocalizationsDelegate
    extends LocalizationsDelegate<SyntLocalizations> {
  const SyntLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'ru'].contains(locale.languageCode);

  @override
  Future<SyntLocalizations> load(Locale locale) {
    return SynchronousFuture<SyntLocalizations>(SyntLocalizations(locale));
  }

  @override
  bool shouldReload(SyntLocalizationsDelegate old) => false;
}
