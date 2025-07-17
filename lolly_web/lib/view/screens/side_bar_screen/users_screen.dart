import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../controller/user_controller.dart';
import '../../widgets/common_table.dart';
import '../detail_screens/user_detail_screen.dart';
import '../../../models/user_model.dart';

class UsersScreen extends StatefulWidget {
  static const String id = 'users_screen';
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  final userCtrl = UserController();

  // Gọi lại sau khi xóa
  Future<void> refreshUsers() async {
    await userCtrl.fetchUsers();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    userCtrl.fetchUsers(); // load ban đầu
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffECF5E3),
      appBar: AppBar(
        backgroundColor: const Color(0xffECF5E3),
        centerTitle: true,
        title: const Text(
          'QUẢN LÝ NGƯỜI DÙNG',
          style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder<List<UserModel>>(
        future: userCtrl.fetchUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final users = userCtrl.users;

          return CommonTable(
            columns: const ['STT', 'ID', 'Email', 'Tên người dùng', 'Ngày tạo', 'Hành động'],
            rows: users.asMap().entries.map((entry) {
              final index = entry.key;
              final user = entry.value;

              return [
                Text('${index + 1}', style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(user.id ?? ''),
                Text(user.email ?? ''),
                Text(user.username ?? ''),
                Text(
                  user.createAt != null
                      ? DateFormat('HH:mm:ss   dd/MM/yyyy').format(user.createAt!)
                      : '',
                ),
                Row(
                  children: [
                    // Nút xem chi tiết
                    Tooltip(
                      message: 'Xem chi tiết',
                      decoration: BoxDecoration(
                        color: const Color(0xff007400),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      textStyle: const TextStyle(color: Colors.white),
                      child: IconButton(
                        icon: const Icon(Icons.visibility, color: Color(0xff007400)),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => UserDetailScreen(user: user),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Nút xóa
                    Tooltip(
                      message: 'Xóa',
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      textStyle: const TextStyle(color: Colors.white),
                      child: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text('Xác nhận xóa'),
                              content: const Text('Bạn có chắc muốn xóa người dùng này không?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context, false),
                                  child: const Text('Hủy'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text('Xóa', style: TextStyle(color: Colors.red)),
                                ),
                              ],
                            ),
                          );

                          if (confirm == true) {
                            final success = await userCtrl.deleteUser(user.id!);
                            if (success) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Xóa người dùng thành công')),
                              );
                              await refreshUsers();
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Xóa người dùng thất bại')),
                              );
                            }
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ];
            }).toList(),
          );
        },
      ),
    );
  }
}
