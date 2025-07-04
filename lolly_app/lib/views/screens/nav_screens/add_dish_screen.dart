import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lolly_app/models/catygory_models.dart';
import 'package:lolly_app/models/sub_category_models.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../controllers/add_dish_controller.dart';
import '../../../models/dishes_model.dart';

class AddDishScreen extends StatefulWidget {
  final Map<String, dynamic>? dishData;
  const AddDishScreen({super.key, this.dishData});

  @override
  State<AddDishScreen> createState() => _AddDishScreenState();
}

class _AddDishScreenState extends State<AddDishScreen> {
  final AddDishController controller = AddDishController();
  final ImagePicker _picker = ImagePicker();
  File? selectedImage;

  List<SubCategoryModels> allDishCategories = [];
  List<SubCategoryModels> selectedCategories = [];
  bool isLoading = true;

  List<CategoryModel> requiredCategories = [];
  Map<int, String?> selectedSubCategories = {};
  Map<int, List<SubCategoryModels>> subCategoriesMap = {};

  String? imageUrlFromServer;

  Map<int, int?> convertedMap = {};
  List<int> mergedIds = [];

  final TextEditingController titleController = TextEditingController();
  final TextEditingController instructionsController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  final List<Map<String, TextEditingController>> ingredients = [];

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    loadAllData();
    addIngredient();
  }

  Future<void> loadAllData() async {
    convertSelectedNamesToIds();
    await loadRequiredCategories();
    await loadCategories();
    await loadDishDataForEditing();
    mergeSelectedIds(selectedCategories, convertedMap);
  }

  Future<void> loadDishDataForEditing() async {
    if (widget.dishData != null) {

      titleController.text = widget.dishData!['dish_name'] ?? '';
      instructionsController.text = widget.dishData!['cook'] ?? '';
      notesController.text = widget.dishData!['notes'] ?? '';
      imageUrlFromServer = widget.dishData!['image_url'];

      Future.microtask(() => loadIngredients(widget.dishData!['id']));
      final List<dynamic> dishSubCategories = widget.dishData!['dish_sub_categories'] ?? [];

      // Tạo list id từ dishSubCategories
      List<int> subCategoryIds = [];

      for (var item in dishSubCategories) {
        if (item['categories'] != null) {
          subCategoryIds.add(item['categories']);
        }
      }

      // Load allDishCategories
      if (allDishCategories.isEmpty) {
        await loadCategories();
      }

      // Cập nhật selectedCategories cho FilterChip
      setState(() {
        selectedCategories = allDishCategories
            .where((e) => subCategoryIds.contains(e.id))
            .toList();
      });

      // Cập nhật selectedSubCategories cho DropdownButtonFormField
      for (var subId in subCategoryIds) {
        subCategoriesMap.forEach((catId, subs) {
          try {
            final matched = subs.firstWhere((e) => e.id == subId);
            setState(() {
              selectedSubCategories[catId] = matched.sub_category_name;
            });
          } catch (e) {
            print('subId $subId not found in category $catId');
          }
        });
      }
      // Convert thành convertedMap
      convertSelectedNamesToIds();
    }
  }

  Future<void> pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        final file = File(image.path);
        setState(() {
          selectedImage = file;
        });
        print('Ảnh đã chọn: ${file.path}');
      } else {
        print('Không chọn ảnh');
      }
    } catch (e) {
      print('Lỗi chọn ảnh: $e');
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

    mergedIds = mergeSelectedIds(selectedCategories, convertedMap);
    // print('🔍 Merged IDs trước khi tạo recipe: $mergedIds');

    final recipe = RecipeModel(
      imageUrl: null,
      title: titleController.text.trim(),
      ingredients: ingredientList,
      instructions: instructionsController.text.trim(),
      notes: notesController.text.trim(),
      subCategory: mergedIds,
    );
    try {
      final userId = Supabase.instance.client.auth.currentUser?.id ?? '';
      String? imageUrl;
      if (selectedImage != null) {
        final uploadedUrl = await controller.uploadImage(selectedImage!);
        if (uploadedUrl == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Không thể tải ảnh lên.')),
          );
          return;
        }
        imageUrl = uploadedUrl;
      }

      if (widget.dishData != null) {
        // Chế độ chỉnh sửa: cập nhật
        final dishId = widget.dishData!['id'];
        await controller.updateDish(
          dishId: dishId,
          recipe: recipe,
          imageUrl: imageUrl,
          isPublished: true,
        );
      } else {
        // Chế độ thêm mới
        await controller.addDish(
          recipe,
          selectedImage,
          userId,
          isPublished: true,
        );
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Món ăn đã được đăng!')),
        );
        context.go('/home');
      }
    } catch (e, stack) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Có lỗi xảy ra khi đăng món ăn.')),
      );
    }}

  Future<void> saveDraft() async {
    if (!_formKey.currentState!.validate()) return;

    final List<Ingredient> ingredientList = ingredients
        .map((item) => Ingredient(
      name: item['name']!.text.trim(),
      quantity: item['amount']!.text.trim(),
    ))
        .where((ing) => ing.name.isNotEmpty || ing.quantity.isNotEmpty)
        .toList();
    mergedIds = mergeSelectedIds(selectedCategories, convertedMap);
    // print('Merged IDs trước khi tạo recipe: $mergedIds');

    final recipe = RecipeModel(
      imageUrl: null,
      title: titleController.text.trim(),
      ingredients: ingredientList,
      instructions: instructionsController.text.trim(),
      notes: notesController.text.trim(),
      subCategory: mergedIds,
    );

    try {
      final userId = Supabase.instance.client.auth.currentUser?.id ?? '';
      String? imageUrl;
      if (selectedImage != null) {
        final uploadedUrl = await controller.uploadImage(selectedImage!);
        if (uploadedUrl == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Không thể tải ảnh lên.')),
          );
          return;
        }
        imageUrl = uploadedUrl;
      }

      if (widget.dishData != null) {
        final dishId = widget.dishData!['id'];
        await controller.updateDish(
          dishId: dishId,
          recipe: recipe,
          imageUrl: imageUrl,
          isPublished: false,
        );
      } else {
        await controller.addDish(
          recipe,
          selectedImage,
          userId,
          isPublished: false,
        );
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đã lưu nháp!')),
        );
        context.go('/home');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Có lỗi xảy ra khi lưu nháp.')),
      );
    }
  }

  Future<void> loadIngredients(String dishId) async {
    final response = await Supabase.instance.client
        .from('dish_ingredients')
        .select('quantity, ingredients(ingredient_name)')
        .eq('dish_id', dishId);

    setState(() {
      ingredients.clear();
      for (final item in response) {
        final name = item['ingredients']['ingredient_name'] ?? '';
        final quantity = item['quantity'] ?? '';
        ingredients.add({
          'name': TextEditingController(text: name),
          'amount': TextEditingController(text: quantity.toString()),
        });
      }
    });
  }

  Widget buildImagePicker() {
    return GestureDetector(
      onTap: pickImage,
      child: Container(
        height: 150,
        width: 200,
        decoration: BoxDecoration(
          color: const Color(0xFFDDEACD),
          borderRadius: BorderRadius.circular(12),
          image: selectedImage != null
              ? DecorationImage(
            image: FileImage(selectedImage!),
            fit: BoxFit.fill,
          )
              : (imageUrlFromServer != null
              ? DecorationImage(
            image: NetworkImage(imageUrlFromServer!),
            fit: BoxFit.fill,
          )
              : null),
        ),
        child: (selectedImage == null && imageUrlFromServer == null)
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.camera_alt, size: 40, color: Colors.black54),
            SizedBox(height: 8),
            Text(
              '+ Thêm ảnh',
              style: TextStyle(color: Colors.black54),
            ),
          ],
        )
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

  Future<void> loadCategories() async {
    final categories = await fetchDishCategories();
    setState(() {
      allDishCategories = categories;
      isLoading = false;
    });
  }

  Future<void> loadRequiredCategories() async {
    final categories = await fetchRequiredCategories();
    setState(() {
      requiredCategories = categories;
    });

    // Load sub categories cho từng category
    for (var cat in categories) {
      final subs = await fetchSubCategoriesByCategory(cat.id);
      setState(() {
        subCategoriesMap[cat.id] = subs;
        selectedSubCategories[cat.id] = null;
      });
    }
  }

  void convertSelectedNamesToIds() {
    selectedSubCategories.forEach((categoryId, subCategoryName) {
      if (subCategoryName != null) {
        final subs = subCategoriesMap[categoryId];

        if (subs != null) {
          SubCategoryModels? matchedSub;
          try {
            matchedSub = subs.firstWhere((e) => e.sub_category_name == subCategoryName);
          } catch (e) {
            matchedSub = null;
          }
          if (matchedSub != null) {
            convertedMap[categoryId] = matchedSub.id;
          } else {
            convertedMap[categoryId] = null;
          }
        } else {
          convertedMap[categoryId] = null;
        }
      } else {
        convertedMap[categoryId] = null;
      }
    });
  }

  List<int> mergeSelectedIds(
      List<SubCategoryModels> selectedCategories,
      Map<int, int?> convertedMap,
      ) {
    // Dùng Set để tự động loại trùng
    Set<int> mergedSet = {};

    mergedSet.addAll(selectedCategories.map((e) => e.id));
    mergedSet.addAll(convertedMap.values.whereType<int>());

    final mergedIds = mergedSet.toList();
    return mergedIds;
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
              const SizedBox(height: 20),
              TextFormField(
                controller: titleController,
                decoration: inputDecoration('Tên công thức'),
                validator: (val) => val == null || val.isEmpty ? 'Nhập tên công thức' : null,
              ),
              const SizedBox(height: 12),
              Column(
                children: requiredCategories.map((category) {
                  final subCategories = subCategoriesMap[category.id] ?? [];

                  return Column(
                    children: [
                      DropdownButtonFormField<String>(
                        decoration: inputDecoration(category.category_name),
                        value: selectedSubCategories[category.id],
                        items: subCategories
                            .map((e) => DropdownMenuItem(
                          value: e.sub_category_name,
                          child: Text(e.sub_category_name),
                        ))
                            .toList(),
                        onChanged: (val) {
                          setState(() {
                            selectedSubCategories[category.id] = val;
                          });
                          convertSelectedNamesToIds();
                        },
                      ),

                      const SizedBox(height: 12),
                    ],
                  );
                }).toList(),
              ),

              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Danh mục món ăn',
                  style: TextStyle(fontSize: 17, color: Color(0xFF007400), fontWeight: FontWeight.w500),
                ),
              ),

              if (selectedCategories.isNotEmpty)
                Wrap(
                  spacing: 8,
                  children: selectedCategories.map((category) {
                    return Chip(
                      label: Text(
                        category.sub_category_name,
                      ),
                      backgroundColor: Color(0xFFDCEDD7),
                      deleteIcon: Icon(Icons.close,),
                      onDeleted: () {
                        setState(() {
                          selectedCategories.remove(category);
                        });
                      },
                      shape: StadiumBorder(
                        side: BorderSide(
                          color:  Color(0xFFDCEDD7),
                          width: 1,
                        ),
                      ),
                    );
                  }).toList(),
                ),

              const SizedBox(height: 10),

              SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: allDishCategories.length,
                  itemBuilder: (context, index) {
                    final category = allDishCategories[index];
                    final isSelected = selectedCategories.contains(category);

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: FilterChip(
                        label: Text(
                          category.sub_category_name,
                          style: TextStyle(
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected ? Colors.white : Colors.black45,
                          ),
                        ),
                        selected: isSelected,
                        selectedColor: Colors.green,
                        backgroundColor: Color(0xFFDCEDD7),
                        checkmarkColor: Colors.white,
                        onSelected: (selected) {
                          setState(() {
                            if (selected && !selectedCategories.contains(category)) {
                              selectedCategories.add(category);
                            }
                          });
                        },
                        shape: StadiumBorder(
                          side: BorderSide(
                            color: Color(0xFFDCEDD7),
                            width: 1,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  const Text('Nguyên liệu', style: TextStyle(fontSize: 17, color: Color(0xFF007400), fontWeight: FontWeight.w500),
                  ),
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
                }
                ),
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
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF007400),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text('Lưu nháp',style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),),
                      ),
                    ),

                  const SizedBox(width: 40),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: submitRecipe,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF007400),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text('Đăng',style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}