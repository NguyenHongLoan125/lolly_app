class Ingredient {
  final String name;
  final String quantity;

  Ingredient({required this.name, required this.quantity});

  factory Ingredient.fromMap(Map<String, dynamic> map) {
    return Ingredient(
      name: map['ingredients']?['ingredient_name'] ?? '',
      quantity: map['quantity'] ?? '',
    );
  }
}

class RecipeModel {
  String? imageUrl;
  String title;

  List<Ingredient> ingredients;
  String instructions;
  String notes;
  List<int> subCategory;

  RecipeModel({
    this.imageUrl,
    required this.title,
    required this.ingredients,
    required this.instructions,
    required this.notes,
    required this.subCategory,
  });
}


