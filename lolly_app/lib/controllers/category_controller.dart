import 'package:get/get.dart';
import 'package:lolly_app/models/catygory_models.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CategoryController extends GetxController {
  final SupabaseClient _supabase = Supabase.instance.client;

  RxList<CategoryModel> categories = <CategoryModel>[].obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    _fetchCategories();
  }

  void _fetchCategories() {
    _supabase
        .from('categories')
        .stream(primaryKey: ['id'])
        .listen((List<Map<String, dynamic>> data) {
      categories.assignAll(data.map((doc) {
        return CategoryModel(
          id: doc['id'],
          category_name: doc['category_name'],
          category_image: doc['category_image'],
          is_required: doc['is_required']
        );
      }).toList());
    });
  }

  Future<CategoryModel?> fetchCategoryByName(String categoryName) async {
    final response = await Supabase.instance.client
        .from('categories')
        .select('*')
        .eq('category_name', categoryName)
        .maybeSingle();

    if (response == null) return null;

    return CategoryModel(
      id: response['id'],
      category_name: response['category_name'],
      category_image: response['category_image'],
      is_required: response['is_required']
    );
  }

}