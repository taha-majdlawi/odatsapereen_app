import 'package:flutter/material.dart';

class ChapterDetailScreen extends StatelessWidget {
  final Map<String, dynamic> chapter;

  const ChapterDetailScreen({super.key, required this.chapter});

  @override
  Widget build(BuildContext context) {
    final title = chapter['title'];
    final content = chapter['content'];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          textDirection: TextDirection.rtl,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF2F2F2), Color(0xFFEAEAEA)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                title,
                textDirection: TextDirection.rtl,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                content,
                textDirection: TextDirection.rtl,
                style: const TextStyle(
                  fontSize: 18,
                  height: 1.8,
                  color: Color(0xFF444444),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
