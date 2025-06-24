class DishModel {
  final String id;
  final String name;
  final String ingredient;
  final String imageUrl;
  final int likes;
  final String user_id;

  DishModel({
    required this.id,
    required this.name,
    required this.ingredient,
    required this.imageUrl,
    required this.likes,
    required this.user_id,
  });

  factory DishModel.fromMap(Map<String, dynamic> map) {
    final data = map['dishes'] ?? map; // handle JOIN data
    return DishModel(
      id: data['id'] ?? '',
      name: data['dish_name'] ?? 'Không có tên',
      ingredient: data['ingredient'] ?? '',
      imageUrl: data['image_url'] ?? '',
      likes: int.tryParse(data['likes']?.toString() ?? '0') ?? 0,
      user_id: data['user_id']?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'dish_name': name,
      'ingredient': ingredient,
      'image_url': imageUrl,
      'likes': likes,
      'user_id': user_id,
    };
  }
}
