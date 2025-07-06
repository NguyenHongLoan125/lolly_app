import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/detail_dish_model.dart';

class DishDetailController {
  final _client = Supabase.instance.client;

  Future<DetailDishModel?> getDishDetail(String dishId) async {
    try {
      // Lấy thông tin người dùng hiện tại
      final currentUserId = _client.auth.currentUser?.id;

      // Query món ăn
      final dishData = await _client
          .from('dishes')
          .select('''
      id,
      dish_name,
      image_url,
      user_id,
      cook,
      notes,
      dish_ingredients (
        quantity,
        ingredients ( ingredient_name )
      ),
      dish_sub_categories (
        sub_categories (
          sub_category_name,
          categories ( category_name )
        )
      )
    ''')
          .eq('id', dishId)
          .maybeSingle();

      if (dishData == null) return null;

      final authorId = dishData['user_id'];

      if (authorId == currentUserId) {
        // Nếu là người đăng bài
        dishData['users'] = {'firstname': 'Tôi', 'lastname': ''};
      } else {
        // Lấy tên tác giả
        final userData = await _client
            .from('users')
            .select('firstname, lastname')
            .eq('user_id', authorId) // ✅ sửa đúng cột
            .maybeSingle();

        dishData['users'] = userData;
      }


      return DetailDishModel.fromMap(dishData);
    } catch (e) {
      print('❌ LỖI LẤY CHI TIẾT MÓN ĂN: $e');
      return null;
    }
  }

}
