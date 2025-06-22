import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../views/screens/login_sigup_screen/login.dart';
import '../views/screens/login_sigup_screen/sign_up.dart';
import '../views/screens/main_screens.dart';

class AuthenticationController {
  static final supabase = Supabase.instance.client;
  // static Timer? _emailCheckTimer;
  //
  // static void _waitForEmailConfirmation(BuildContext context) {
  //   showEmailConfirmationDialog(context); // hiển thị dialog chờ
  //
  //   _emailCheckTimer = Timer.periodic(const Duration(seconds: 3), (timer) async {
  //     try {
  //       // Gọi refresh để lấy thông tin mới nhất nếu user đăng nhập
  //       await supabase.auth.refreshSession();
  //       final userResponse = await supabase.auth.getUser();
  //       final user = userResponse.user;
  //
  //       print("✅ Kiểm tra emailConfirmedAt: ${user?.emailConfirmedAt}");
  //
  //       if (user != null && user.emailConfirmedAt != null) {
  //         print("✅ Email đã được xác nhận!");
  //
  //         timer.cancel();
  //         _emailCheckTimer = null;
  //
  //         if (context.mounted) {
  //           Navigator.of(context, rootNavigator: true).pop(); // đóng dialog
  //         }
  //
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           const SnackBar(
  //             content: Text("Email đã được xác nhận!"),
  //             backgroundColor: Colors.green,
  //           ),
  //         );
  //
  //         Navigator.pushReplacement(
  //           context,
  //           MaterialPageRoute(builder: (_) => const LoginScreen()),
  //         );
  //       }
  //     } catch (e) {
  //       print("❌ Lỗi khi kiểm tra xác nhận email: $e");
  //     }
  //   });
  // }



  static Future<void> signUp({
    required BuildContext context,
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      final response = await supabase.auth.signUp(
        email: email,
        password: password,
      );

      final user = response.user;
      final session = response.session;

      if (user != null) {
        final userId = user.id;

        // Thêm vào bảng users (nếu cần)
        await supabase.from('users').insert({
          'user_id': userId,
          'firstname': username,
          'email': email,
          'created_at': DateTime.now().toIso8601String(),
        });

        ScaffoldMessenger.of(context).showSnackBar(

          const SnackBar(content: Text("Đăng ký thành công! Vui lòng xác nhận email.")),
        );

        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(builder: (context) => const LoginScreen()),
        // );
        context.go('/login');

      }
    } catch (e) {
      print("❌ Lỗi đăng ký: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Đăng ký thất bại. Vui lòng thử lại.")),
      );
    }
  }

  static Future<void> logIn({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.session != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Đăng nhập thành công!"),
            backgroundColor: Colors.green,
          ),
        );

        // Chuyển hướng người dùng sau đăng nhập (VD: vào màn hình chính)
        // Navigator.pushReplacement(
        //     context,
        //     MaterialPageRoute(builder: (context) => MainScreen()));
        context.go('/home');

      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Đăng nhập thất bại!"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print("❌ Lỗi đăng nhập: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Lỗi đăng nhập. Vui lòng thử lại."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
Future<String?> getCurrentUserName() async {
  final userId = Supabase.instance.client.auth.currentUser?.id;
  if (userId == null) return null;

  final result = await Supabase.instance.client
      .from('users')
      .select('firstname')
      .eq('user_id', userId)
      .maybeSingle();

  return result != null ? result['firstname'] as String? : null;
}
