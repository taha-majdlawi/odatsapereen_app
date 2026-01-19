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
        title: const Text(
          'الفصول المفضلة',
          textDirection: TextDirection.rtl,
        ),
        centerTitle: true,
      ),

      body: favoriteChapters.isEmpty
          ? Center(
              child: Text(
                'لا توجد فصول مفضلة بعد',
                style: Theme.of(context).textTheme.bodyLarge,
                textDirection: TextDirection.rtl,
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: favoriteChapters.length,
              itemBuilder: (context, index) {
                final chapter = favoriteChapters[index];

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 3,
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    title: Text(
                      chapter['title'],
                      textDirection: TextDirection.rtl,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    leading: Icon(
                      Icons.star,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline),
                      color: Colors.red,
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
