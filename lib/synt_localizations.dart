import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SyntLocalizations {
  static Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'Synt': 'Synt',
      'Ready to record': 'Ready to record',
      'Recording': 'Recording',
      'Tempo': 'Tempo',
      'Sync with Pocket Operator': 'Sync with Pocket Operator',
      'Scale': 'Scale',
      'Delete all loops': 'Delete all loops',

      // Scales
      'Chromatic': 'Chromatic',
      'Pentatonic': 'Pentatonic',
      'Blues': 'Blues',
      'Harmonic minor': 'Harmonic minor',
      'Melodic minor': 'Melodic minor',
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
      'Sync with Pocket Operator': 'Сихронизация с Pocket Operator',
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

  final Locale locale;

  SyntLocalizations(this.locale);

  String getLocalized(String base) {
    if (_localizedValues[locale.languageCode] == null ||
        _localizedValues[locale.languageCode][base] == null) {
      print("No ${locale.languageCode} translation for $base");
      return base;
    }
    return _localizedValues[locale.languageCode][base];
  }

  // TODO: create getter per string

  static SyntLocalizations of(BuildContext context) {
    return Localizations.of<SyntLocalizations>(context, SyntLocalizations);
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
