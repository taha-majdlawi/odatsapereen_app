import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  bool _isDarkMode = false;
  double _fontSize = 18;

  bool get isDarkMode => _isDarkMode;
  double get fontSize => _fontSize;

  SettingsProvider() {
    _loadSettings();
  }

  void _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('darkMode') ?? false;
    _fontSize = prefs.getDouble('fontSize') ?? 18;
    notifyListeners();
  }

  void toggleDarkMode() async {
    _isDarkMode = !_isDarkMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', _isDarkMode);
    notifyListeners();
  }

  void increaseFont() async {
    if (_fontSize < 30) {
      _fontSize += 1;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble('fontSize', _fontSize);
      notifyListeners();
    }
  }

  void decreaseFont() async {
    if (_fontSize > 12) {
      _fontSize -= 1;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble('fontSize', _fontSize);
      notifyListeners();
    }
  }
}
