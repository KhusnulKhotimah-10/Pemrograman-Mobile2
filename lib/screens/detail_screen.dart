import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/recipe_model.dart';
import '../providers/favorite_provider.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isAppBarTransparent = true;
  final List<bool> _checkedIngredients = [];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final isTransparent = _scrollController.offset < 200;
    if (isTransparent != _isAppBarTransparent) {
      setState(() {
        _isAppBarTransparent = isTransparent;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

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
    final fileName = imageMap[recipeName] ?? 'default.jpeg';
    return 'assets/images/$fileName';
  }

  @override
  Widget build(BuildContext context) {
    final recipe = ModalRoute.of(context)!.settings.arguments as Recipe;
    final favoriteProvider = Provider.of<FavoriteProvider>(context);
    final isFav = favoriteProvider.isFavorite(recipe.id);

    if (_checkedIngredients.isEmpty) {
      _checkedIngredients.addAll(
        List.generate(recipe.ingredients.length, (_) => false),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            expandedHeight: 350,
            pinned: true,
            floating: false,
            backgroundColor: _isAppBarTransparent
                ? Colors.transparent
                : Colors.white,
            elevation: 0,
            // Hanya satu tombol back di leading
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.black87,
                  size: 20,
                ),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              // Tombol favorit di AppBar
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isFav ? Icons.favorite : Icons.favorite_border,
                    color: isFav ? Colors.red : Colors.grey,
                    size: 20,
                  ),
                ),
                onPressed: () {
                  favoriteProvider.toggleFavorite(recipe.id);
                  setState(() {});
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: 'recipe_${recipe.id}',
                    child: Image.asset(
                      _getImagePath(recipe.name),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[300],
                          child: const Icon(
                            Icons.fastfood,
                            size: 80,
                            color: Colors.grey,
                          ),
                        );
                      },
                    ),
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                        stops: const [0.6, 1.0],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    left: 16,
                    right: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          recipe.name,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [
                              Shadow(blurRadius: 10, color: Colors.black26),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            _buildInfoChip(
                              Icons.access_time,
                              '${recipe.cookingTime} menit',
                            ),
                            const SizedBox(width: 8),
                            _buildInfoChip(
                              Icons.fitness_center,
                              recipe.difficulty,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Bahan-bahan',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  ...List.generate(recipe.ingredients.length, (index) {
                    return CheckboxListTile(
                      value: _checkedIngredients[index],
                      onChanged: (value) {
                        setState(() {
                          _checkedIngredients[index] = value ?? false;
                        });
                      },
                      title: Text(
                        recipe.ingredients[index],
                        style: TextStyle(
                          fontSize: 16,
                          decoration: _checkedIngredients[index]
                              ? TextDecoration.lineThrough
                              : null,
                          color: _checkedIngredients[index]
                              ? Colors.grey
                              : Colors.black,
                        ),
                      ),
                      activeColor: Colors.green,
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                    );
                  }),
                  const SizedBox(height: 24),
                  const Text(
                    'Langkah Memasak',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  ...List.generate(recipe.steps.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Center(
                              child: Text(
                                '${index + 1}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              recipe.steps[index],
                              style: const TextStyle(fontSize: 16, height: 1.4),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
