import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../view/main_screen.dart';
import '../view/screens/login_screen/login_screen.dart';


class AuthenticationController {
  static final supabase = Supabase.instance.client;

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

        // Lưu thông tin vào bảng admin
        await supabase.from('admin').insert({
          'admin_id': userId,
          'username': username,
          'email': email,
          'created_at': DateTime.now().toIso8601String(),
        });

        if (session != null) {
          // Nếu có session (tức đã login luôn sau khi sign up)
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Đăng ký thành công!")),
          );

          // Chuyển đến trang admin chính
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const MainScreen()),
          );
        } else {
          // Nếu chưa có session, có thể yêu cầu xác thực email
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Vui lòng xác nhận email để hoàn tất đăng ký.")),
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const LoginScreen()),
          );
        }
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


        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MainScreen()));

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
      .from('admin')
      .select('username')
      .eq('admin_id', userId)
      .maybeSingle();

  return result != null ? result['username'] as String? : null;
}
