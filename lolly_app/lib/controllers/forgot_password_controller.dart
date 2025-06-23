import 'package:supabase_flutter/supabase_flutter.dart';

class ForgotPasswordController {
  static final _client = Supabase.instance.client;

  static Future<bool> sendOtp(String email) async {
    try {
      final res = await _client.functions.invoke(
        'send-otp',
        body: {'email': email},
      );
      print('✅ Supabase response (send-otp): status = ${res.status}, body = ${res.data}');
      if (res.status != 200) {
        print('❌ send-otp thất bại với lỗi: ${res.data}');
        return false;
      }
      return true;
    } catch (e, s) {
      print('❌ Lỗi khi gọi Supabase send-otp: $e');
      print('📌 Stacktrace: $s');
      return false;
    }
  }

  static Future<bool> verifyOtp(String email, String otp) async {
    try {
      final res = await _client.functions.invoke(
        'verify-otp',
        body: {'email': email, 'otp': otp},
      );
      print('✅ Supabase response (verify-otp): status = ${res.status}, body = ${res.data}');
      if (res.status != 200) {
        print('❌ verify-otp thất bại với lỗi: ${res.data}');
        return false;
      }
      return true;
    } catch (e, s) {
      print('❌ Lỗi khi gọi Supabase verify-otp: $e');
      print('📌 Stacktrace: $s');
      return false;
    }
  }

  static Future<bool> resetPassword(String email, String otp, String newPassword) async {
    try {
      final res = await _client.functions.invoke(
        'reset-password-by-otp',
        body: {
          'email': email,
          'otp': otp,
          'new_password': newPassword,
        },
      );
      print('✅ Supabase response (reset-password): status = ${res.status}, body = ${res.data}');
      if (res.status != 200) {
        print('❌ reset-password thất bại với lỗi: ${res.data}');
        return false;
      }
      return true;
    } catch (e, s) {
      print('❌ Lỗi khi gọi Supabase reset-password: $e');
      print('📌 Stacktrace: $s');
      return false;
    }
  }
}
