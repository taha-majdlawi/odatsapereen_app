import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReadingPositionProvider with ChangeNotifier {
  final Map<String, double> _positions = {};

  double getPosition(String title) => _positions[title] ?? 0.0;

  void savePosition(String title, double position) async {
    final prefs = await SharedPreferences.getInstance();
    _positions[title] = position;
    await prefs.setDouble('pos_$title', position);
  }

  Future<void> loadPosition(String title) async {
    final prefs = await SharedPreferences.getInstance();
    _positions[title] = prefs.getDouble('pos_$title') ?? 0.0;
    notifyListeners();
  }
}
