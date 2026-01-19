import 'package:flutter/material.dart';
import 'package:odatsapereen_app/screens/chapter_detailes_screens.dart';
import 'package:odatsapereen_app/screens/reading_progress_screen.dart';
import 'package:odatsapereen_app/screens/search_screen.dart';
import 'package:odatsapereen_app/screens/favorites_screen.dart';
import 'package:odatsapereen_app/utils/read_provider.dart';
import 'package:provider/provider.dart';

import '../data/chapters_data_clean.dart';
import '../utils/settings_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final readProvider = Provider.of<ReadProvider>(context);
    final settings = Provider.of<SettingsProvider>(context);

    final primaryColor = Theme.of(context).colorScheme.primary;
    final cardColor = Theme.of(context).cardColor;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'عدة الصابرين',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          textDirection: TextDirection.rtl,
        ),
        centerTitle: true,
        actions: [
          // زر البحث
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SearchScreen()),
              );
            },
          ),

          // زر المفضلة
          IconButton(
            icon: const Icon(Icons.star_border),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FavoritesScreen()),
              );
            },
          ),
        ],
      ),

      // القائمة الجانبية
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: primaryColor),
              child: const Center(
                child: Text(
                  'إعدادات التطبيق',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                  textDirection: TextDirection.rtl,
                ),
              ),
            ),

            // عن التطبيق
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('عن التطبيق'),
              onTap: () {
                showAboutDialog(
                  context: context,
                  applicationName: 'عدة الصابرين',
                  applicationVersion: '1.0',
                  applicationLegalese: 'إعداد طالب علم',
                  children: const [
                    SizedBox(height: 16),
                    Text(
                      'تطبيق يعرض محتوى كتاب ابن القيم "عدة الصابرين وذخيرة الشاكرين" بأسلوب مريح يساعد على القراءة والتدبر في أي وقت.',
                      textDirection: TextDirection.rtl,
                    ),
                  ],
                );
              },
            ),

            // الوضع الليلي
            SwitchListTile(
              title: const Text('الوضع الليلي'),
              secondary: const Icon(Icons.dark_mode),
              value: settings.isDarkMode,
              onChanged: (val) => settings.toggleDarkMode(),
            ),

            // حجم الخط
            ListTile(
              leading: const Icon(Icons.text_fields),
              title: const Text('حجم الخط'),
              subtitle: Text('${settings.fontSize.toInt()}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: settings.decreaseFont,
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: settings.increaseFont,
                  ),
                ],
              ),
            ),

            // تقدم القراءة
            ListTile(
              leading: const Icon(Icons.bar_chart),
              title: const Text('تقدم القراءة'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ReadingProgressScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),

      // محتوى الصفحة
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            width: double.infinity,
            color: primaryColor.withValues(alpha: 0.08),
            child: const Text(
              'هذا التطبيق يعرض كتاب "عدة الصابرين" لابن القيم بأسلوب بسيط يساعد على القراءة والتدبر. اضغط على أي فصل للبدء.',
              style: TextStyle(fontSize: 16),
              textDirection: TextDirection.rtl,
            ),
          ),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: chapters.length,
              itemBuilder: (context, index) {
                final chapter = chapters[index];
                final isRead = readProvider.isRead(chapter['title']);

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  color: cardColor,
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    title: Text(
                      chapter['title'],
                      textDirection: TextDirection.rtl,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (isRead)
                          const Icon(Icons.check_circle, color: Colors.green),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward_ios, size: 18),
                      ],
                    ),
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
          ),
        ],
      ),
    );
  }
}
