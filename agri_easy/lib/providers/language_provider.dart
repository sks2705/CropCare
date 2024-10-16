import 'package:flutter/material.dart';

class LanguageProvider with ChangeNotifier {
  Locale _locale = const Locale('en', ''); // Default to English

  Locale get locale => _locale;

  void setLanguage(String languageCode) {
    switch (languageCode) {
      case 'hi':
        _locale = const Locale('hi', '');
        break;
      case 'ta':
        _locale = const Locale('ta', '');
        break;
      case 'others':
        _locale = const Locale('en', '');
        break;
      default:
        _locale = const Locale('en', '');
        break;
    }
    notifyListeners();
  }
}
