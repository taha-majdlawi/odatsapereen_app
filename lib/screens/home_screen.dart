import 'package:flutter/material.dart';
import 'package:odatsapereen_app/screens/chapter_detailes_screens.dart';
import '../data/chapters_data_clean.dart';
import '../utils/arabic_fix.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('عدة الصابرين', textDirection: TextDirection.rtl),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: chapters.length,
        itemBuilder: (context, index) {
          final chapter = chapters[index];
          final fixedTitle = ArabicFixer.fix( ArabicFixer.fix(chapter['title']));

          return ListTile(
            title: Text(
              fixedTitle,
              textDirection: TextDirection.rtl,
              style: const TextStyle(fontSize: 18),
            ),
            trailing: const Icon(Icons.arrow_forward_ios),
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
    );
  }
}
