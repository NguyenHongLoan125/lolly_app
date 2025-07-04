import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/detail_dish_model.dart';

class DishDetailController {
  final _client = Supabase.instance.client;

  Future<DetailDishModel?> getDishDetail(String dishId) async {
    final data = await _client
        .from('dishes')
        .select('''
          dish_name,
          user_name,
          image_url,
          cook,
          notes,
          dish_sub_categories (
            sub_categories (
              time,
              difficulty,
              people
            )
          ),
          dish_ingredient (
            amount,
            unit,
            ingredients ( name )
          )
        ''')
        .eq('id', dishId)
        .maybeSingle();

    if (data == null) return null;
    return DetailDishModel.fromMap(data);
  }
}
