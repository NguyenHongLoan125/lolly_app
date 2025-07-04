import 'package:flutter/material.dart';

import '../../../controllers/detail_dish_controller.dart';
import '../../../models/detail_dish_model.dart';

class DishDetailScreen extends StatefulWidget {
  final String dishId;
  const DishDetailScreen({super.key, required this.dishId});

  @override
  State<DishDetailScreen> createState() => _DishDetailScreenState();
}

class _DishDetailScreenState extends State<DishDetailScreen> {
  late Future<DetailDishModel?> _futureDish;

  @override
  void initState() {
    super.initState();
    _futureDish = DishDetailController().getDishDetail(widget.dishId);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),
      appBar: AppBar(
        title: const Text('Chi tiết món ăn'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: FutureBuilder<DetailDishModel?>(
        future: _futureDish,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('Không tìm thấy món ăn'));
          }

          final dish = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Ảnh món ăn
                if (dish.imageUrl != null && dish.imageUrl!.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      dish.imageUrl!,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                const SizedBox(height: 12),

                // Tác giả và biểu tượng
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text.rich(
                      TextSpan(
                        children: [
                          const TextSpan(
                            text: 'Tác giả: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: dish.author ?? ''),
                        ],
                      ),
                    ),
                    Row(
                      children: const [
                        Icon(Icons.favorite_border, color: Colors.red),
                        SizedBox(width: 12),
                        Icon(Icons.add_circle_outline, color: Colors.green),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Thời gian, độ khó, người ăn
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (dish.time != null)
                      Column(children: [
                        const Icon(Icons.schedule),
                        Text(dish.time!)
                      ]),
                    if (dish.difficulty != null)
                      Column(children: [
                        const Icon(Icons.fitness_center),
                        Text(dish.difficulty!)
                      ]),
                    if (dish.ration != null)
                      Column(children: [
                        const Icon(Icons.people),
                        Text('${dish.ration} người')
                      ]),
                  ],
                ),

                const SizedBox(height: 20),

                // Nguyên liệu
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE6F4EA),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Nguyên liệu:',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      if (dish.ingredients != null)
                        ...dish.ingredients!.map(
                              (e) => Text('- ${e.name}: ${e.quantity}'),
                        ),

                      const SizedBox(height: 12),
                      if (dish.cook != null) ...[
                        const Text('Cách chọn mua nguyên liệu:',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(dish.cook!),
                      ],

                      const SizedBox(height: 12),
                      if (dish.notes != null) ...[
                        const Text('Cách chế biến:',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(dish.notes!),
                      ]
                    ],
                  ),
                ),

                const SizedBox(height: 20),
                const Text('Lưu ý'),
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.orangeAccent),
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                  ),
                  child: const TextField(
                    maxLines: 4,
                    decoration:
                    InputDecoration.collapsed(hintText: 'Nhập ghi chú...'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
        ],
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
    )
    );
  }
}
