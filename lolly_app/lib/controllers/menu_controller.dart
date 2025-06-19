import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> addToMenu({
  required BuildContext context,
  required String dishId,
  required String userId,
}) async {
  try {
    debugPrint('🧪 Adding dish: $dishId for user: $userId');

    final result = await Supabase.instance.client
        .from('menus')
        .insert({
      'userId': userId,
      'dishId': dishId,
      'created_at': DateTime.now().toIso8601String(),
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã thêm vào menu!')),
    );
  } catch (e, s) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã xảy ra lỗi khi thêm món.')),
    );
  }
}
Future<void> deleteToMenu({
  required BuildContext context,
  required String dishId,
  required String userId,
  required DateTime createdAt,
}) async {
  try {
    final response = await Supabase.instance.client
        .from('menus')
        .delete()
        .eq('dishId', dishId)
        .eq('userId', userId)
        .eq('created_at', createdAt.toIso8601String()) // phải đúng định dạng ISO!
        .select();

    print('Delete response: $response');

    if (response != null && response.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã xóa khỏi thực đơn!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không tìm thấy món ăn để xóa.')),
      );
    }
  } catch (error) {
    print('Lỗi khi xóa: $error');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Lỗi: $error')),
    );
  }
}