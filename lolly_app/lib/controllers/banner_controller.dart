import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // Supabase import

class BannerController extends GetxController {
  final SupabaseClient _supabase = Supabase.instance.client; // Khởi tạo Supabase

  Stream<List<String>> getBannerUrls() { // Tên hàm hơi khác nhưng mục đích tương tự
    const String primaryKeyColumn = 'id'; // Cần cho Supabase stream

    // Lấy stream từ bảng 'banners' của Supabase
    return _supabase
        .from("banners")
        .stream(primaryKey: [primaryKeyColumn])
        .order('created_at', ascending: true)
        .map((listOfMaps) {

      // Biến đổi List<Map> từ Supabase thành List<String> chứa URL ảnh
      // Có thêm lọc và kiểm tra kiểu dữ liệu để an toàn hơn
      final List<String> urls = listOfMaps
          .where((map) => map['image'] is String)
          .map((map) => map['image'] as String)
          .toList();
      print('Supabase Realtime Update - Banner URLs: $urls');
      return urls;
    })
        .handleError((error) {
      print('Lỗi Supabase Realtime Stream: $error');
      return <String>[];
    });
  }
}