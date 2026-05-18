import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Locale Provider for managing app language
/// Handles language selection, persistence, and dynamic switching
class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('en');
  
  Locale get locale => _locale;
  
  /// Initialize locale from saved preference
  Future<void> loadSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLanguageCode = prefs.getString('language_code') ?? 'en';
    _locale = Locale(savedLanguageCode);
    notifyListeners();
  }
  
  /// Set new locale and save to preferences
  Future<void> setLocale(Locale locale) async {
    if (!supportedLocales.contains(locale)) return;
    
    _locale = locale;
    notifyListeners();
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', locale.languageCode);
  }
  
  /// Clear saved locale
  Future<void> clearLocale() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('language_code');
  }
  
  /// Get language name for display
  String getLanguageName(String languageCode) {
    switch (languageCode) {
      case 'en':
        return 'English';
      case 'te':
        return 'తెలుగు';
      case 'hi':
        return 'हिन्दी';
      case 'ta':
        return 'தமிழ்';
      case 'kn':
        return 'ಕನ್ನಡ';
      default:
        return 'English';
    }
  }
  
  /// Map display language name to locale
  Locale getLocaleFromLanguageName(String languageName) {
    switch (languageName) {
      case 'English':
        return const Locale('en');
      case 'Telugu':
      case 'తెలుగు':
        return const Locale('te');
      case 'Hindi':
      case 'हिन्दी':
        return const Locale('hi');
      case 'Tamil':
      case 'தமிழ்':
        return const Locale('ta');
      case 'Kannada':
      case 'ಕನ್ನಡ':
        return const Locale('kn');
      default:
        return const Locale('en');
    }
  }
  
  /// List of supported locales
  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('te'),
    Locale('hi'),
    Locale('ta'),
    Locale('kn'),
  ];
}
