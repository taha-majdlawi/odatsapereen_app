import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:odatsapereen_app/screens/youtube_player_screem.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../utils/read_provider.dart';
import '../utils/favorites_provider.dart';
import '../utils/notes_provider.dart';
import '../utils/read_position_provider.dart';

class ChapterDetailScreen extends StatefulWidget {
  final Map<String, dynamic> chapter;

  const ChapterDetailScreen({super.key, required this.chapter});

  @override
  State<ChapterDetailScreen> createState() => _ChapterDetailScreenState();
}

class _ChapterDetailScreenState extends State<ChapterDetailScreen> {
  final ScrollController _scrollController = ScrollController();

  bool _showReadButton = false;
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final title = widget.chapter['title'] ?? '';

      Provider.of<NotesProvider>(context, listen: false).loadNotes(title);

      final posProvider = Provider.of<ReadPositionProvider>(
        context,
        listen: false,
      );

      await posProvider.loadPosition(title);
      final savedOffset = posProvider.getPosition(title);

      if (savedOffset > 0) {
        await Future.delayed(const Duration(milliseconds: 120));
        if (_scrollController.hasClients) {
          final max = _scrollController.position.maxScrollExtent;
          final target = savedOffset.clamp(0.0, max);
          _scrollController.jumpTo(target);
        }
      }
    });

    _scrollController.addListener(() {
      final max = _scrollController.position.maxScrollExtent;
      final current = _scrollController.position.pixels;
      final title = widget.chapter['title'] ?? '';

      if (max <= 0) return;

      final newProgress = (current / max).clamp(0.0, 1.0);

      if ((newProgress - _progress).abs() > 0.02) {
        setState(() => _progress = newProgress);
      }

      if (current >= max - 50 && !_showReadButton) {
        setState(() => _showReadButton = true);
      }

      Provider.of<ReadPositionProvider>(
        context,
        listen: false,
      ).savePositionDebounced(title, current);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _copyContent(BuildContext context) {
    Clipboard.setData(ClipboardData(text: widget.chapter['content'] ?? ''));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('تم نسخ النص إلى الحافظة')));
  }
void _launchYouTubeVideo(BuildContext context) {
  final rawUrl = widget.chapter['videoUrl']?.toString().trim();

  if (rawUrl == null || rawUrl.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('لا يوجد رابط فيديو')),
    );
    return;
  }

  final videoId = YoutubePlayer.convertUrlToId(rawUrl);

  if (videoId == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('رابط يوتيوب غير صالح')),
    );
    return;
  }

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => YouTubeVideoScreen(videoId: videoId),
    ),
  );
}



  void _openAddNoteSheet(BuildContext context, String title) {
    final controller = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                'إضافة ملاحظة جديدة',
                textDirection: TextDirection.rtl,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: controller,
                maxLines: 4,
                textDirection: TextDirection.rtl,
                decoration: const InputDecoration(
                  hintText: 'اكتب ملاحظتك هنا...',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  child: const Text('حفظ الملاحظة'),
                  onPressed: () {
                    if (controller.text.trim().isEmpty) return;

                    Provider.of<NotesProvider>(
                      context,
                      listen: false,
                    ).addNote(title, controller.text.trim());

                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('تم حفظ الملاحظة')),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  void _openViewNotesSheet(BuildContext context, String title) {
    final notesProvider = Provider.of<NotesProvider>(context, listen: false);
    final notes = notesProvider.getNotes(title);

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                'ملاحظات هذا الفصل',
                textDirection: TextDirection.rtl,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              if (notes.isEmpty) const Text('لا توجد ملاحظات بعد'),

              ...List.generate(notes.length, (index) {
                return Card(
                  child: ListTile(
                    title: Text(notes[index], textDirection: TextDirection.rtl),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        notesProvider.deleteNote(title, index);
                        Navigator.pop(context);
                        _openViewNotesSheet(context, title);
                      },
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.chapter['title'] ?? '';
    final content = widget.chapter['content'] ?? '';
    final fontSize = Theme.of(context).textTheme.bodyLarge?.fontSize ?? 18;

    final favProvider = Provider.of<FavoritesProvider>(context);
    final readProvider = Provider.of<ReadProvider>(context);
    final notesProvider = Provider.of<NotesProvider>(context);

    final isRead = readProvider.isRead(title);
    final hasNotes = notesProvider.getNotes(title).isNotEmpty;

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
              favProvider.isFavorite(title) ? Icons.star : Icons.star_border,
            ),
            onPressed: () => favProvider.toggleFavorite(title),
          ),
        ],
      ),

      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (hasNotes)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: FloatingActionButton.small(
                heroTag: 'view_notes_btn',
                child: const Icon(Icons.description),
                onPressed: () => _openViewNotesSheet(context, title),
              ),
            ),
          FloatingActionButton(
            heroTag: 'add_note_btn',
            child: const Icon(Icons.edit_note),
            onPressed: () => _openAddNoteSheet(context, title),
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
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: _progress,
                        color: Theme.of(context).colorScheme.primary,
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.15),
                        minHeight: 8,
                      ),
                    ),

                    const SizedBox(height: 8),

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

                    if (_showReadButton)
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          icon: Icon(
                            isRead ? Icons.undo : Icons.check_circle,
                            color: isRead ? Colors.red : Colors.green,
                          ),
                          label: Text(
                            isRead ? 'إلغاء القراءة' : 'تمت القراءة',
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
