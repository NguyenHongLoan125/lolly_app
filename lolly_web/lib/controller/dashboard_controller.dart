import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
import '../models/dashboard_model.dart';

class DashBoardController{
  final _client = Supabase.instance.client;

  Future<int> getOnlineMembers() async {
    final response = await _client
        .from('users')
        .select('user_id', const FetchOptions(count: CountOption.exact));
    return response.count ?? 0;
  }

  Future<int> getDishes() async {
    final response = await _client
        .from('dishes')
        .select('id', const FetchOptions(count: CountOption.exact));
    return response.count ?? 0;
  }

  Future<List<BlockModel>> fetchStats() async {
    final users = await getOnlineMembers();
    final dishes = await getDishes();

    return [
      BlockModel(
        title: "members online",
        value: users,
        unit: '',
        icon: Icons.person,
      ),
      BlockModel(
        title: "total dishes",
        value: dishes,
        unit: '',
        icon: Icons.fastfood,
      ),
    ];
  }

  Future<List<Category>> fetchCategories() async {
    final response = await _client.from('categories').select();
    return (response as List).map((e) => Category.fromMap(e)).toList();
  }

  Future<List<SubCategory>> fetchSubCategoriesByCategory(int categoryId) async {
    final response = await _client
        .from('sub_categories')
        .select()
        .eq('category', categoryId);
    return (response as List).map((e) => SubCategory.fromMap(e)).toList();
  }
}