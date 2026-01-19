import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/chapters_data_clean.dart';
import '../utils/read_provider.dart';
import '../utils/read_position_provider.dart';

class ReadingProgressScreen extends StatelessWidget {
  const ReadingProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final readProvider = Provider.of<ReadProvider>(context);
    final posProvider = Provider.of<ReadPositionProvider>(context);

    final totalChapters = chapters.length;

    // عدد الفصول المقروءة كاملة
    final readCount = chapters
        .where((ch) => readProvider.isRead((ch['title'] ?? '').toString()))
        .length;

    final globalProgress =
        totalChapters == 0 ? 0.0 : (readCount / totalChapters).clamp(0.0, 1.0);

    final globalPercent = (globalProgress * 100).toStringAsFixed(0);

    final primaryColor = Theme.of(context).colorScheme.primary;
    final cardColor = Theme.of(context).cardColor;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'تقدم القراءة',
          textDirection: TextDirection.rtl,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // بطاقة التقدم العام
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'عدد الفصول المقروءة كاملة: $readCount من $totalChapters',
                    textDirection: TextDirection.rtl,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'نسبة الإنجاز الكلية: %$globalPercent',
                    textDirection: TextDirection.rtl,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: LinearProgressIndicator(
                      value: globalProgress,
                      minHeight: 12,
                      color: primaryColor,
                      backgroundColor:
                          primaryColor.withValues(alpha: 0.15),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'تقدم جميع الفصول',
                textDirection: TextDirection.rtl,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 10),

            // قائمة جميع الفصول مع نسبة التقدم لكل فصل
            Expanded(
              child: ListView.builder(
                itemCount: chapters.length,
                itemBuilder: (context, index) {
                  final chapter = chapters[index];
                  final title = (chapter['title'] ?? '').toString();
                  final content = (chapter['content'] ?? '').toString();

                  final savedScroll = posProvider.getPosition(title);

                  // تقدير طول الفصل بصريًا
                  final estimatedHeight = (content.length / 2).toDouble();

                  final progress = estimatedHeight <= 0
                      ? 0.0
                      : (savedScroll / estimatedHeight).clamp(0.0, 1.0);

                  final percent = (progress * 100).toStringAsFixed(0);

                  final isRead = readProvider.isRead(title);

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    color: cardColor,
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              Icon(
                                isRead
                                    ? Icons.check_circle
                                    : Icons.menu_book,
                                color: isRead
                                    ? Colors.green
                                    : Colors.blueGrey,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  title,
                                  textDirection: TextDirection.rtl,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 8),

                          Text(
                            'نسبة التقدم: %$percent',
                            textDirection: TextDirection.rtl,
                            style: const TextStyle(fontSize: 14),
                          ),

                          const SizedBox(height: 8),

                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: LinearProgressIndicator(
                              value: progress,
                              minHeight: 8,
                              color: primaryColor,
                              backgroundColor:
                                  primaryColor.withValues(alpha: 0.15),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
