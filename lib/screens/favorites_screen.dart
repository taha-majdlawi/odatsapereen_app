import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/favorites_provider.dart';
import '../data/chapters_data_clean.dart';
import 'chapter_detailes_screens.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favProvider = Provider.of<FavoritesProvider>(context);

    final favoriteChapters = chapters.where((chapter) {
      return favProvider.favorites.contains(chapter['title']);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('⭐ الفصول المفضلة', textDirection: TextDirection.rtl),
        centerTitle: true,
      ),
      body: favoriteChapters.isEmpty
          ? const Center(
              child: Text(
                'لا توجد فصول مفضلة بعد',
                style: TextStyle(fontSize: 18),
                textDirection: TextDirection.rtl,
              ),
            )
          : ListView.builder(
              itemCount: favoriteChapters.length,
              itemBuilder: (context, index) {
                final chapter = favoriteChapters[index];

                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    title: Text(
                      chapter['title'],
                      textDirection: TextDirection.rtl,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    leading: const Icon(Icons.star, color: Colors.amber),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () {
                        favProvider.toggleFavorite(chapter['title']);

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('تمت الإزالة من المفضلة'),
                          ),
                        );
                      },
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
    );
  }
}
