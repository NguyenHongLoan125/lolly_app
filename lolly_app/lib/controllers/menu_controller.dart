// import 'package:flutter/material.dart';
// import 'package:lolly_app/models/ingredient_model.dart';
// import 'package:lolly_app/views/screens/nav_screens/shopping_screen.dart';
// import 'package:lolly_app/views/screens/nav_screens/widgets/custom_snackbar.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
//
// Future<void> addToMenu({
//   required BuildContext context,
//   required String dishId,
//   required String userId,
//   required DateTime menuDate, // ✅ thêm ngày người dùng chọn
// }) async {
//   try {
//     await Supabase.instance.client.from('menus').insert({
//       'userId': userId,
//       'dishId': dishId,
//       'menu_date': menuDate.toIso8601String(), // dùng ngày người dùng chọn
//       'created_at': DateTime.now().toIso8601String(),
//     });
//
//     showCustomSnackbar(context, 'Đã thêm vào menu!');
//
//   } catch (e) {
//     showCustomSnackbar(context, 'Đã xảy ra lỗi khi thêm món');
//
//   }
// }
//
// // Future<void> deleteToMenu({
// //   required BuildContext context,
// //   required String dishId,
// //   required String userId,
// //   required DateTime createdAt,
// // }) async {
// //   try {
// //     final response = await Supabase.instance.client
// //         .from('menus')
// //         .delete()
// //         .eq('dishId', dishId)
// //         .eq('userId', userId)
// //         .eq('created_at', createdAt.toIso8601String()) // phải đúng định dạng ISO!
// //         .select();
// //
// //     print('Delete response: $response');
// //
// //     if (response != null && response.isNotEmpty) {
// //       showCustomSnackbar(context, 'Đã xóa khỏi thực đơn!');
// //     } else {
// //       showCustomSnackbar(context, 'Không tìm thấy món ăn để xóa.');
// //     }
// //
// //   } catch (error) {
// //     print('Lỗi khi xóa: $error');
// //     ScaffoldMessenger.of(context).showSnackBar(
// //       SnackBar(content: Text('Lỗi: $error')),
// //     );
// //   }
// // }
// Future<void> deleteToMenu({
//   required BuildContext context,
//   required String dishId,
//   required String userId,
//   required DateTime createdAt,
// }) async {
//   try {
//     // // 1. Fetch nguyên liệu trước khi xóa món
//     // final ingredients = await fetchIngredientsByDish(dishId);
//     //
//     // // 2. Xóa checked status của các nguyên liệu đó
//     // final prefs = await SharedPreferences.getInstance();
//     // final dateStr = createdAt.toIso8601String().substring(0, 10);
//     //
//     // for (final ing in ingredients) {
//     //   final key = '${ing.name}_$dateStr';
//     //   final existed = prefs.containsKey(key);
//     //   await prefs.remove(key);
//     //   print('Removed key: $key - existed before delete? $existed');
//     // }
//     await deleteCheckedStatusForDish(
//       dishId: dishId,
//       date: createdAt,
//     );
//
//     // 3. Tiếp tục xóa món khỏi menu
//     final response = await Supabase.instance.client
//         .from('menus')
//         .delete()
//         .eq('dishId', dishId)
//         .eq('userId', userId)
//         .eq('created_at', createdAt.toIso8601String())
//         .select();
//
//     print('Delete response: $response');
//
//     if (response != null && response.isNotEmpty) {
//       showCustomSnackbar(context, 'Đã xóa khỏi thực đơn!');
//     } else {
//       showCustomSnackbar(context, 'Không tìm thấy món ăn để xóa.');
//     }
//
//   } catch (error) {
//     print('Lỗi khi xóa: $error');
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Lỗi: $error')),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:lolly_app/models/ingredient_model.dart';
import 'package:lolly_app/views/screens/nav_screens/widgets/custom_snackbar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> addToMenu({
  required BuildContext context,
  required String dishId,
  required String userId,
  required DateTime menuDate, // ✅ thêm ngày người dùng chọn
}) async {
  try {
    await Supabase.instance.client.from('menus').insert({
      'userId': userId,
      'dishId': dishId,
      'menu_date': menuDate.toIso8601String(),
      'created_at': DateTime.now().toIso8601String(),
    });

    showCustomSnackbar(context, 'Đã thêm vào menu!');
  } catch (e) {
    showCustomSnackbar(context, 'Đã xảy ra lỗi khi thêm món');
  }
}

Future<void> deleteToMenu({
  required BuildContext context,
  required String dishId,
  required String userId,
  required DateTime createdAt,
  required DateTime menuDate, // ✅ thêm menuDate
}) async {
  try {
    // ✅ Xóa checked status dùng menuDate (ngày thực đơn)
    await deleteCheckedStatusForDish(
      dishId: dishId,
      date: menuDate,
    );

    // ✅ Tiếp tục xóa món khỏi menu
    final response = await Supabase.instance.client
        .from('menus')
        .delete()
        .eq('dishId', dishId)
        .eq('userId', userId)
        .eq('created_at', createdAt.toIso8601String())
        .select();

    print('Delete response: $response');

    if (response != null && response.isNotEmpty) {
      showCustomSnackbar(context, 'Đã xóa khỏi thực đơn!');
    } else {
      showCustomSnackbar(context, 'Không tìm thấy món ăn để xóa.');
    }

  } catch (error) {
    print('Lỗi khi xóa: $error');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Lỗi: $error')),
    );
  }
}
