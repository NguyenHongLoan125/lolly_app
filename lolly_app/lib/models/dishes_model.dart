class Ingredient {
  final String name;
  final String quantity;

  Ingredient({required this.name, required this.quantity});
}

class RecipeModel {
  String? imageUrl;
  String title;
  String cookTime;
  String difficulty;
  String servings;
  List<Ingredient> ingredients;
  String instructions;
  String notes;
  final String? cuisineType;
  final String? dishType;
  final String? dietaryType;

  RecipeModel({
    this.imageUrl,
    required this.title,
    required this.cookTime,
    required this.difficulty,
    required this.servings,
    required this.ingredients,
    required this.instructions,
    required this.notes,
    this.cuisineType,
    this.dishType,
    this.dietaryType
  });
}


