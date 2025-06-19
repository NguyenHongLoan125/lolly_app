import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lolly_app/controllers/dish_controller.dart';
import 'package:lolly_app/models/catygory_models.dart';
import 'package:lolly_app/views/screens/nav_screens/widgets/category_button_list.dart';
import 'package:lolly_app/views/screens/nav_screens/widgets/dish_item.dart';

class CategoryDishScreen extends StatefulWidget {
  final CategoryModel categoryModel;
  final String? subCategoryName;

  const CategoryDishScreen({
    super.key,
    required this.categoryModel,
    this.subCategoryName,
  });

  @override
  State<CategoryDishScreen> createState() => _CategoryDishScreenState();
}

class _CategoryDishScreenState extends State<CategoryDishScreen> {
  final ScrollController _scrollController = ScrollController();
  final double _categoryButtonWidth = 130;
  final DishController _dishController = Get.find();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFECF5E3),
      appBar: AppBar(
        backgroundColor: const Color(0xFFECF5E3),
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
                SizedBox(
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
                            categoryModel: widget.categoryModel,
                            selectedSubCategory: widget.subCategoryName,
                            onSubCategorySelected: (selectedSubCat) {
                              // Handle UI update if needed
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
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
                stream: _dishController.getDishesStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.hasError) {
                    return const Center(
                      child: Text(
                        'Không tải được dữ liệu món ăn',
                        style: TextStyle(color: Colors.black),
                      ),
                    );
                  }

                  final filteredDishes = _dishController.filterDishesByCategory(
                    allDishes: snapshot.data!,
                    categoryName: widget.categoryModel.category_name,
                    subCategoryName: widget.subCategoryName,
                  );

                  if (filteredDishes.isEmpty) {
                    return const Center(
                      child: Text(
                        'Chưa có món ăn trong danh mục này\nVui lòng quay lại sau.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
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
