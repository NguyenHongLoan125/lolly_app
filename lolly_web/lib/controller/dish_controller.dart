import 'package:lolly_web/models/dish_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DishController {
  final _client = Supabase.instance.client;

  Future<List<DishModel>> fetchAllDishes() async {
    try {
      final response = await _client
          .from('dishes')
          .select('''
        id,
        dish_name,
        created_at,
        image_url,
        user_id,
        cook,
        notes,
        users (
          firstname,
          lastname
        ),
        dish_ingredients (
          quantity,
          ingredients (
            ingredient_name
          )
        ),
        dish_sub_categories (
          sub_categories (
            sub_category_name,
            categories (
              category_name
            )
          )
        )
      ''');

      return (response as List)
          .map((dish) => DishModel.fromMap(dish))
          .toList();
    } catch (e) {
      print('❌ Lỗi lấy danh sách món ăn: $e');
      return [];
    }
  }

  Future<DishModel?> fetchDishById(String dishId) async {
    try {
      final dishData = await _client
          .from('dishes')
          .select('''
        id,
        dish_name,
        created_at,
        image_url,
        user_id,
        cook,
        notes,
        dish_ingredients (
          quantity,
          ingredients (
            ingredient_name
          )
        ),
        dish_sub_categories (
          sub_categories (
            sub_category_name,
            categories (
              category_name
            )
          )
        )
      ''')
          .eq('id', dishId)
          .maybeSingle();

      if (dishData == null) return null;

      final authorId = dishData['user_id'];

      final userData = await _client
          .from('users')
          .select('firstname, lastname')
          .eq('user_id', authorId)
          .maybeSingle();

      dishData['users'] = userData;

      return DishModel.fromMap(dishData);
    } catch (e) {
      print('❌ LỖI LẤY CHI TIẾT MÓN ĂN: $e');
      return null;
    }
  }

  Future<bool> deleteDish(String dishId) async {
    try {
      await _client.from('dishes').delete().eq('id', dishId);
      return true;
    } catch (e) {
      print('❌ Lỗi xóa món: $e');
      return false;
    }
  }

}
