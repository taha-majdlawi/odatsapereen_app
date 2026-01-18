import 'package:flutter/material.dart';
import 'package:odatsapereen_app/utils/favorites_provider.dart';
import 'package:odatsapereen_app/utils/notes_provider.dart';
import 'package:odatsapereen_app/utils/read_position_provider.dart';
import 'package:odatsapereen_app/utils/read_provider.dart';
import 'package:odatsapereen_app/utils/reading_position_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/home_screen.dart';
import 'screens/intro_screen.dart';
import 'utils/settings_provider.dart';
import 'utils/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool seenIntro = prefs.getBool('seenIntro') ?? false;

  runApp(MyApp(seenIntro: seenIntro));
}

class MyApp extends StatelessWidget {
  final bool seenIntro;

  const MyApp({super.key, required this.seenIntro});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
        ChangeNotifierProvider(create: (_) => ReadProvider()),
        ChangeNotifierProvider(create: (_) => ReadingPositionProvider()),
        ChangeNotifierProvider(create: (_) => NotesProvider()),
        ChangeNotifierProvider(create: (_) => ReadPositionProvider()),
      ],
      child: Consumer<SettingsProvider>(
        builder: (context, settings, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme(settings.fontSize),
            darkTheme: AppTheme.darkTheme(settings.fontSize),
            themeMode: settings.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: seenIntro ? const HomeScreen() : const IntroScreen(),
          );
        },
      ),
    );
  }
}
