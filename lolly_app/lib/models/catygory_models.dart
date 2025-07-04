import 'package:lolly_app/models/sub_category_models.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CategoryModel{
  final int id;
  final String category_name;
  final String category_image;
  final bool is_required;

  CategoryModel({required this.id, required this.category_name, required this.category_image,    required this.is_required,});

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'],
      category_name: map['category_name'],
      category_image: map['category_image'],
      is_required: map['is_required'],
    );
  }
}
Future<List<SubCategoryModels>> fetchSubCategoriesByCategory(int categoryId) async {
  final response = await Supabase.instance.client
      .from('sub_categories')
      .select('*')
      .eq('category', categoryId);

  final data = response as List;

  return data.map((e) => SubCategoryModels.fromMap(e)).toList();
}

Future<List<CategoryModel>> fetchRequiredCategories() async {
  final response = await Supabase.instance.client
      .from('categories')
      .select('*')
      .eq('is_required', true);

  final data = response as List;

  return data.map((e) => CategoryModel.fromMap(e)).toList();
}
