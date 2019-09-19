import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalization {
  final Locale locale;

  AppLocalization(this.locale);

  String _translate(String key) {
    return _localizedStrings[key];
  }

  static String translate(BuildContext context, String key) {
    return Localizations.of<AppLocalization>(context, AppLocalization)
        ._translate(key);
  }

  static const LocalizationsDelegate<AppLocalization> delegate =
      _AppLocalizationsDelegates();

  Map<String, String> _localizedStrings;

  Future<bool> load() async {
    String jsonString = await rootBundle
        .loadString('localizations/${locale.languageCode}.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);
    _localizedStrings = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });
    return true;
  }
}

class _AppLocalizationsDelegates
    extends LocalizationsDelegate<AppLocalization> {
  const _AppLocalizationsDelegates();

  @override
  bool isSupported(Locale locale) => ['en', 'ar'].contains(locale.languageCode);

  @override
  Future<AppLocalization> load(Locale locale) async {
    AppLocalization localizations = AppLocalization(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegates old) => false;
}
