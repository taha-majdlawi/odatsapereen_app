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
    final filteredResults = chapters.where((chapter) {
      final content = chapter['content'].toString().toLowerCase();
      final title = chapter['title'].toString().toLowerCase();
      final q = query.toLowerCase();

      // البحث في العنوان + النص الكامل
      return content.contains(q) || title.contains(q);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'البحث في الكتاب',
          textDirection: TextDirection.rtl,
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(14),
            child: TextField(
              textDirection: TextDirection.rtl,
              decoration: const InputDecoration(
                hintText: 'ابحث عن كلمة أو عبارة داخل الكتاب...',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (val) {
                setState(() => query = val.trim());
              },
            ),
          ),
          Expanded(
            child: filteredResults.isEmpty
                ? const Center(
                    child: Text(
                      'لا توجد نتائج مطابقة',
                      style: TextStyle(fontSize: 16),
                      textDirection: TextDirection.rtl,
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredResults.length,
                    itemBuilder: (_, i) {
                      final chapter = filteredResults[i];

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        elevation: 2,
                        child: ListTile(
                          title: Text(
                            chapter['title'],
                            textDirection: TextDirection.rtl,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Text(
                            _buildPreview(chapter['content'], query),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textDirection: TextDirection.rtl,
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    ChapterDetailScreen(chapter: chapter),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
          )
        ],
      ),
    );
  }

  /// استخراج مقطع من النص حول كلمة البحث
  String _buildPreview(String content, String query) {
    if (query.isEmpty) return content.substring(0, 100.clamp(0, content.length));

    final lowerContent = content.toLowerCase();
    final lowerQuery = query.toLowerCase();

    final index = lowerContent.indexOf(lowerQuery);
    if (index == -1) {
      return content.substring(0, 120.clamp(0, content.length));
    }

    final start = (index - 40).clamp(0, content.length);
    final end = (index + 60).clamp(0, content.length);

    return content.substring(start, end) + '...';
  }
}
