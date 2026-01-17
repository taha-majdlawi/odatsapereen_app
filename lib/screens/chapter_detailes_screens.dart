import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:odatsapereen_app/utils/arabic_fix.dart';

class ChapterDetailScreen extends StatelessWidget {
  final Map<String, dynamic> chapter;

  const ChapterDetailScreen({super.key, required this.chapter});

  @override
  Widget build(BuildContext context) {
    final fixedTitle = ArabicFixer.fix(chapter['title']);
    final fixedContent = ArabicFixer.fix(ArabicFixer.fix(chapter['content']));

    return Scaffold(
      appBar: AppBar(
        title: Text(fixedTitle, textDirection: TextDirection.rtl),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Text(
          fixedContent,
          textDirection: TextDirection.rtl,
          style: const TextStyle(fontSize: 18, height: 1.7),
        ),
      ),
    );
  }
}
