import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/user_model.dart';

class UserDetailScreen extends StatelessWidget {
  final UserModel user;

  const UserDetailScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final formattedDate = user.createAt != null
        ? DateFormat('HH:mm:ss   dd/MM/yyyy').format(user.createAt!)
        : 'Không rõ';

    return Scaffold(
      backgroundColor: const Color(0xffECF5E3),
      appBar: AppBar(
        backgroundColor: const Color(0xffECF5E3),
        centerTitle: true,
        elevation: 0,
        title: Text(
          user.username ?? 'Thông tin người dùng',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xff007400),
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xff007400)),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Avatar tròn
              CircleAvatar(
                radius: 100,
                backgroundColor: Colors.grey.shade300,
                backgroundImage: user.profileImg != null && user.profileImg!.isNotEmpty
                    ? NetworkImage(user.profileImg!)
                    : null,
                child: user.profileImg == null || user.profileImg!.isEmpty
                    ? const Icon(Icons.person, size: 150, color: Colors.white)
                    : null,
              ),
              const SizedBox(height: 24),

              // Thông tin chi tiết
              _buildInfoRow('ID', user.id),
              _buildInfoRow('Email', user.email),
              _buildInfoRow('Giới tính', user.gender ?? 'Chưa có'),
              _buildInfoRow('Địa chỉ', user.address ?? 'Chưa có'),
              _buildInfoRow('Giới thiệu', user.introduction ?? 'Chưa có'),
              _buildInfoRow('Ngày tạo', formattedDate),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Flexible(
            child: Text(
              value ?? '',
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
