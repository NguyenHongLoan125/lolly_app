import 'package:lolly_app/models/dishes_model.dart';

class DetailDishModel {
  final String? dishName;
  final String? author;
  final String? imageUrl;

  // Các thông tin phụ (lấy từ sub_categories qua dish_sub_categories)
  final String? time;
  final String? difficulty;
  final int? ration;

  // Danh sách nguyên liệu
  final List<Ingredient>? ingredients;

  // Cách chế biến (cook) và lưu ý
  final String? cook;
  final String? notes;

  DetailDishModel({
    required this.dishName,
    required this.author,
    required this.imageUrl,
    required this.ingredients,
    required this.cook,
    this.time,
    this.difficulty,
    this.ration,
    this.notes,
  });

  factory DetailDishModel.fromMap(Map<String, dynamic> map) {
    final subCategory = map['dish_sub_categories']?[0]?['sub_categories'];
    final ingredientList = (map['dish_ingredient'] as List?)?.map((item) {
      final name = item['ingredients']['name'];
      final amount = item['amount'] ?? '';
      final unit = item['unit'] ?? '';
      return Ingredient(
        name: name,
        quantity: '$amount $unit'.trim(),
      );
    }).toList();

    return DetailDishModel(
      dishName: map['dish_name'],
      author: map['user_name'],
      imageUrl: map['image_url'],
      cook: map['cook'],
      notes: map['notes'],
      time: subCategory?['time'],
      difficulty: subCategory?['difficulty'],
      ration: subCategory?['people'],
      ingredients: ingredientList,
    );
  }

}
