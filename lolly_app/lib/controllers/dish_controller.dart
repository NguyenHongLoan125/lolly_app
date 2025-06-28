import 'package:get/get.dart';
import 'package:lolly_app/models/dish_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/ingredient_model.dart';

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
  Stream<List<Map<String, dynamic>>> getFavoriteDishesStream() {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      print('>>> currentUser bị null');
      return Stream.value([]);
    }

    final userId = user.id;
    print('>>> USER ID: $userId');

    return Supabase.instance.client
        .from('favorites')
        .select('dish_id, dishes(*, dish_sub_categories(categories, sub_categories(sub_category_name)))')
        .eq('user_id', userId)
        .order('created_at', ascending: false)
        .asStream()
        .handleError((error, stackTrace) {
      print('>>> LỖI TRONG FAVORITES CONTROLLER: $error');
      print('>>> STACK TRACE: $stackTrace');
    });
  }

  Stream<List<Map<String, dynamic>>> getMyDishesStream() {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      print('>>> currentUser bị null');
      return Stream.value([]);
    }

    final userId = user.id;
    print('>>> USER ID: $userId');

    return Supabase.instance.client
        .from('dishes')
        .select('*, dish_sub_categories(categories, sub_categories(sub_category_name))')
        .eq('user_id', userId)
        .order('created_at', ascending: false)
        .asStream()
        .handleError((error, stackTrace) {
      print('>>> LỖI TRONG getMyDishesStream: $error');
      print('>>> STACK TRACE: $stackTrace');
    });
  }

  Stream<List<Map<String, dynamic>>> getDishesFromMenusByDate(DateTime date) {
    final start = DateTime.utc(date.year, date.month, date.day);
    final end = start.add(const Duration(days: 1));

    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) {
      print('Chưa đăng nhập');
      return const Stream.empty();
    }

    return Supabase.instance.client
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
        .eq('userId', userId)
        .gte('menu_date', start.toIso8601String()) // từ đầu ngày
        .lt('menu_date', end.toIso8601String())    // trước ngày hôm sau
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
  Future<bool> isLikedByUser(String userId, String dishId) async {
    final response = await _supabase
        .from('favorites')
        .select('id')
        .eq('user_id', userId)
        .eq('dish_id', dishId)
        .maybeSingle();
    return response != null;
  }

  Future<void> likeDish(String userId, DishModel dish) async {
    await _supabase.from('favorites').insert({
      'user_id': userId,
      'dish_id': dish.id,
    });

    await _supabase
        .from('dishes')
        .update({'likes': dish.likes + 1})
        .eq('id', dish.id);
  }

  Future<void> unlikeDish(String userId, DishModel dish) async {
    await _supabase
        .from('favorites')
        .delete()
        .eq('user_id', userId)
        .eq('dish_id', dish.id);

    final result = await _supabase
        .from('dishes')
        .select('likes')
        .eq('id', dish.id)
        .single();

    final currentLikes = (result['likes'] ?? 0) as int;

    await _supabase
        .from('dishes')
        .update({'likes': currentLikes > 0 ? currentLikes - 1 : 0})
        .eq('id', dish.id);

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