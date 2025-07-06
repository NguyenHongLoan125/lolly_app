

import 'package:lolly_app/models/dishes_model.dart';


class DetailDishModel {
  final String? dishName;
  final String? imageUrl;
  final String? cook;
  final String? notes;
  final String? author;
  final String? time;
  final String? difficulty;
  final int? people;
  final List<Ingredient>? ingredients;

  // ✅ Các nhóm bổ sung
  final List<String>? types; // Loại món
  final List<String>? styles; // Phong cách ẩm thực
  final List<String>? diets; // Chế độ ăn

  DetailDishModel({
    this.dishName,
    this.imageUrl,
    this.cook,
    this.notes,
    this.author,
    this.time,
    this.difficulty,
    this.people,
    this.ingredients,
    this.types,
    this.styles,
    this.diets,
  });

  factory DetailDishModel.fromMap(Map<String, dynamic> map) {
    // Xử lý tên tác giả
    final userMap = map['users'];
    print('📦 userMap = $userMap');
    String? authorName;
    if (userMap != null) {
      final first = userMap['firstname'] ?? '';
      final last = userMap['lastname'] ?? '';
      authorName = '$first $last';
    }

    // Xử lý time, difficulty, people và nhóm mới
    final List<dynamic> subCategoriesList = map['dish_sub_categories'] ?? [];
    String? time, difficulty;
    int? people;
    List<String> types = [];
    List<String> styles = [];
    List<String> diets = [];

    for (final sub in subCategoriesList) {
      final subCat = sub['sub_categories'];
      final cat = subCat?['categories'];
      final catName = cat?['category_name'];
      final subName = subCat?['sub_category_name'];

      if (catName == 'Thời gian nấu') {
        time = subName;
      } else if (catName == 'Độ khó') {
        difficulty = subName;
      } else if (catName == 'Khẩu phần') {
        final match = RegExp(r'\d+').firstMatch(subName ?? '');
        if (match != null) people = int.tryParse(match.group(0)!);
      } else if (catName == 'Loại món') {
        types.add(subName ?? '');
      } else if (catName == 'Phong cách ẩm thực') {
        styles.add(subName ?? '');
      } else if (catName == 'Chế độ ăn') {
        diets.add(subName ?? '');
      }
    }

    return DetailDishModel(
      dishName: map['dish_name'],
      imageUrl: map['image_url'],
      cook: map['cook'],
      notes: map['notes'],
      author: authorName,
      time: time,
      difficulty: difficulty,
      people: people,
      types: types,
      styles: styles,
      diets: diets,
      ingredients: (map['dish_ingredients'] as List<dynamic>?)
          ?.map((e) => Ingredient.fromMap(e))
          .toList(),
    );
  }
}

