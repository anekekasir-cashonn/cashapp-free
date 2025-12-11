import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:cashapp_free/providers/settings_provider.dart';

class LocalizationHelper {
  static final LocalizationHelper _instance = LocalizationHelper._internal();
  
  factory LocalizationHelper() {
    return _instance;
  }
  
  LocalizationHelper._internal();
  
  Map<String, dynamic>? _enTranslations;
  Map<String, dynamic>? _idTranslations;
  
  Future<void> initialize() async {
    try {
      final enJson = await rootBundle.loadString('assets/lang/en.json');
      _enTranslations = jsonDecode(enJson);
    } catch (e) {
      // If asset loading fails (e.g. not bundled), fall back to empty map
      // and avoid throwing so app can still start.
      _enTranslations = <String, dynamic>{};
      // Log to console for debugging
      // ignore: avoid_print
      print('Localization: failed to load assets/lang/en.json -> $e');
    }

    try {
      final idJson = await rootBundle.loadString('assets/lang/id.json');
      _idTranslations = jsonDecode(idJson);
    } catch (e) {
      _idTranslations = <String, dynamic>{};
      // ignore: avoid_print
      print('Localization: failed to load assets/lang/id.json -> $e');
    }
  }
  
  String getTranslation(String key, String language) {
    final translations = language == 'id' ? _idTranslations : _enTranslations;
    
    // Support nested keys like "home_screen.title"
    final keys = key.split('.');
    dynamic value = translations;
    
    for (final k in keys) {
      if (value is Map<String, dynamic>) {
        value = value[k];
      } else {
        return key; // Return key if not found
      }
    }
    
    return value?.toString() ?? key;
  }
  
  String translate(String key, String language) {
    return getTranslation(key, language);
  }
}

// Helper function for easy access
String t(String key, String language) {
  return LocalizationHelper().getTranslation(key, language);
}
