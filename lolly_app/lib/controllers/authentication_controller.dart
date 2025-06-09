import 'package:lolly_app/views/screens/login_sigup_screen/login.dart';
import 'package:lolly_app/views/screens/login_sigup_screen/sign_up.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';

import '../views/screens/main_screens.dart';


class AuthenticationController{
  static final supabase= Supabase.instance.client;

  static Future<void> signUp({
    required BuildContext context,
    required String email,
    required String password,
    required String username,

  })
  async {
    try {
      final response = await supabase.auth.signUp(
          email: email,
          password: password,
        // data: {
        //   'firstname': username,
        // },
      );

      if (response.user != null) {
        final userId = response.user!.id;

        // Thêm user vào bảng `users`
        await supabase.from('users').insert({
          'user_id': userId,
          'firstname': username,
          'email': email,
          'created_at': DateTime.now().toIso8601String(),
        });

        print("Đăng ký và lưu dữ liệu thành công!");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Đăng ký thành công!")),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );

      }
    }
    catch (e) {
      print("Lỗi đăng ký: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Đăng ký thất bại! Vui lòng kiểm tra lại.")),
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
        print("Đăng nhập thành công!");

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Đăng nhập thành công!")),
        );

        // Chuyển hướng người dùng sau đăng nhập (VD: vào màn hình chính)
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MainScreen()));

      } else {
        print("Lỗi: Không thể đăng nhập.");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Đăng nhập thất bại!")),
        );
      }

    } catch (e) {
      print("Lỗi đăng nhập: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lỗi: Kiểm tra email và mật khẩu.")),
      );
    }
  }
}
