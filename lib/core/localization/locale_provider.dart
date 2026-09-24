import 'package:flutter/material.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  void setLocale(Locale locale) {
    if (locale.languageCode == _locale.languageCode) return;
    _locale = locale;
    notifyListeners();
  }

  void toggleLocale() {
    setLocale(
      _locale.languageCode == 'en' ? const Locale('bn') : const Locale('en'),
    );
  }
}
