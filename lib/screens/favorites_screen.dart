import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/recipe_data.dart';
import '../models/recipe_model.dart';
import '../providers/favorite_provider.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favoriteProvider = Provider.of<FavoriteProvider>(context);
    final allRecipes = RecipeData.getRecipes();
    final favoriteRecipes = allRecipes
        .where((recipe) => favoriteProvider.isFavorite(recipe.id))
        .toList();

    return Scaffold(
      backgroundColor: Colors.grey[50], // sama dengan beranda
      appBar: AppBar(
        title: const Text(
          'Resep Favorit',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
      ),
      body: favoriteRecipes.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.favorite_border,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Belum ada resep favorit',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tekan ikon hati pada resep untuk menambahkan',
                    style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.restaurant_menu),
                    label: const Text('Jelajahi Resep'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: favoriteRecipes.length,
              itemBuilder: (context, index) {
                final recipe = favoriteRecipes[index];
                return _ModernFavoriteCard(recipe: recipe);
              },
            ),
    );
  }
}

class _ModernFavoriteCard extends StatelessWidget {
  final Recipe recipe;
  const _ModernFavoriteCard({required this.recipe});

  String _getImagePath(String recipeName) {
    final Map<String, String> imageMap = {
      'Ayam Goreng Bumbu Kuning': 'ayam goreng bumbu kuning.jpeg',
      'Ayam Kecap Pedas': 'ayam kecap pedas.jpeg',
      'Ayam Mentega': 'ayam mentega.jpeg',
      'Telur Dadar Ayam': 'Telur Dadar Ayam.jpeg',
      'Ayam Rica-Rica': 'ayam rica-rica.jpeg',
      'Ayam Bakar Madu': 'ayam bakar madu.jpeg',
      'Ayam Pop': 'ayam pop.jpeg',
      'Ayam Taliwang': 'ayam taliwang.jpeg',
      'Ayam Suwir Bali': 'ayam suir bali.jpeg',
      'Ayam Betutu': 'ayam betutu.jpeg',
    };
    return 'assets/images/${imageMap[recipeName] ?? 'default.jpeg'}';
  }

  @override
  Widget build(BuildContext context) {
    final favoriteProvider = Provider.of<FavoriteProvider>(context);

    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/detail', arguments: recipe),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar dengan icon favorite dan badge durasi
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                    child: Image.asset(
                      _getImagePath(recipe.name),
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      errorBuilder: (_, __, ___) => Container(
                        color: Colors.grey[200],
                        child: const Icon(
                          Icons.fastfood,
                          size: 40,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  // Icon favorite (merah karena favorit)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () {
                        favoriteProvider.toggleFavorite(recipe.id);
                        // Tidak perlu panggil onFavoriteRemoved karena akan di-refresh otomatis
                      },
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.favorite,
                          color: Colors.red,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                  // Badge durasi
                  Positioned(
                    bottom: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.access_time,
                            size: 12,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${recipe.cookingTime} min',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Nama resep dan difficulty
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: _getDifficultyColor(
                        recipe.difficulty,
                      ).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      recipe.difficulty,
                      style: TextStyle(
                        fontSize: 10,
                        color: _getDifficultyColor(recipe.difficulty),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty) {
      case 'Mudah':
        return Colors.green;
      case 'Sedang':
        return Colors.orange;
      case 'Sulit':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
