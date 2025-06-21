import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lolly_app/controllers/dish_controller.dart';
import 'package:lolly_app/views/screens/nav_screens/widgets/menu_dish_item.dart';
import 'package:lolly_app/views/screens/nav_screens/widgets/week_selector.dart';

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final DishController _dishController = DishController();
  Stream<List<Map<String, dynamic>>>? _dishesStream;

  @override
  void initState() {
    super.initState();
    _loadDishesByDate(DateTime.now());
  }

  void _loadDishesByDate(DateTime date) {
    setState(() {
      _dishesStream = _dishController.getDishesFromMenusByDate(date);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFECF5E3),
      appBar: AppBar(
        backgroundColor: const Color(0xFFECF5E3),
        title: const Text(
          "Thực đơn theo tuần",
          style: TextStyle(
            color: Color(0xFF007400),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          Image.asset('assets/logo.png', height: 70, width: 70),
        ],
        elevation: 0,
      ),
      body: Column(
        children: [
          WeekSelector(
            onDateSelected: (selectedDate) {
              _loadDishesByDate(selectedDate);
            },
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(32),
                  topLeft: Radius.circular(32),
                ),
                color: Colors.white,
              ),
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: StreamBuilder<List<Map<String, dynamic>>>(
                  stream: _dishesStream ?? const Stream.empty(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Center(
                        child: Text(
                          'Đã có lỗi xảy ra khi tải dữ liệu',
                          style: TextStyle(color: Colors.red),
                        ),
                      );
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final dishes = snapshot.data ?? [];

                    return ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: dishes.isEmpty ? 2 : dishes.length + 1,
                      itemBuilder: (context, index) {

                        if (dishes.isEmpty && index == 0) {
                          return const Padding(
                            padding: EdgeInsets.only(bottom: 16.0),
                            child: Text(
                              'Bạn chưa lựa chọn món ăn nào trong thực đơn ngày hôm nay.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          );
                        }

                        if (index < dishes.length) {
                          final dishData = dishes[index];
                          return Padding(
                            padding: const EdgeInsets.only(right: 12.0, bottom: 12),
                            child: MenuDishItemWidget(dishData: dishData),
                          );
                        }

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    context.go('/home');
                                  },
                                  icon: const Icon(Icons.add_circle),
                                  label: const Text("Thêm món", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF678A5D),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    // TODO: Xử lý gợi ý món
                                  },
                                  icon: const Icon(Icons.tips_and_updates),
                                  label: const Text("Gợi ý",style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF678A5D),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
