import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../view/screens/login_screen/login_screen.dart';
import '../view/utils/overlay_utils.dart';

class NavigationController{
  final supabase = Supabase.instance.client;
  void showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Đăng xuất'),
            content: const Text('Bạn có chắc chắn muốn đăng xuất không?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Hủy'),
              ),
              TextButton(
                onPressed: () async {
                  await Supabase.instance.client.auth.signOut();

                  // ignore: use_build_context_synchronously
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                        (route) => false,
                  );
                },
                child: const Text('Đăng xuất'),
              ),
            ],
          );
        }
    );
  }

  Future<void> getUserProfile(BuildContext context) async {
    final userId = supabase.auth.currentUser?.id;
    //print(userId);

    if (userId == null) {
      print('User not logged in');
      return;
    }

    try {
      final response = await supabase
          .from('admin')
          .select('email, username, profile_image')
          .eq('admin_id', userId)
          .maybeSingle(); // Trả về null nếu không có bản ghi
      //print('Supabase response: $response');


      if (response != null) {
        final fullName = response['username'] ?? 'Unknown';
        final email = response['email'] ?? '';
        final profileImage = response['profile_image'] ?? '';

        showProfileOverlay(context, fullName, email, profileImage );
      } else {
        print('Không tìm thấy thông tin người dùng');
      }
    } catch (error) {
      print('Đã xảy ra lỗi khi lấy thông tin người dùng: $error');

    }
  }


}
