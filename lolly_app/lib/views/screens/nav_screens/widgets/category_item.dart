import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lolly_app/controllers/category_controller.dart';

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
      return SizedBox(
        height: 120,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: _categoryController.categories.length,
          padding: const EdgeInsets.only(top: 20,left: 5),
          separatorBuilder: (_, __) => const SizedBox(width: 10),
          itemBuilder: (context, index) {
            final category = _categoryController.categories[index];
            return InkWell(
              onTap: () {
                context.go('/home/${category.category_name}', extra: category);
              },
              child: SizedBox(
                width: 85,
                child: Column(
                  children: [
                    Image.network(
                      category.category_image,
                      width: 72,
                      height: 72,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 4),
                    SizedBox(
                      height: 35, // đủ cho 2 dòng text nhỏ
                      child: Text(
                        category.category_name,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.quicksand(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );

    });
  }
}
