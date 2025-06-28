import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import '../../../controllers/add_dish_controller.dart';
import '../../../models/dishes_model.dart';

class AddDishScreen extends StatefulWidget {
  const AddDishScreen({super.key});

  @override
  State<AddDishScreen> createState() => _AddDishScreenState();
}

class _AddDishScreenState extends State<AddDishScreen> {
  final AddDishController controller = AddDishController();
  final ImagePicker _picker = ImagePicker();
  File? selectedImage;
  final List<String> cookingTimes = ['15 phút', '30 phút', '1 giờ'];
  final List<String> difficultyLevels = ['Dễ', 'Trung bình', 'Khó'];
  final List<String> servingsList = ['1 người', '2 người', '4 người'];

  String selectedTime = '30 phút';
  String selectedDifficulty = 'Trung bình';
  String selectedServing = '1 người';

  final TextEditingController titleController = TextEditingController();
  final TextEditingController instructionsController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  final List<Map<String, TextEditingController>> ingredients = [];

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    addIngredient();
  }

  Future<void> pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        final file = File(image.path);
        setState(() {
          selectedImage = file;
        });
        print('📸 Ảnh đã chọn: ${file.path}');
      } else {
        print('⚠️ Không chọn ảnh');
      }
    } catch (e) {
      print('❌ Lỗi chọn ảnh: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Không thể chọn ảnh')),
        );
      }
    }
  }


  void addIngredient() {
    setState(() {
      ingredients.add({
        'name': TextEditingController(),
        'amount': TextEditingController(),
      });
    });
  }

  void removeIngredient(int index) {
    setState(() {
      ingredients.removeAt(index);
    });
  }


  Future<void> submitRecipe() async {
    if (!_formKey.currentState!.validate()) return;

    final List<Ingredient> ingredientList = ingredients
        .map((item) => Ingredient(
      name: item['name']!.text.trim(),
      quantity: item['amount']!.text.trim(),
    ))
        .where((ing) => ing.name.isNotEmpty || ing.quantity.isNotEmpty)
        .toList();

    final recipe = RecipeModel(
      imageUrl: null,
      title: titleController.text.trim(),
      cookTime: selectedTime,
      difficulty: selectedDifficulty,
      servings: selectedServing,
      ingredients: ingredientList,
      instructions: instructionsController.text.trim(),
      notes: notesController.text.trim(),
    );

    try {
      final userId = Supabase.instance.client.auth.currentUser?.id ?? '';

      // 👉 kiểm tra upload ảnh
      if (selectedImage != null) {
        final url = await controller.uploadImage(selectedImage!);
        if (url == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('❌ Không thể tải ảnh lên.')),
          );
          return;
        }
      }

      await controller.addDish(recipe, selectedImage, userId, isPublished: true);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ Đã đăng món ăn!')),
        );
        context.go('/home');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❌ Có lỗi xảy ra khi đăng món ăn.')),
      );
    }
  }

  Future<void> saveDraft() async {
    if (!_formKey.currentState!.validate()) return;

    final List<Ingredient> ingredientList = ingredients
        .map((item) => Ingredient(
      name: item['name']!.text.trim(),
      quantity: item['amount']!.text.trim(),
    ))
        .where((ing) => ing.name.isNotEmpty || ing.quantity.isNotEmpty)
        .toList();

    final recipe = RecipeModel(
      imageUrl: null,
      title: titleController.text.trim(),
      cookTime: selectedTime,
      difficulty: selectedDifficulty,
      servings: selectedServing,
      ingredients: ingredientList,
      instructions: instructionsController.text.trim(),
      notes: notesController.text.trim(),
    );

    try {
      final userId = Supabase.instance.client.auth.currentUser?.id ?? '';

      // 👉 kiểm tra upload ảnh
      if (selectedImage != null) {
        final url = await controller.uploadImage(selectedImage!);
        if (url == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('❌ Không thể tải ảnh lên.')),
          );
          return;
        }
      }

      await controller.addDish(recipe, selectedImage, userId, isPublished: false);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('💾 Đã lưu nháp!')),
        );
        context.go('/home');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❌ Có lỗi xảy ra khi lưu nháp.')),
      );
    }
  }



  Widget buildImagePicker() {
    return GestureDetector(
      onTap: pickImage,
      child: Container(
        height: 250,
        width: 250,
        decoration: BoxDecoration(
          color: const Color(0xFFDDEACD),
          borderRadius: BorderRadius.circular(12),
          image: selectedImage != null
              ? DecorationImage(
            image: FileImage(selectedImage!),
            fit: BoxFit.cover,
          )
              : null,
        ),
        child: selectedImage == null
            ? const Icon(Icons.camera_alt, size: 40, color: Colors.black54)
            : null,
      ),
    );
  }

  InputDecoration inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: const Color(0xFFDCEDD7),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    );
  }

  ButtonStyle greenButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: Colors.green[700],
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Công thức nấu ăn',
          style: TextStyle(
            fontSize: 20,
            color: Color(0xff007400),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xffECF5E3),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF007400)),
          onPressed: () => context.go('/home'),
        ),
      ),
      backgroundColor: const Color(0xffECF5E3),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              buildImagePicker(),
              const SizedBox(height: 8),
              const Text('+ Thêm ảnh', style: TextStyle(color: Colors.black87)),
              const SizedBox(height: 20),
              TextFormField(
                controller: titleController,
                decoration: inputDecoration('Tên công thức'),
                validator: (val) => val == null || val.isEmpty ? 'Nhập tên công thức' : null,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      decoration: inputDecoration('Thời gian nấu'),
                      value: selectedTime,
                      items: cookingTimes
                          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                          .toList(),
                      onChanged: (val) => setState(() => selectedTime = val!),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      decoration: inputDecoration('Độ khó'),
                      value: selectedDifficulty,
                      items: difficultyLevels
                          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                          .toList(),
                      onChanged: (val) => setState(() => selectedDifficulty = val!),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                decoration: inputDecoration('Khẩu phần'),
                value: selectedServing,
                items: servingsList
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) => setState(() => selectedServing = val!),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Text('Nguyên liệu', style: TextStyle(fontSize: 16)),
                  const Spacer(),
                  IconButton(onPressed: addIngredient, icon: const Icon(Icons.add)),
                ],
              ),
              Column(
                children: List.generate(ingredients.length, (index) {
                  final item = ingredients[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            controller: item['name'],
                            decoration: inputDecoration('Nguyên liệu'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 1,
                          child: TextFormField(
                            controller: item['amount'],
                            decoration: inputDecoration('Số lượng'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (ingredients.length > 1)
                          IconButton(
                            icon: const Icon(Icons.remove_circle, color: Colors.red),
                            onPressed: () => removeIngredient(index),
                          ),
                      ],
                    ),
                  );
                }),
              ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: instructionsController,
                  maxLines: 5,
                  decoration: inputDecoration('Hướng dẫn'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: notesController,
                  decoration: inputDecoration('Ghi chú:'),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: saveDraft,
                        style: greenButtonStyle(),
                        child: const Text('Lưu nháp'),
                      ),
                    ),
                  ),
                  const SizedBox(width: 40),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: submitRecipe,
                      style: greenButtonStyle(),
                      child: const Text('Đăng'),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );

  }
}
