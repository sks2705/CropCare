import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // Ensure this import for SynchronousFuture

class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  String get productsTitle {
    switch (locale.languageCode) {
      case 'hi':
        return 'उत्पाद'; // Hindi
      case 'ta':
        return 'உற்பத்திகள்'; // Tamil
      case 'en':
      default:
        return 'Products'; // English
    }
  }

  String get fertilizerCategory {
    switch (locale.languageCode) {
      case 'hi':
        return 'खाद'; // Hindi
      case 'ta':
        return 'சோதனை'; // Tamil
      case 'en':
      default:
        return 'Fertilizer'; // English
    }
  }

  String get pesticideCategory {
    switch (locale.languageCode) {
      case 'hi':
        return 'कीटनाशक'; // Hindi
      case 'ta':
        return 'பூச்சிக்கொல்லி'; // Tamil
      case 'en':
      default:
        return 'Pesticide'; // English
    }
  }

  // Add more localized strings here...
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      ['en', 'hi', 'ta'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) {
    return AppLocalizations.load(locale);
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
