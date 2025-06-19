import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lolly_app/controllers/category_controller.dart';
import 'package:lolly_app/views/screens/inner_screens/category_dish_screen.dart';

class CategoryItem extends StatefulWidget {
  const CategoryItem({super.key});

  @override
  State<CategoryItem> createState() => _CategoryItemState();
}

class _CategoryItemState extends State<CategoryItem> {
  final CategoryController _categoryController = Get.find<CategoryController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Chiều cao cố định để hiển thị tối đa 2 hàng
      final gridHeight = 120.0;

      return SizedBox(
        height: gridHeight,
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _categoryController.categories.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 72 / 100, // cao hơn icon để vừa chữ
          ),
          itemBuilder: (context, index) {
            final category = _categoryController.categories[index];
            return InkWell(
              onTap: () {
                // Navigator.push(context,
                //     MaterialPageRoute(builder: (context){
                //       return CategoryDishScreen(categoryModel: _categoryController.categories[index],);
                //     }));
                final categoryName = category.category_name;
                context.go('/home/$categoryName', extra: category);
              },
              child: Column(
                children: [
                  Image.network(
                    category.category_image,
                    width: 72,
                    height: 72,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    category.category_name,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.quicksand(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            );
          },
        ),
      );
    });
  }
}
