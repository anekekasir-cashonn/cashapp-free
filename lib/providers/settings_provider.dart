import 'package:flutter/material.dart';

class SettingsProvider extends ChangeNotifier {
  bool _darkMode = false;
  String _language = 'en';

  bool get darkMode => _darkMode;
  String get language => _language;

  void setDarkMode(bool value) {
    _darkMode = value;
    notifyListeners();
  }

  void setLanguage(String lang) {
    _language = lang;
    notifyListeners();
  }
}
