import 'package:flutter/material.dart';
import 'package:lolly_app/views/screens/nav_screens/widgets/week_selector.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../models/ingredient_model.dart';

class ShoppingScreen extends StatefulWidget {
  const ShoppingScreen({super.key});

  @override
  State<ShoppingScreen> createState() => _ShoppingScreenState();
}

class _ShoppingScreenState extends State<ShoppingScreen> {
  Future<List<Ingredient>>? futureIngredients;
  Map<String, bool> checkedStatus = {}; // key: '${name}_$date'
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadIngredientsAndChecked(DateTime.now());
  }

  void _loadIngredientsAndChecked(DateTime date) async {
    setState(() {
      selectedDate = date;
      futureIngredients = fetchIngredientsByDate(date);
    });

    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    final dateStr = date.toIso8601String().substring(0, 10);

    try {
      final response = await Supabase.instance.client
          .from('checked_ingredients')
          .select()
          .eq('user_id', user.id)
          .eq('date', dateStr);

      final Map<String, bool> newStatus = {};
      for (final item in response) {
        final name = item['ingredient_name'];
        final isChecked = item['is_checked'] ?? false;
        newStatus['${name}_$dateStr'] = isChecked;
      }

      setState(() {
        checkedStatus = newStatus;
      });
    } catch (e) {
      print('Lỗi khi tải trạng thái check: $e');
    }
  }

  void saveCheckedStatus({
    required String ingredientName,
    required bool isChecked,
    required DateTime date,
  }) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    final dateStr = date.toIso8601String().substring(0, 10);

    try {
      await Supabase.instance.client
          .from('checked_ingredients')
          .upsert({
        'user_id': user.id,
        'ingredient_name': ingredientName,
        'is_checked': isChecked,
        'date': dateStr,
      }, onConflict: 'user_id, ingredient_name, date');
    } catch (e) {
      print('Lỗi khi lưu trạng thái: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateStr = selectedDate.toIso8601String().substring(0, 10);

    return Scaffold(
      backgroundColor: const Color(0xFFECF5E3),
      appBar: AppBar(
        backgroundColor: const Color(0xFFECF5E3),
        title: const Text(
          "Danh sách đi chợ",
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
              _loadIngredientsAndChecked(selectedDate);
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
              child: FutureBuilder<List<Ingredient>>(
                future: futureIngredients,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Lỗi: ${snapshot.error}'),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text(
                        "Danh sách nguyên liệu trống",
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    );
                  }

                  final ingredients = snapshot.data!;

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: ingredients.length,
                    itemBuilder: (context, index) {
                      final ingredient = ingredients[index];
                      final key = '${ingredient.name}_$dateStr';
                      final isChecked = checkedStatus[key] ?? false;

                      return StatefulBuilder(
                        builder: (context, setStateItem) {
                          return CheckboxListTile(
                            title: Text(
                              '${ingredient.name}: ${ingredient.quantity}',
                              style: const TextStyle(fontSize: 20),
                            ),
                            value: checkedStatus[key] ?? false,
                            onChanged: (value) {
                              setState(() {
                                checkedStatus[key] = value!;
                              });

                              saveCheckedStatus(
                                ingredientName: ingredient.name,
                                isChecked: value!,
                                date: selectedDate,
                              );
                            },
                            controlAffinity: ListTileControlAffinity.leading,
                            visualDensity: const VisualDensity(vertical: -3),
                          );

                        },
                      );
                    },
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
