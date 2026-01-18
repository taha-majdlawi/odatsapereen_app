import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';

import '../utils/favorites_provider.dart';

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
    final rawUrl = chapter['videoUrl']?.toString().trim();

    if (rawUrl == null || rawUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('لا يوجد رابط فيديو')),
      );
      return;
    }

    final Uri uri = Uri.parse(rawUrl);

    try {
      bool launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched) {
        await launchUrl(uri, mode: LaunchMode.platformDefault);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('عفواً! تعذر فتح الفيديو حتى في المتصفح')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = chapter['title'] ?? '';
    final content = chapter['content'] ?? '';
    final fontSize = Theme.of(context).textTheme.bodyLarge?.fontSize ?? 18;

    final favProvider = Provider.of<FavoritesProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          textDirection: TextDirection.rtl,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              favProvider.isFavorite(title)
                  ? Icons.star
                  : Icons.star_border,
            ),
            onPressed: () {
              favProvider.toggleFavorite(title);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    favProvider.isFavorite(title)
                        ? '❌ تمت الإزالة من المفضلة'
                        : '⭐ تمت الإضافة إلى المفضلة'

                  ),
                ),
              );
            },
          ),
        ],
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
                  boxShadow: const [
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
