import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesProvider with ChangeNotifier {
  List<String> _favorites = [];

  List<String> get favorites => _favorites;

  FavoritesProvider() {
    _loadFavorites();
  }

  void _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    _favorites = prefs.getStringList('favorites') ?? [];
    notifyListeners();
  }

  void toggleFavorite(String title) async {
    final prefs = await SharedPreferences.getInstance();

    if (_favorites.contains(title)) {
      _favorites.remove(title);
    } else {
      _favorites.add(title);
    }

    await prefs.setStringList('favorites', _favorites);
    notifyListeners();
  }

  bool isFavorite(String title) {
    return _favorites.contains(title);
  }
}
