import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  Future<void> _completeIntro(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seenIntro', true);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF9F9F9), Color(0xFFE8E8E8)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.menu_book, size: 100, color: Colors.deepPurple),
            const SizedBox(height: 32),
            const Text(
              '📚 عدة الصابرين وذخيرة الشاكرين',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(height: 16),
            const Text(
              'تطبيق يعرض محتوى كتاب ابن القيم، بأسلوب مريح وممتع.\nيهدف لمساعدتك على فهم قيمة الصبر والشكر.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, height: 1.6),
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => _completeIntro(context),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              ),
              child: const Text('ابدأ الآن', style: TextStyle(fontSize: 20)),
            ),
          ],
        ),
      ),
    );
  }
}
