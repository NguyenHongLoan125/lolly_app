import 'ingredient_model.dart';

class DishModel {
  final String id;
  final String name;
  final String imageUrl;
  final int likes;
  final String user_id;
  final List<Ingredient> ingredients;

  DishModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.likes,
    required this.user_id,
    this.ingredients = const [],
  });

  factory DishModel.fromMap(Map<String, dynamic> map) {
    final data = map['dishes'] ?? map; // handle JOIN case

    return DishModel(
      id: data['id'] ?? '',
      name: data['dish_name'] ?? 'Không có tên',
      imageUrl: data['image_url'] ?? '',
      likes: int.tryParse(data['likes']?.toString() ?? '0') ?? 0,
      user_id: data['user_id'] ?? '',
      ingredients: (data['dish_ingredients'] as List<dynamic>?)
          ?.map((e) => Ingredient.fromMap(e))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'dish_name': name,
      'image_url': imageUrl,
      'likes': likes,
      'user_id': user_id,
    };
  }
  @override
  String toString() {
    return 'DishModel{id: $id, name: $name, imageUrl: $imageUrl, likes: $likes, user_id: $user_id, ingredients: $ingredients}';
  }

}
