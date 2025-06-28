import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lolly_app/controllers/dish_controller.dart';
import 'package:lolly_app/views/screens/nav_screens/widgets/dish_item.dart';

class DraftScreen extends StatefulWidget {
  const DraftScreen({super.key});

  @override
  State<DraftScreen> createState() => _DraftScreenState();
}
class _DraftScreenState extends State<DraftScreen> {
  late final Stream<List<Map<String, dynamic>>> _dishesStream;
  final DishController _dishController = DishController();

  @override
  void initState() {
    super.initState();
    _dishesStream = _dishController.getMyDraftStream();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFECF5E3),
      appBar: AppBar(
        backgroundColor: const Color(0xFFECF5E3),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF007400)),
          onPressed: () => context.go('/account'),
        ),

        title: Text(
          "Bản lưu nháp",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF007400),
          ),
        ),
        centerTitle: true,

        actions: [
          Image.asset('assets/logo.png', height: 70, width: 70),
        ],
        elevation: 0,
      ),

      body: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Container(
          padding: const EdgeInsets.only(
            top: 16,
            left: 16,
            right: 16,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(32),
              topLeft: Radius.circular(32),
            ),
            color: Colors.white,
          ),
          alignment: Alignment.topCenter,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 20,
                ),
              ),

              StreamBuilder<List<Map<String, dynamic>>>(
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
                        print(dishData);
                        return Padding(
                          padding: const EdgeInsets.only(right: 12.0, bottom: 12),
                          child: DishItemWidget(dishData: dishData),
                        );

                      },
                      childCount: dishes.length,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),

    );
  }
}
