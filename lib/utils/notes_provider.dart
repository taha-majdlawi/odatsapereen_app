import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotesProvider with ChangeNotifier {
  final Map<String, List<String>> _notes = {};

  List<String> getNotes(String key) => _notes[key] ?? [];

  Future<void> loadNotes(String key) async {
    final prefs = await SharedPreferences.getInstance();
    _notes[key] = prefs.getStringList('notes_$key') ?? [];
    notifyListeners();
  }

  Future<void> addNote(String key, String note) async {
    final prefs = await SharedPreferences.getInstance();
    final list = _notes[key] ?? [];
    list.add(note);
    _notes[key] = list;
    await prefs.setStringList('notes_$key', list);
    notifyListeners();
  }

  Future<void> deleteNote(String key, int index) async {
    final prefs = await SharedPreferences.getInstance();
    final list = _notes[key] ?? [];
    list.removeAt(index);
    _notes[key] = list;
    await prefs.setStringList('notes_$key', list);
    notifyListeners();
  }
}
