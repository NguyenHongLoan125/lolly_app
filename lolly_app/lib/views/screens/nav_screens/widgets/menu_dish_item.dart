import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lolly_app/views/screens/nav_screens/add_dish_screen.dart';
import 'package:lolly_app/views/screens/nav_screens/widgets/add_to_menu.dart';

class MenuDishItemWidget extends StatelessWidget {
  final Map<String, dynamic> dishData;

  const MenuDishItemWidget({super.key, required this.dishData});

  @override
  Widget build(BuildContext context) {
    final String dishName =
        dishData['dish_name'] as String? ?? 'Món an chưa có tên';
    // final categoryData =
    // productData['categories']; // Lấy Map lồng nhau (hoặc null)
    // String categoryName = 'Không rõ'; // Giá trị mặc định
    //
    // if (categoryData is Map<String, dynamic>) {
    //   // Nếu categoryData là Map, lấy giá trị của cột tên danh mục
    //   categoryName = categoryData['category_name'] as String? ?? 'N/A';
    // } else if (categoryData != null) {
    //   // Ghi log nếu categoryData có giá trị nhưng không phải là Map (trường hợp lạ)
    //   print(
    //     'DEBUG (ProductItemWidget): Dữ liệu category không phải Map: $categoryData',
    //   );
    // }
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Color(0xFFFFF8F8),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Color(0xFFDBBF4E)),
        ),
        child: Row(
          children: [
            // Image Section
            Container(
              width: 120,
              height: 100,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Color(0xFFECF5E3),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Color(0xFF007400),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  dishData['image_url'],
                  width: 110,
                  height: 90,
                  fit: BoxFit.fill,
                ),
              ),
            ),

            const SizedBox(width: 20),

            // Info Section
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        dishName,
                        style: GoogleFonts.lato(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1E3354),
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.favorite_border, color: Colors.red, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            '39',
                            style: GoogleFonts.lato(fontSize: 13, color: Colors.red),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  // Ingredient Description
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Nguyên liệu: ${dishData['ingredient']}",
                      style: GoogleFonts.lato(
                        fontSize: 13,
                        color: const Color(0xFF7F8E9D),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      onPressed: () {
                        final dishId = dishData['id'] as String;
                        deleteToMenu(context: context, dishId: dishId);
                      },
                      icon: const Icon(Icons.delete_rounded, size: 28,),
                      tooltip: "Xóa",
                    ),
                  )

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}