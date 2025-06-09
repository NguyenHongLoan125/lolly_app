import 'package:flutter/material.dart';
import 'package:lolly_app/models/catygory_models.dart';
import 'package:lolly_app/views/screens/nav_screens/widgets/category_button_list.dart';
import 'package:lolly_app/views/screens/nav_screens/widgets/dish_item.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CategoryDishScreen extends StatefulWidget {
  final CategoryModel categoryModel;

  const CategoryDishScreen({super.key, required this.categoryModel});

  @override
  State<CategoryDishScreen> createState() => _CategoryDishScreenState();
}

class _CategoryDishScreenState extends State<CategoryDishScreen> {
  final ScrollController _scrollController = ScrollController();
  final double _categoryButtonWidth = 130;
  String? _selectedSubCategory;

  void _scrollRight() {
    final double newOffset =
    (_scrollController.offset + _categoryButtonWidth * 2).clamp(
      0.0,
      _scrollController.position.maxScrollExtent,
    );

    _scrollController.animateTo(
      newOffset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<Map<int, String>> fetchCategories() async {
    final response = await Supabase.instance.client
        .from('categories')
        .select('id, category_name');

    Map<int, String> categoryMap = {};
    for (var category in response) {
      categoryMap[category['id']] = category['category_name'];
    }

    return categoryMap;
  }

  // Future<List<String>> fetchSubCategoriesByCategoryName(String categoryName) async {
  //   final List<Map<String, dynamic>> data = await Supabase.instance.client
  //       .from('sub_categories')
  //       .select('sub_category_name, categories!inner(category_name)')
  //       .eq('categories.category_name', categoryName);
  //
  //   return data.map<String>((e) => e['sub_category_name'] as String).toList();
  // }

  @override
  Widget build(BuildContext context) {
    final Stream<List<Map<String, dynamic>>> dishStream = Supabase.instance.client
        .from('dishes')
        .select('*, dish_sub_categories(categories, sub_categories(*, categories(id, category_name)))')
        .order('created_at', ascending: false)
        .asStream();


    return Scaffold(
      backgroundColor: const Color(0xFFECF5E3),
      appBar: AppBar(
        backgroundColor: const Color(0xFFECF5E3),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF007400)),
          onPressed: () => Navigator.pop(context),
        ),

        title: Text(
          widget.categoryModel.category_name,
          style: const TextStyle(
            color: Color(0xFF007400),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,

        actions: [
          Image.asset('assets/logo.png', height: 70, width: 70),
        ],
        elevation: 0,
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          SubCategoryButtons(
                            categoryName: widget.categoryModel.category_name,
                            selectedSubCategory: _selectedSubCategory,
                            onSubCategorySelected: (selectedSubCat) {
                              setState(() {
                                _selectedSubCategory = selectedSubCat == "Tất cả" ? null : selectedSubCat;
                              });
                            },
                          ),

                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.15,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_forward_ios, color: Color(0xFF007400)),
                    onPressed: _scrollRight,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: dishStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.hasError) {
                    return const Center(
                      child: Text(
                        'Không tải được dữ liệu món ăn',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }

                  final dishes = snapshot.data!;

                  final filteredDishes = dishes.where((dish) {
                    // Lấy danh sách sub_categories từ dish_sub_categories
                    final dishSubCategories = dish['dish_sub_categories'];
                    if (dishSubCategories == null || dishSubCategories.isEmpty) return false;

                    // Duyệt qua từng sub_category
                    for (final dishSubCategory in dishSubCategories) {
                      final subCategory = dishSubCategory['sub_categories'];
                      if (subCategory == null) continue;

                      final category = subCategory['categories'];
                      if (category == null) continue;

                      final categoryName = category['category_name'];
                      if (categoryName == widget.categoryModel.category_name) {
                        // Nếu có chọn subCategory cụ thể thì kiểm tra
                        if (_selectedSubCategory != null) {
                          if (subCategory['sub_category_name'] == _selectedSubCategory) {
                            return true;
                          }
                        } else {
                          return true; // Nếu chọn "Tất cả"
                        }
                      }
                    }
                    return false; // Không thuộc danh mục nào
                  }).toList();


                  if (filteredDishes.isEmpty) {
                    return Text(
                      'Chưa có món ăn trong danh mục này\nVui lòng quay lại sau.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: ListView.builder(
                      itemCount: filteredDishes.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 12.0, bottom: 12),
                          child: DishItemWidget(dishData: filteredDishes[index]),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}