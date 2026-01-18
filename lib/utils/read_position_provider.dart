import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReadPositionProvider with ChangeNotifier {
  final Map<String, double> _positions = {};
  Timer? _debounce;

  double getPosition(String key) => _positions[key] ?? 0.0;

  Future<void> loadPosition(String key) async {
    final prefs = await SharedPreferences.getInstance();
    _positions[key] = prefs.getDouble('scroll_$key') ?? 0.0;
    notifyListeners();
  }

  void savePositionDebounced(String key, double position) {
    _positions[key] = position;

    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 250), () async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble('scroll_$key', position);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
