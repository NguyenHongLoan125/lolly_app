import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lolly_app/controllers/dish_controller.dart';
import 'package:lolly_app/controllers/menu_controller.dart';
import 'package:lolly_app/views/screens/nav_screens/widgets/dish_item.dart';
import 'package:lolly_app/views/screens/nav_screens/widgets/menu_dish_item.dart';
import 'package:lolly_app/views/screens/nav_screens/widgets/week_selector.dart';

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final DishController _dishController = DishController();
  Stream<List<Map<String, dynamic>>>? _dishesStream;
  DateTime selectedDate = DateTime.now();

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
            onDateSelected: (date) {
              setState(() {
                selectedDate = date;
                _loadDishesByDate(date);
              });
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
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      backgroundColor: Colors.white,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                                      ),
                                      builder: (context) {
                                        return SizedBox(
                                          height: MediaQuery.of(context).size.height * 0.8,
                                          child: Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: StreamBuilder<List<Map<String, dynamic>>>(
                                              stream: _dishController.getFavoriteDishesStream(),
                                            builder: (context, snapshot) {
                                                if (snapshot.hasError) {
                                                  return const Center(child: Text('Lỗi khi tải dữ liệu.'));
                                                }

                                                if (snapshot.connectionState == ConnectionState.waiting) {
                                                  return const Center(child: CircularProgressIndicator());
                                                }

                                                final dishes = snapshot.data ?? [];
                                                print(">>> Dishes nhận được: $dishes");

                                                if (dishes.isEmpty) {
                                                  return const Center(child: Text('Không có món ăn nào.'));
                                                }

                                                return ListView.builder(
                                                  itemCount: dishes.length,
                                                  itemBuilder: (context, index) {
                                                    final rawDish = dishes[index];
                                                    final dishData = rawDish['dishes'] ?? rawDish; // hỗ trợ cả khi dishData là raw


                                                    return Padding(
                                                      padding: const EdgeInsets.only(bottom: 8.0),
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          Navigator.pop(context);
                                                          print("Bạn đã chọn món: ${dishData['dish_name']}");
                                                          addToMenu(
                                                            context: context,
                                                            dishId: dishData['id'],
                                                            userId: dishData['user_id'],
                                                            menuDate: selectedDate,
                                                          );
                                                          _loadDishesByDate(selectedDate);
                                                        },
                                                        child: DishItemWidget(dishData: dishData),
                                                      ),
                                                    );
                                                  },
                                                );

                                            },
                                            ),
                                          ),
                                        );
                                      },
                                    );
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
