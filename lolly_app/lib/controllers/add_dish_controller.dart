import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import '../../../models/dishes_model.dart';

class AddDishController {
  final SupabaseClient supabase = Supabase.instance.client;

  /// Upload ảnh lên Supabase Storage, trả về public URL
  Future<String?> uploadImage(File file) async {
    try {
      final String fileName = Uuid().v4();

      // 🔽 Lấy đuôi file gốc từ đường dẫn ảnh
      final String extension = file.path.split('.').last;
      final String filePath = '$fileName.$extension';

      final storageResponse = await supabase.storage.from('dishes').upload(
        filePath,
        file,
        fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
      );

      if (storageResponse.isEmpty) {
        throw Exception('Upload thất bại hoặc file đã tồn tại');
      }

      final String publicUrl = supabase.storage.from('dishes').getPublicUrl(filePath);
      print('📷 URL ảnh đã upload: $publicUrl');
      return publicUrl;
    } catch (e) {
      print('❌ Lỗi upload ảnh: $e');
      return null;
    }
  }



  /// Lưu món ăn mới vào cơ sở dữ liệu
  Future<void> addDish(RecipeModel recipe, File? imageFile, String userId) async {
    try {
      // 1. Upload ảnh nếu có
      String? imageUrl;
      if (imageFile != null) {
        imageUrl = await uploadImage(imageFile);
      }

      final now = DateTime.now().toUtc().toIso8601String();

      // 2. Insert vào bảng dishes
      final dishResponse = await supabase.from('dishes').insert({
        'dish_name': recipe.title,
        'image_url': imageUrl,
        'user_id': userId,
        'created_at': now,
        'cook': recipe.instructions,
        'notes': recipe.notes,
      }).select().single();

      final dishId = dishResponse['id'];

      // 3. Lưu nguyên liệu vào bảng ingredients và dish_ingredients
      for (final ing in recipe.ingredients) {
        final ingredientId = await _getOrCreateIngredientId(ing.name, now);

        await supabase.from('dish_ingredients').insert({
          'dish_id': dishId,
          'ingredient_id': ingredientId,
          'quantity': ing.quantity,
          'created_at': now,
        });
      }

      print('✅ Lưu công thức thành công!');
    } catch (e) {
      print('❌ Lỗi khi lưu công thức: $e');
      rethrow;
    }
  }

  /// Lấy ID nguyên liệu nếu đã có, chưa có thì thêm mới (kèm created_at)
  Future<String> _getOrCreateIngredientId(String ingredientName, String createdAt) async {
    final existing = await supabase
        .from('ingredients')
        .select('ingredient_id')
        .eq('ingredient_name', ingredientName)
        .maybeSingle();

    if (existing != null) {
      return existing['ingredient_id'] as String;
    } else {
      final inserted = await supabase
          .from('ingredients')
          .insert({
        'ingredient_name': ingredientName,
        'created_at': createdAt,
      })
          .select('ingredient_id')
          .single();
      return inserted['ingredient_id'] as String;
    }
  }
}
