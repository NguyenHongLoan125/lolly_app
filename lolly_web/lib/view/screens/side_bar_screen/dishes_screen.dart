import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../models/dish_model.dart';
import '../../../controller/dish_controller.dart';
import '../../widgets/common_table.dart';
import '../detail_screens/dish_detail_screen.dart';

class DishesScreen extends StatefulWidget {
  static const String id = 'dish_screen';
  const DishesScreen({super.key});

  @override
  State<DishesScreen> createState() => _DishesScreenState();
}

class _DishesScreenState extends State<DishesScreen> {
  final DishController _dishController = DishController();
  List<DishModel> _dishes = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    fetchDishes();
  }

  Future<void> fetchDishes() async {
    final data = await _dishController.fetchAllDishes();
    setState(() {
      _dishes = data;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffECF5E3),
      appBar: AppBar(
        backgroundColor: const Color(0xffECF5E3),
        centerTitle: true,
        title: const Text(
          'QUẢN LÝ CÔNG THỨC',
          style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : CommonTable(
        columns: const ['STT', 'ID', 'Tên công thức', 'Ngày đăng', 'Hành động'],
        rows: _dishes.asMap().entries.map((entry) {
          final index = entry.key;
          final dish = entry.value;

          return [
            Text('${index + 1}', style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(dish.id ?? ''),
            Text(dish.dishName ?? ''),
            Text(
              dish.createdAt != null
                  ? DateFormat('HH:mm:ss   dd/MM/yyyy').format(dish.createdAt!)
                  : '',
            ),

            Row(
              children: [
                Tooltip(
                  message: 'Xem chi tiết',
                  child: IconButton(
                    icon: const Icon(Icons.visibility, color: Color(0xff007400)),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DishDetailScreen(dish: dish),
                        ),
                      );
                    },
                  ),
                ),
                Tooltip(
                  message: 'Xóa',
                  child: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text('Xác nhận xóa'),
                          content: Text('Bạn có chắc muốn xóa món "${dish.dishName}" không?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Hủy'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text('Xóa', style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                      );

                      if (confirm == true) {
                        final success = await _dishController.deleteDish(dish.id!);
                        if (success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Xóa món ăn thành công')),
                          );
                          fetchDishes(); // Cập nhật lại danh sách
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Xóa món ăn thất bại')),
                          );
                        }
                      }
                    },

                  ),
                ),
              ],
            )
          ];
        }).toList(),
      ),
    );
  }
}
