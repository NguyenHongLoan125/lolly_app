import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> addToMenu({
  required BuildContext context,
  required String dishId,
  // required String userId,

}) async {
  try {
    final response = await Supabase.instance.client
        .from('menus')
        .insert(
        {'dishId': dishId,
          //'user_id': userId,
        });

    if (response == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã thêm vào thực đơn!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lỗi khi thêm vào thực đơn.')),
      );
    }
  } catch (error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Lỗi: $error')),
    );
  }
}
