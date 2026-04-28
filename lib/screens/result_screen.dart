import 'package:flutter/material.dart';
import '../data/recipe_data.dart';
import '../services/recipe_matcher.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> userIngredients =
        ModalRoute.of(context)!.settings.arguments as List<String>;

    final recipes = RecipeData.getRecipes();
    final matchedRecipes = RecipeMatcher.matchRecipes(recipes, userIngredients);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hasil Pencarian Resep'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.orange[50],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Bahan yang Anda miliki:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: userIngredients
                      .map((ing) => Chip(
                            label: Text(ing),
                            backgroundColor: Colors.green[100],
                          ))
                      .toList(),
                ),
                const SizedBox(height: 8),
                Text(
                  'Ditemukan ${matchedRecipes.length} resep yang cocok',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: matchedRecipes.length,
              itemBuilder: (context, index) {
                final match = matchedRecipes[index];
                final recipe = match['recipe'];
                final matchPercentage = match['matchPercentage'].toDouble();

                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  elevation: 4,
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/detail',
                        arguments: recipe,
                      );
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  recipe.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: matchPercentage >= 70
                                      ? Colors.green
                                      : matchPercentage >= 40
                                          ? Colors.orange
                                          : Colors.grey,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  '${matchPercentage.toStringAsFixed(0)}% Match',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Bahan yang cocok: ${match['matchedIngredients'].length}/${match['totalIngredients']}',
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            children: (match['matchedIngredients'] as List)
                                .map((ing) => Chip(
                                      label: Text(ing),
                                      backgroundColor: Colors.green[50],
                                      avatar: const Icon(
                                        Icons.check,
                                        size: 16,
                                        color: Colors.green,
                                      ),
                                    ))
                                .toList(),
                          ),
                          if (match['missingIngredients'].isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Text(
                              'Bahan kurang:',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                            Wrap(
                              spacing: 8,
                              children: (match['missingIngredients'] as List)
                                  .map((ing) => Chip(
                                        label: Text(ing),
                                        backgroundColor: Colors.grey[200],
                                        avatar: const Icon(
                                          Icons.close,
                                          size: 16,
                                          color: Colors.red,
                                        ),
                                      ))
                                  .toList(),
                            ),
                          ],
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Icon(Icons.access_time,
                                  size: 16, color: Colors.grey[600]),
                              const SizedBox(width: 4),
                              Text(
                                '${recipe.cookingTime} menit',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                              const SizedBox(width: 16),
                              Icon(Icons.fitness_center,
                                  size: 16, color: Colors.grey[600]),
                              const SizedBox(width: 4),
                              Text(
                                recipe.difficulty,
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
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
