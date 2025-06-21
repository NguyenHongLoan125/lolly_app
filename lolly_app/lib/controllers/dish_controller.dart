import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DishController extends GetxController {
  final SupabaseClient _supabase = Supabase.instance.client;
  Stream<List<Map<String, dynamic>>> getPopularDishes() {
    return _supabase
        .from('dishes')
        .select('*, dish_sub_categories(categories, sub_categories(sub_category_name))')
        .order('created_at', ascending: false)
        .asStream()
        .handleError((error, stackTrace) {
      print('>>> LỖI TRONG STREAM SUPABASE (DishController): $error');
      print('>>> STACK TRACE: $stackTrace');
    });
  }

  Stream<List<Map<String, dynamic>>> getDishesStream() {
    return _supabase
        .from('dishes')
        .select('*, dish_sub_categories(categories, sub_categories(*, categories(id, category_name)))')
        .order('created_at', ascending: false)
        .asStream();
  }
  /// Stream danh sách các món ăn phổ biến (mới nhất)
  Stream<List<Map<String, dynamic>>> getPopularDishesStream() {
    return _supabase
        .from('dishes')
        .select('*, dish_sub_categories(categories, sub_categories(sub_category_name))')
        .order('created_at', ascending: false)
        .asStream()
        .handleError((error, stackTrace) {
      print('>>> LỖI TRONG DISH CONTROLLER: $error');
      print('>>> STACK TRACE: $stackTrace');
    });
  }
  Stream<List<Map<String, dynamic>>> getDishesFromMenusByDate(DateTime date) {
    final String formattedDate = date.toIso8601String().split('T').first; // yyyy-MM-dd

    return _supabase
        .from('menus')
        .select('''
        id,
        menu_date,
        created_at,
        userId,
        dishId,
        dishes (
          *,
          dish_sub_categories (
            categories,
            sub_categories (
              *,
              categories (
                id,
                category_name
              )
            )
          )
        )
      ''')
        .eq('menu_date', formattedDate) // ✅ dùng menu_date để lọc
        .order('created_at', ascending: false)
        .asStream();
  }

  Future<List<String>> fetchSubCategories(String categoryName) async {
    final List<Map<String, dynamic>> data = await _supabase
        .from('sub_categories')
        .select('sub_category_name, categories!inner(category_name)')
        .eq('categories.category_name', categoryName);

    return data.map((e) => e['sub_category_name'] as String).toList();
  }


  List<Map<String, dynamic>> filterDishesByCategory({
    required List<Map<String, dynamic>> allDishes,
    required String categoryName,
    String? subCategoryName,
  }) {
    return allDishes.where((dish) {
      final dishSubCategories = dish['dish_sub_categories'];
      if (dishSubCategories == null || dishSubCategories.isEmpty) return false;

      for (final dishSubCategory in dishSubCategories) {
        final subCategory = dishSubCategory['sub_categories'];
        if (subCategory == null) continue;

        final category = subCategory['categories'];
        if (category == null) continue;

        final cName = category['category_name'];
        final scName = subCategory['sub_category_name'];

        if (cName == categoryName) {
          if (subCategoryName != null) {
            if (scName == subCategoryName) return true;
          } else {
            return true;
          }
        }
      }

      return false;
    }).toList();
  }
}
