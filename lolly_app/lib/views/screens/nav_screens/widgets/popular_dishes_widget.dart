import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lolly_app/controllers/dish_controller.dart';
import 'package:lolly_app/views/screens/inner_screens/detail_dish_screen.dart';
import 'package:lolly_app/views/screens/nav_screens/widgets/dish_item.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PopularDishesWidget extends StatefulWidget {
  const PopularDishesWidget({super.key});

  @override
  State<PopularDishesWidget> createState() => _PopularDishesWidgetState();
}

class _PopularDishesWidgetState extends State<PopularDishesWidget> {
  late final Stream<List<Map<String, dynamic>>> _dishesStream;
  final DishController _dishController = DishController();

  @override
  void initState() {
    super.initState();
    _dishesStream = _dishController.getPopularDishes();
  }


  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _dishesStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return SliverToBoxAdapter(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Đã có lỗi xảy ra khi tải sản phẩm.\nVui lòng thử lại sau.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SliverToBoxAdapter(
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const SliverToBoxAdapter(
            child: Center(child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('Hiện chưa có sản phẩm nào.'),
            )),
          );
        }

        final dishes = snapshot.data!;

        return SliverList(
          delegate: SliverChildBuilderDelegate(
                (context, index) {
              final dishData = dishes[index];

              return GestureDetector(
                onTap: () {
                  context.push('/dish/${dishData['id']}');
                },
                child: Padding(
                  padding: EdgeInsets.only(
                    right: 12.0,
                    bottom: index == dishes.length - 1 ? 40 : 20,
                  ),
                  child: DishItemWidget(dishData: dishData),
                ),
              );
            },
            childCount: dishes.length,
          ),
        );
      },
    );
  }
}
