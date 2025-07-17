import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/user_model.dart';

class UserController with ChangeNotifier {
  final supabase = Supabase.instance.client;

  List<UserModel> _users = [];
  List<UserModel> get users => _users;

  Future<List<UserModel>> fetchUsers() async {
    try {
      final response = await supabase.from('users').select();
      _users = (response as List)
          .map((e) => UserModel.fromMap(e as Map<String, dynamic>))
          .toList();
      notifyListeners();
      return _users;
    } catch (e) {
      debugPrint("❌ Lỗi khi fetch users: $e");
      return [];
    }
  }


  Future<bool> deleteUser(String userId) async {
    try {
      await supabase.from('users').delete().eq('user_id', userId);
      _users.removeWhere((u) => u.id == userId);
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint("❌ Lỗi khi xóa user $userId: $e");
      return false;
    }
  }



}
