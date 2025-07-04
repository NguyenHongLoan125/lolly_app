import 'package:supabase_flutter/supabase_flutter.dart';

class SubCategoryModels{
  final int id;
  final String sub_category_name;
  final int category;

  SubCategoryModels({required this.id, required this.sub_category_name, required this.category});
  @override
  String toString() {
    return 'SubCategoryModels(id: $id, sub_category_name: $sub_category_name, category: $category)';
  }
  factory SubCategoryModels.fromMap(Map<String, dynamic> map) {
    return SubCategoryModels(
      id: map['id'],
      sub_category_name: map['sub_category_name'].toString(),
      category: map['category'],
    );
  }
}

Future<List<SubCategoryModels>> fetchDishCategories() async {
  final response = await Supabase.instance.client
      .from('sub_categories')
      .select('*, categories!inner(*)')
      .eq('categories.is_required', false);
  final data = response as List;
  return data.map((e) => SubCategoryModels.fromMap(e)).toList();
}