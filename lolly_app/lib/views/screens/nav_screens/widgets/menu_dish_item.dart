import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lolly_app/controllers/dish_controller.dart';
import 'package:lolly_app/controllers/menu_controller.dart';
import 'package:lolly_app/models/dish_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../models/ingredient_model.dart';

class MenuDishItemWidget extends StatefulWidget {
  final Map<String, dynamic> dishData;
  const MenuDishItemWidget({super.key, required this.dishData});

  @override
  State<MenuDishItemWidget> createState() => _MenuDishItemWidgetState();
}

class _MenuDishItemWidgetState extends State<MenuDishItemWidget> {
  bool isDeleted = false;
  late DishModel _dish;
  late DishController _controller;
  bool isLiked = false;
  int likeCount = 0;

  @override
  void initState() {
    super.initState();
    _dish = DishModel.fromMap(widget.dishData);
    _controller = DishController();
    likeCount = _dish.likes;
    _checkIfLiked();
  }

  Future<void> _checkIfLiked() async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return;
    final liked = await _controller.isLikedByUser(userId, _dish.id);
    setState(() {
      isLiked = liked;
    });
  }

  Future<void> _toggleLike() async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bạn cần đăng nhập để yêu thích món ăn.')),
      );
      return;
    }

    if (isLiked) {
      await _controller.unlikeDish(userId, _dish);
      setState(() {
        isLiked = false;
        likeCount = likeCount > 0 ? likeCount - 1 : 0;
      });

    } else {
      await _controller.likeDish(userId, _dish);
      setState(() {
        isLiked = true;
        likeCount += 1;
      });
      print("like: ");
      print(likeCount);
    }
  }


  @override
  Widget build(BuildContext context) {
    if (isDeleted) return const SizedBox.shrink();
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
                child: (_dish.imageUrl != null && _dish.imageUrl!.isNotEmpty)
                    ? Image.network(
                  _dish.imageUrl!,
                  width: 110,
                  height: 90,
                  fit: BoxFit.fill,
                  errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.broken_image),
                )
                    : Container(
                  width: 110,
                  height: 90,
                  child: const Icon(Icons.image_not_supported),
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
                      Expanded(
                        child: Text(
                          _dish.name,
                          style: GoogleFonts.lato(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF1E3354),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      GestureDetector(
                        onTap: _toggleLike,
                        child: Row(
                          children: [
                            Icon(
                              isLiked
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: Colors.red,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '$likeCount',
                              style: GoogleFonts.lato(
                                fontSize: 13,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  // Ingredient Description
                  FutureBuilder<List<Ingredient>>(
                    future: fetchIngredientsByDish(_dish.id),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Text('Đang tải nguyên liệu...');
                      }

                      if (snapshot.hasError) {
                        return const Text('Lỗi khi tải nguyên liệu');
                      }

                      final ingredients = snapshot.data ?? [];

                      if (ingredients.isEmpty) {
                        return const Text(
                          'Nguyên liệu: (không có)',
                          style: TextStyle(fontSize: 13, color: Color(0xFF7F8E9D)),
                        );
                      }

                      final ingredientText = ingredients
                          .map((e) => '${e.name} (${e.quantity})')
                          .join(', ');

                      return Text(
                        'Nguyên liệu: $ingredientText',
                        style: GoogleFonts.lato(
                          fontSize: 13,
                          color: const Color(0xFF7F8E9D),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      );
                    },
                  ),

                  const SizedBox(height: 10),

                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      onPressed: () {
                        final dishId = _dish.id as String;
                        final userId = Supabase.instance.client.auth.currentUser?.id as String;
                        print('Dish ID to delete: $_dish.user_id');
                        deleteToMenu(
                          context: context,
                          dishId: dishId,
                          userId: userId,
                          createdAt: DateTime.parse(widget.dishData['created_at']),
                        );
                        setState(() => isDeleted = true);
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
