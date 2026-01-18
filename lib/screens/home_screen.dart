import 'package:flutter/material.dart';
import 'package:odatsapereen_app/screens/chapter_detailes_screens.dart';
import 'package:provider/provider.dart';
import '../data/chapters_data_clean.dart';
import '../utils/settings_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '📚 عدة الصابرين',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          textDirection: TextDirection.rtl,
        ),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.deepPurple,
              ),
              child: Center(
                child: Text(
                  '📘 إعدادات التطبيق',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                  textDirection: TextDirection.rtl,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('عن التطبيق'),
              onTap: () {
                showAboutDialog(
                  context: context,
                  applicationName: 'عدة الصابرين',
                  applicationVersion: '1.0',
                  applicationLegalese: 'بواسطة طالب علم 🕌',
                  children: const [
                    SizedBox(height: 16),
                    Text(
                      'تطبيق يعرض محتوى كتاب ابن القيم "عدة الصابرين وذخيرة الشاكرين"، بأسلوب مريح يساعد على القراءة والتدبر في أي وقت.',
                      textDirection: TextDirection.rtl,
                    ),
                  ],
                );
              },
            ),
            SwitchListTile(
              title: const Text('الوضع الليلي'),
              secondary: const Icon(Icons.dark_mode),
              value: settings.isDarkMode,
              onChanged: (val) => settings.toggleDarkMode(),
            ),
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
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            width: double.infinity,
            child: const Text(
              '📖 هذا التطبيق يعرض كتاب "عدة الصابرين" لابن القيم بأسلوب بسيط للقراءة والفهم. اضغط على أي فصل للبدء.',
              style: TextStyle(fontSize: 16),
              textDirection: TextDirection.rtl,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: chapters.length,
              itemBuilder: (context, index) {
                final chapter = chapters[index];

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  elevation: 2,
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    title: Text(
                      chapter['title'],
                      textDirection: TextDirection.rtl,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
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
