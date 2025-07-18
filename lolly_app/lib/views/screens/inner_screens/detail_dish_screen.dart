import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lolly_app/controllers/menu_controller.dart';
import '../../../controllers/detail_dish_controller.dart';
import '../../../models/detail_dish_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:lolly_app/controllers/dish_controller.dart';
import 'package:lolly_app/models/dish_model.dart';


class DishDetailScreen extends StatefulWidget {
  final String dishId;
  const DishDetailScreen({super.key, required this.dishId});

  @override
  State<DishDetailScreen> createState() => _DishDetailScreenState();
}

class _DishDetailScreenState extends State<DishDetailScreen> {
  bool isLiked = false;
  int likeCount = 0;
  late DishController _controller;
  late DishModel _dish;

  late Future<DetailDishModel?> _futureDish;

  @override
  void initState() {
    super.initState();
    _controller = DishController();
    _futureDish = DishDetailController().getDishDetail(widget.dishId);

    fetchDish();
  }

  Future<void> fetchDish() async {
    _dish = await _controller.fetchDishById(widget.dishId);
    likeCount = _dish.likes;
    await _checkIfLiked();
    setState(() {});
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
      final success = await _controller.likeDish(userId, _dish);
      if (success) {
        setState(() {
          isLiked = true;
          likeCount += 1;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Không thể yêu thích món ăn này.')),
        );
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: FutureBuilder<DetailDishModel?>(
        future: _futureDish,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('Không tìm thấy món ăn'));
          }

          final dish = snapshot.data!;
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                backgroundColor: const Color(0xFFFFFFFF),
                title: Text(
                  'Chi tiết món ăn',
                  style: const TextStyle(
                    color: Color(0xff007400),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                centerTitle: true,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: Color(0xff007400)),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),

              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (dish.imageUrl != null && dish.imageUrl!.isNotEmpty)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(0),
                        child: Image.network(
                          dish.imageUrl!,
                          height: 250,
                          width: double.infinity,
                          fit: BoxFit.fill,
                        ),
                      ),
                    const SizedBox(height: 12),

                    // Tác giả + hành động
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            dish.dishName ?? '',
                            style: const TextStyle(
                              color: Color(0xff007400),
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 12),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text.rich(
                                TextSpan(
                                  children: [
                                    const TextSpan(
                                      text: 'Tác giả: ',
                                      style:
                                      TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    TextSpan(text: dish.author ?? ''),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: _toggleLike,
                                    child: Icon(
                                      isLiked ? Icons.favorite : Icons.favorite_border,
                                      color: Colors.red,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  GestureDetector(
                                    onTap: () async {
                                      final dishId = _dish.id as String?;
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
                                    child: const Icon(Icons.add_circle_outline, color: Color(0xff007400)),
                                  ),
                                ],
                              ),

                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Thông tin tổng quan (time, độ khó, khẩu phần)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            if (dish.time != null)
                              _infoIconFromAsset('assets/icons/time.png', dish.time!),
                            if (dish.difficulty != null)
                              _infoIconFromAsset('assets/icons/level.png', dish.difficulty!),
                            if (dish.people != null)
                              _infoIconFromAsset('assets/icons/people.png', '${dish.people} người'),
                            if (dish.types != null)
                              ...dish.types!.map((e) => _infoIconFromAsset('assets/icons/category.png', e)),
                            if (dish.styles != null)
                              ...dish.styles!.map((e) => _infoIconFromAsset('assets/icons/nation.png', e)),
                            if (dish.diets != null)
                              ...dish.diets!.map((e) => _infoIconFromAsset('assets/icons/healthy.png', e)),
                          ].expand((widget) => [
                            Padding(
                              padding: const EdgeInsets.only(right: 16.0),
                              child: widget,
                            )
                          ]).toList(),
                        ),
                      ),
                    ),




                    const SizedBox(height: 20),

                    // Nguyên liệu + cách chọn + chế biến
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFECF5E3),
                          border: Border.all(color: const Color(0xFF007400)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Nguyên liệu:',
                                style:
                                TextStyle(fontWeight: FontWeight.bold)),
                            if (dish.ingredients != null)
                              ...dish.ingredients!
                                  .map((e) =>
                                  Text('- ${e.name}: ${e.quantity}'))
                                  .toList(),

                            const SizedBox(height: 12),
                            if (dish.cook != null) ...[
                              const Text('Hướng dẫn chế biến:',
                                  style:
                                  TextStyle(fontWeight: FontWeight.bold)),
                              Text(dish.cook!),
                            ],

                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Lưu ý (từ notes, không phải nhập tay)
                    if (dish.notes != null && dish.notes!.trim().isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Lưu ý:',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16)),
                            const SizedBox(height: 8),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.orangeAccent),
                                borderRadius: BorderRadius.circular(8),
                                color: Color(0xffFFF8F8),
                              ),
                              child: Text(
                                dish.notes!,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _infoIcon(IconData icon, String text) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: Colors.white,
          child: Icon(icon, color: Colors.black),
        ),
        const SizedBox(height: 4),
        Text(text),
      ],
    );
  }
}

Widget _infoIconFromAsset(String assetPath, String text) {
  return Column(
    children: [
      CircleAvatar(
        backgroundColor: Colors.white,
        radius: 35,
        child: ClipOval(
          child: Image.asset(
            assetPath,
            width: 80,
            height: 80,
            fit: BoxFit.contain,
          ),
        ),
      ),
      const SizedBox(height: 4),
      SizedBox(
        width: 72,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 12),
        ),
      ),
    ],
  );
}

