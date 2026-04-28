class Recipe {
  final String id;
  final String name;
  final List<String> ingredients;
  final List<String> steps;
  final String imageUrl;
  final int cookingTime;
  final String difficulty;

  Recipe({
    required this.id,
    required this.name,
    required this.ingredients,
    required this.steps,
    this.imageUrl = '',
    required this.cookingTime,
    required this.difficulty,
  });
}
