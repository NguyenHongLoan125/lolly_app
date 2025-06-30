import 'dart:io';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as p;
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';

class EditProfileController {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<UserModel?> getProfile() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return null;

    final data = await _supabase
        .from('users')
        .select()
        .eq('user_id', user.id)
        .maybeSingle();

    return data != null ? UserModel.fromMap(data) : null;
  }

  Future<void> updateProfile(UserModel user) async {
    final currentUser = _supabase.auth.currentUser;
    if (currentUser == null) return;

    final map = user.toMap();
    map['user_id'] = currentUser.id; // dùng 'user_id' làm khóa chính

    await _supabase.from('users').upsert(map);
  }

  Future<String?> uploadAvatar(File imageFile) async {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      print('Chưa đăng nhập');
      return null;
    }

    try {
      final ext = p.extension(imageFile.path);
      final fileName = '${user.id}_${DateTime.now().millisecondsSinceEpoch}$ext';
      final filePath = 'avatars/$fileName'; // Thư mục con trong bucket

      final bytes = await imageFile.readAsBytes();
      final contentType = lookupMimeType(imageFile.path);

      await _supabase.storage
          .from('users') // <–– bucket chính xác của bạn
          .uploadBinary(
        filePath,
        bytes,
        fileOptions: FileOptions(contentType: contentType),
      );

      final publicUrl = _supabase.storage.from('users').getPublicUrl(filePath);
      print('Ảnh upload thành công: $publicUrl');
      return publicUrl;
    } catch (e) {
      print('Lỗi upload ảnh: $e');
      return null;
    }
  }


}
