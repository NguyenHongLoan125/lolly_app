import 'package:flutter/material.dart';
import 'package:lolly_web/models/dish_model.dart';

class DishDetailScreen extends StatelessWidget {
  final DishModel dish;
  const DishDetailScreen({super.key, required this.dish});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffECF5E3),
      appBar: AppBar(
        backgroundColor: const Color(0xffECF5E3),
        centerTitle: true,
        elevation: 0,
        title: Text(
          dish.dishName ?? 'Chi tiết món ăn',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xff007400),
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xff007400)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 100,
                    backgroundColor: Colors.grey.shade300,
                    backgroundImage: dish.imageUrl != null && dish.imageUrl!.isNotEmpty
                        ? NetworkImage(dish.imageUrl!)
                        : null,
                    child: dish.imageUrl == null || dish.imageUrl!.isEmpty
                        ? const Icon(Icons.food_bank, size: 100, color: Colors.white)
                        : null,
                  ),
                ),
                const SizedBox(height: 24),

                _buildInfoRow('Số lượt thích', dish.likes?.toString()),
                _buildInfoRow('Thời gian nấu', dish.time),
                _buildInfoRow('Độ khó', dish.difficulty),
                _buildInfoRow('Khẩu phần', dish.people?.toString()),

                _buildInfoRow('Loại món', dish.types?.join(', ')),
                _buildInfoRow('Phong cách ẩm thực', dish.styles?.join(', ')),
                _buildInfoRow('Chế độ ăn', dish.diets?.join(', ')),


                const SizedBox(height: 16),
                const Text(
                  'Danh sách nguyên liệu:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                if (dish.ingredients != null && dish.ingredients!.isNotEmpty)
                  ...dish.ingredients!.map(
                        (ing) => Text(
                      '- ${ing.ingredientName ?? ''}: ${ing.ingredientQuantity ?? ''}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  )
                else
                  const Text('Không có nguyên liệu nào.'),

                const SizedBox(height: 24),
                _buildMultilineRow('Hướng dẫn', dish.cook),
                const SizedBox(height: 12),
                _buildMultilineRow('Ghi chú', dish.notes),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: RichText(
        text: TextSpan(
          text: '$label: ',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.black,
          ),
          children: [
            TextSpan(
              text: value ?? 'Không có',
              style: const TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildMultilineRow(String label, String? content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label:',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            content ?? 'Không có',
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }
}
