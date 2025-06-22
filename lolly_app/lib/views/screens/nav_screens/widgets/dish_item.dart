import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lolly_app/controllers/menu_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DishItemWidget extends StatefulWidget {
  final Map<String, dynamic> dishData;

  const DishItemWidget({super.key, required this.dishData});

  @override
  State<DishItemWidget> createState() => _DishItemWidgetState();
}

class _DishItemWidgetState extends State<DishItemWidget> {
  late bool isLiked;
  late int likeCount;

  Map<String, dynamic> get _dish {
    return widget.dishData['dishes'] ?? widget.dishData;
  }

  @override
  void initState() {
    super.initState();
    isLiked = false;
    likeCount = int.tryParse(_dish['likes']?.toString() ?? '0') ?? 0;
    _checkIfLiked();
  }

  Future<void> _checkIfLiked() async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    final dishId = _dish['id'] as String?;

    if (userId == null || dishId == null) return;

    final response = await Supabase.instance.client
        .from('favorites')
        .select('id')
        .eq('user_id', userId)
        .eq('dish_id', dishId)
        .maybeSingle();

    setState(() {
      isLiked = response != null;
    });
  }

  Future<void> _toggleLike() async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    final dishId = _dish['id'] as String?;

    if (userId == null || dishId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bạn cần đăng nhập để yêu thích món ăn.')),
      );
      return;
    }

    if (isLiked) {
      await Supabase.instance.client
          .from('favorites')
          .delete()
          .eq('user_id', userId)
          .eq('dish_id', dishId);

      await Supabase.instance.client
          .from('dishes')
          .update({'likes': likeCount - 1})
          .eq('id', dishId);

      setState(() {
        isLiked = false;
        likeCount -= 1;
      });
    } else {
      await Supabase.instance.client.from('favorites').insert({
        'user_id': userId,
        'dish_id': dishId,
      });

      await Supabase.instance.client
          .from('dishes')
          .update({'likes': likeCount + 1})
          .eq('id', dishId);

      setState(() {
        isLiked = true;
        likeCount += 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final String dishName = _dish['dish_name'] ?? 'Món ăn chưa có tên';
    final String ingredient = _dish['ingredient'] ?? 'Chưa có nguyên liệu';
    final String imageUrl = _dish['image_url']?.toString().isNotEmpty == true
        ? _dish['image_url']
        : 'https://via.placeholder.com/120x100?text=No+Image';

    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF8F8),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFDBBF4E)),
        ),
        child: Row(
          children: [
            // Image Section
            Container(
              width: 120,
              height: 100,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFFECF5E3),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFF007400)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  imageUrl,
                  width: 110,
                  height: 90,
                  fit: BoxFit.fill,
                  errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.broken_image),
                ),
              ),
            ),

            const SizedBox(width: 20),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          dishName,
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

                  Text(
                    "Nguyên liệu: $ingredient",
                    style: GoogleFonts.lato(
                      fontSize: 13,
                      color: const Color(0xFF7F8E9D),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 10),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        final dishId = _dish['id'] as String?;
                        final userId =
                            Supabase.instance.client.auth.currentUser?.id;

                        if (userId == null || dishId == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Không thể xác định người dùng.')),
                          );
                          return;
                        }

                        final DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2024),
                          lastDate: DateTime(2030),
                          helpText: 'Chọn ngày thêm vào thực đơn',
                          confirmText: 'Thêm',
                          cancelText: 'Huỷ',
                        );

                        if (pickedDate != null) {
                          await addToMenu(
                            context: context,
                            dishId: dishId,
                            userId: userId,
                            menuDate: pickedDate,
                          );
                        }
                      },
                      icon: const Icon(Icons.add, size: 16),
                      label: const Text("Thêm vào thực đơn"),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(28),
                        backgroundColor: const Color(0xFF4CAF50),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        textStyle: GoogleFonts.lato(fontSize: 15),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}