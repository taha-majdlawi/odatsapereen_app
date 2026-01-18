import 'package:flutter/material.dart';
import '../data/chapters_data_clean.dart';
import 'chapter_detailes_screens.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String query = '';

  @override
  Widget build(BuildContext context) {
    final results = chapters.where((chapter) {
      final content = chapter['content'].toString();
      return content.contains(query);
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('🔍 البحث في الكتاب')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'ابحث عن كلمة أو عبارة...',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (val) {
                setState(() => query = val);
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: results.length,
              itemBuilder: (_, i) {
                final chapter = results[i];
                return ListTile(
                  title: Text(chapter['title'], textDirection: TextDirection.rtl),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChapterDetailScreen(chapter: chapter),
                      ),
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
