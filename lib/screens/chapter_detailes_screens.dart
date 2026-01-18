import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class ChapterDetailScreen extends StatelessWidget {
  final Map<String, dynamic> chapter;

  const ChapterDetailScreen({super.key, required this.chapter});

  void _copyContent(BuildContext context) {
    Clipboard.setData(ClipboardData(text: chapter['content'] ?? ''));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('📋 تم نسخ النص إلى الحافظة')),
    );
  }

  void _launchYouTubeVideo(BuildContext context) async {
    final url = chapter['videoUrl'];
    if (url != null && await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تعذر فتح رابط الفيديو')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = chapter['title'] ?? '';
    final content = chapter['content'] ?? '';
    final fontSize = Theme.of(context).textTheme.bodyLarge?.fontSize ?? 18;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          textDirection: TextDirection.rtl,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF2F2F2), Color(0xFFEAEAEA)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 4),
                    )
                  ],
                ),
                child: SelectableText(
                  content,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(fontSize: fontSize, height: 1.8),
                  showCursor: true,
                  cursorColor: Colors.blueGrey,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.copy),
                    label: const Text('نسخ النص'),
                    onPressed: () => _copyContent(context),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.video_library),
                    label: const Text('مشاهدة الشرح'),
                    onPressed: () => _launchYouTubeVideo(context),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
