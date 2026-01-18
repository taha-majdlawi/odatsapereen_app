import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';

import '../utils/read_provider.dart';
import '../utils/favorites_provider.dart';

class ChapterDetailScreen extends StatefulWidget {
  final Map<String, dynamic> chapter;

  const ChapterDetailScreen({super.key, required this.chapter});

  @override
  State<ChapterDetailScreen> createState() => _ChapterDetailScreenState();
}

class _ChapterDetailScreenState extends State<ChapterDetailScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _showReadButton = false;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 50) {
        if (!_showReadButton) {
          setState(() {
            _showReadButton = true;
          });
        }
      }
    });
  }

  void _copyContent(BuildContext context) {
    Clipboard.setData(
        ClipboardData(text: widget.chapter['content'] ?? ''));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('📋 تم نسخ النص إلى الحافظة')),
    );
  }

  void _launchYouTubeVideo(BuildContext context) async {
    final rawUrl = widget.chapter['videoUrl']?.toString().trim();

    if (rawUrl == null || rawUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('لا يوجد رابط فيديو')),
      );
      return;
    }

    final Uri uri = Uri.parse(rawUrl);

    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تعذر فتح الفيديو')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.chapter['title'] ?? '';
    final content = widget.chapter['content'] ?? '';
    final fontSize = Theme.of(context).textTheme.bodyLarge?.fontSize ?? 18;

    final favProvider = Provider.of<FavoritesProvider>(context);
    final readProvider = Provider.of<ReadProvider>(context);

    final isRead = readProvider.isRead(title);

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
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
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
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        child: SelectableText(
                          content,
                          textDirection: TextDirection.rtl,
                          style: TextStyle(fontSize: fontSize, height: 1.8),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // يظهر فقط عند نهاية النص
                    if (_showReadButton)
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          icon: Icon(
                            isRead ? Icons.undo : Icons.check_circle,
                            color: isRead ? Colors.red : Colors.green,
                          ),
                          label: Text(
                            isRead ? 'إلغاء القراءة' : 'تمّت القراءة',
                            style: TextStyle(
                              fontSize: 18,
                              color: isRead ? Colors.red : Colors.green,
                            ),
                          ),
                          onPressed: () {
                            if (isRead) {
                              readProvider.unmarkAsRead(title);
                            } else {
                              readProvider.markAsRead(title);
                            }
                          },
                        ),
                      ),
                  ],
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
            ),
          ],
        ),
      ),
    );
  }
}
