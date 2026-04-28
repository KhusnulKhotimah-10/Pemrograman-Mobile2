import '../models/recipe_model.dart';

class RecipeMatcher {
  static List<Map<String, dynamic>> matchRecipes(
    List<Recipe> recipes,
    List<String> userIngredients,
  ) {
    List<Map<String, dynamic>> matchedRecipes = [];

    for (var recipe in recipes) {
      int matchCount = 0;
      List<String> missingIngredients = [];
      List<String> matchedIngredients = [];

      for (var ingredient in recipe.ingredients) {
        if (userIngredients.any((userIng) =>
            userIng.toLowerCase().contains(ingredient.toLowerCase()) ||
            ingredient.toLowerCase().contains(userIng.toLowerCase()))) {
          matchCount++;
          matchedIngredients.add(ingredient);
        } else {
          missingIngredients.add(ingredient);
        }
      }

      double matchPercentage = (matchCount / recipe.ingredients.length) * 100;

      matchedRecipes.add({
        'recipe': recipe,
        'matchCount': matchCount,
        'totalIngredients': recipe.ingredients.length,
        'matchPercentage': matchPercentage,
        'missingIngredients': missingIngredients,
        'matchedIngredients': matchedIngredients,
      });
    }

    // Sort by match percentage (highest first)
    matchedRecipes.sort((a, b) => b['matchPercentage'].compareTo(a['matchPercentage']));

    return matchedRecipes;
  }
}
