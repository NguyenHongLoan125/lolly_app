
import 'package:supabase_flutter/supabase_flutter.dart';

class Ingredient {
  final String id;
  final String name;
  final String quantity;
  final String dishId;

  Ingredient({
    required this.id,
    required this.name,
    required this.quantity,
    required this.dishId,
  });

  factory Ingredient.fromMap(Map<String, dynamic> map) {
    return Ingredient(
      id: map['ingredient_id'],
      name: map['ingredients']['ingredient_name'],
      quantity: map['quantity'],
      dishId: map['dish_id'] ?? '',
    );
  }

}
Future<List<Ingredient>> fetchIngredientsByDish(String dishId) async {
  try {
    final response = await Supabase.instance.client
        .from('dish_ingredients')
        .select('ingredient_id, quantity, dish_id, ingredients (ingredient_name)')
        .eq('dish_id', dishId);

    return (response as List)
        .map((e) => Ingredient.fromMap(e))
        .toList();

  } catch (e, stack) {
    print('Lỗi khi fetchIngredientsByDish: $e');
    print(stack);
    return [];
  }

}

Future<List<Ingredient>> fetchIngredientsByDate(DateTime date) async {
  final userId = Supabase.instance.client.auth.currentUser?.id;

  if (userId == null) {
    print('Không tìm thấy userId. Có thể chưa đăng nhập.');
    return [];
  }

  try {
    // 1. Lấy dishId theo ngày
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final dailyMenuResponse = await Supabase.instance.client
        .from('menus')
        .select('dishId')
        .gte('menu_date', startOfDay.toIso8601String())
        .lt('menu_date', endOfDay.toIso8601String())
        .eq('userId', userId);
    // print('menu data: $dailyMenuResponse');

    final dailyMenuList = List<Map<String, dynamic>>.from(dailyMenuResponse);
    final dishIds = dailyMenuList.map((e) => e['dishId'] as String).toList();

    if (dishIds.isEmpty) return [];

    // 2. Lấy tất cả nguyên liệu liên quan đến các dishId
    List<Ingredient> rawIngredients = [];

    for (final dishId in dishIds) {
      final response = await Supabase.instance.client
          .from('dish_ingredients')
          .select('ingredient_id, quantity, dish_id, ingredients (ingredient_name)')
          .eq('dish_id', dishId);

      rawIngredients.addAll(
        (response as List).map((e) => Ingredient.fromMap(e)).toList(),
      );
    }

    // 3. Gộp các nguyên liệu giống nhau
    Map<String, Map<String, double>> grouped = {};

    for (final ing in rawIngredients) {
      final quantity = ing.quantity.trim();

      // Regex bắt dạng "20-25 cái" hoặc "20 cái"
      final RegExp reg = RegExp(r'^(\d+(?:\.\d+)?)(?:-(\d+(?:\.\d+)?))?\s*(.*)$');
      final match = reg.firstMatch(quantity);

      if (match == null) {
        // Không match regex => giữ nguyên
        grouped[ing.name] ??= {};
        grouped[ing.name]![quantity] = (grouped[ing.name]![quantity] ?? 0) + 1;
        continue;
      }

      double value;

      if (match.group(2) != null) {
        // Là khoảng, lấy trung bình
        final start = double.tryParse(match.group(1)!) ?? 0;
        final end = double.tryParse(match.group(2)!) ?? 0;
        value = (start + end) / 2;
      } else {
        // Là số đơn
        value = double.tryParse(match.group(1)!) ?? 0;
      }

      final String unit = match.group(3)!.trim();

      grouped[ing.name] ??= {};
      grouped[ing.name]![unit] = (grouped[ing.name]![unit] ?? 0) + value;
    }


    // 4. Trả về danh sách đã gộp
    List<Ingredient> merged = [];

    for (final entry in grouped.entries) {
      final name = entry.key;
      final units = entry.value;

      for (final u in units.entries) {
        final unit = u.key;
        final value = u.value;
        merged.add(Ingredient(
          id: '',
          name: name,
          quantity: '${value.toStringAsFixed(0)} $unit',
          dishId: '',
        ));
      }
    }

    return merged;
  } catch (e) {
    print('Lỗi khi fetch nguyên liệu theo ngày: $e');
    return [];
  }
}
Future<Map<String, bool>> fetchCheckedStatusByDate(DateTime date) async {
  final user = Supabase.instance.client.auth.currentUser;
  if (user == null) return {};

  final dateStr = date.toIso8601String().substring(0, 10);

  try {
    final response = await Supabase.instance.client
        .from('checked_ingredients')
        .select()
        .eq('user_id', user.id)
        .eq('date', dateStr);

    final Map<String, bool> newStatus = {};
    for (final item in response) {
      final name = item['ingredient_name'];
      final isChecked = item['is_checked'] ?? false;
      newStatus['${name}_$dateStr'] = isChecked;
    }
    return newStatus;
  } catch (e) {
    print('Lỗi khi tải trạng thái check: $e');
    return {};
  }
}
Future<void> saveCheckedStatusToDb({
  required String userId,
  required String ingredientName,
  required bool isChecked,
  required String dateStr,
}) async {
  final client = Supabase.instance.client;

  if (isChecked) {
    await client
        .from('checked_ingredients')
        .upsert({
      'user_id': userId,
      'ingredient_name': ingredientName,
      'is_checked': true,
      'date': dateStr,
    },
        onConflict: 'user_id, ingredient_name, date');
  } else {
    await client
        .from('checked_ingredients')
        .delete()
        .eq('user_id', userId)
        .eq('ingredient_name', ingredientName)
        .eq('date', dateStr);
  }
}


