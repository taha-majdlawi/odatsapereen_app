import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReadProvider with ChangeNotifier {
  List<String> _readChapters = [];

  List<String> get readChapters => _readChapters;

  ReadProvider() {
    _loadReadChapters();
  }

  void _loadReadChapters() async {
    final prefs = await SharedPreferences.getInstance();
    _readChapters = prefs.getStringList('readChapters') ?? [];
    notifyListeners();
  }

  void markAsRead(String title) async {
    final prefs = await SharedPreferences.getInstance();
    if (!_readChapters.contains(title)) {
      _readChapters.add(title);
      await prefs.setStringList('readChapters', _readChapters);
      notifyListeners();
    }
  }

  bool isRead(String title) {
    return _readChapters.contains(title);
  }

  void unmarkAsRead(String title) async {
    final prefs = await SharedPreferences.getInstance();
    _readChapters.remove(title);
    await prefs.setStringList('readChapters', _readChapters);
    notifyListeners();
  }
}
