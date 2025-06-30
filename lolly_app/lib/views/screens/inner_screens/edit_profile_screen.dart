import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../controllers/edit_profile_controller.dart';
import '../../../models/user_model.dart';
import 'package:go_router/go_router.dart'; // để dùng context.go()

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _controller = EditProfileController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _bioController = TextEditingController();

  String _gender = 'Nam';
  String? _profileImageUrl;
  File? _pickedImage;
  UserModel? _user;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = await _controller.getProfile();
    if (user != null) {
      setState(() {
        _user = user;
        _firstNameController.text = user.firstname ?? '';
        _lastNameController.text = user.lastname ?? '';
        _addressController.text = user.address ?? '';
        _bioController.text = user.introduction ?? '';
        _gender = user.gender ?? 'Nam';
        _profileImageUrl = user.profileImage;
      });
    }
  }

  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(source: ImageSource.gallery);
      if (picked != null) {
        setState(() {
          _pickedImage = File(picked.path);
        });
      }
    } catch (e) {
      print('Lỗi khi chọn ảnh: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không thể chọn ảnh')),
      );
    }
  }

  Future<void> _save() async {
    try {
      String? imageUrl = _profileImageUrl;

      if (_pickedImage != null) {
        imageUrl = await _controller.uploadAvatar(_pickedImage!);
        if (imageUrl == null) {
          throw Exception('Upload ảnh thất bại');
        }
      }

      final updatedUser = UserModel(
        userId: _user?.userId,
        email: _user?.email,
        firstname: _firstNameController.text,
        lastname: _lastNameController.text,
        address: _addressController.text,
        gender: _gender,
        introduction: _bioController.text,
        profileImage: imageUrl,
      );

      await _controller.updateProfile(updatedUser);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cập nhật thành công')),
      );
    } catch (e) {
      print('Lỗi khi lưu profile: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã xảy ra lỗi khi lưu dữ liệu')),
      );
    }
  }

  Widget _buildInput(String label, TextEditingController controller, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.green),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.green, width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FFF5),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.go('/account'), // ← chuyển về /account
              ),
            ),
            const SizedBox(height: 10),
            CircleAvatar(
              radius: 50,
              backgroundImage: _pickedImage != null
                  ? FileImage(_pickedImage!)
                  : (_profileImageUrl != null
                  ? NetworkImage(_profileImageUrl!)
                  : null) as ImageProvider?,
              child: (_pickedImage == null && _profileImageUrl == null)
                  ? const Icon(Icons.person, size: 60, color: Colors.white)
                  : null,
              backgroundColor: Colors.black,
            ),
            const SizedBox(height: 10),
            TextButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.edit, color: Colors.green),
              label: const Text("Tải ảnh", style: TextStyle(color: Colors.green,fontSize: 18,fontWeight: FontWeight.bold)),
            ),
            _buildInput("Họ", _lastNameController),
            _buildInput("Tên", _firstNameController),
            const SizedBox(height: 8),
            Row(
              children: ["Nam", "Nữ", "Khác"].map((g) {
                return Row(
                  children: [
                    Radio<String>(
                      value: g,
                      groupValue: _gender,
                      onChanged: (val) => setState(() => _gender = val!),
                    ),
                    Text(g),
                  ],
                );
              }).toList(),
            ),
            _buildInput("Địa chỉ", _addressController),
            _buildInput("Giới thiệu bản thân", _bioController, maxLines: 4),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                child: const Text("Lưu", style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
