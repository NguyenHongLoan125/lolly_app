class Ingredient {
  final String? ingredientId;
  final String? ingredientName;
  final String? ingredientQuantity;
  final String? dishId;

  Ingredient({
    this.ingredientId,
    this.ingredientName,
    this.ingredientQuantity,
    this.dishId,
  });

  factory Ingredient.fromMap(Map<String, dynamic> map) {
    return Ingredient(
      ingredientId: map['ingredient_id'],
      ingredientName: map['ingredients']['ingredient_name'],
      ingredientQuantity: map['quantity'],
      dishId: map['dish_id'] ?? '',
    );
  }
}

class DishModel {
  final String? id;
  final String? dishName;
  final String? imageUrl;
  final String? cook;
  final String? notes;
  final String? author;
  final String? time;
  final String? difficulty;
  final int? people;
  final int ? likes;
  final List<Ingredient>? ingredients;
  final DateTime? createdAt;

  // ✅ Các nhóm bổ sung
  final List<String>? types;
  final List<String>? styles;
  final List<String>? diets;

  DishModel({
    this.id,
    this.dishName,
    this.imageUrl,
    this.cook,
    this.notes,
    this.author,
    this.time,
    this.difficulty,
    this.people,
    this.likes,
    this.ingredients,
    this.types,
    this.styles,
    this.diets,
    this.createdAt,
  });

  factory DishModel.fromMap(Map<String, dynamic> map) {
    final userMap = map['users'];
    String? authorName;
    if (userMap != null) {
      final first = userMap['firstname'] ?? '';
      final last = userMap['lastname'] ?? '';
      authorName = '$first $last';
    }

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

    return DishModel(
      id: map['id'],
      dishName: map['dish_name'],
      imageUrl: map['image_url'],
      cook: map['cook'],
      notes: map['notes'],
      author: authorName,
      time: time,
      difficulty: difficulty,
      people: people,
      likes: map['likes'],
      types: types.isEmpty ? null : types,
      styles: styles.isEmpty ? null : styles,
      diets: diets.isEmpty ? null : diets,
      createdAt: map['created_at'] != null ? DateTime.tryParse(map['created_at']) : null,
      ingredients: (map['dish_ingredients'] as List<dynamic>?)
          ?.map((e) => Ingredient.fromMap(e))
          .toList(),
    );
  }
}
