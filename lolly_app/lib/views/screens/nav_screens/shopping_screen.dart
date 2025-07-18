import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lolly_app/views/screens/nav_screens/widgets/week_selector.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
      checkedStatus = {}; // ✅ reset trước khi load mới
    });

    final newStatus = await fetchCheckedStatusFromPrefs(date);
    setState(() {
      checkedStatus = newStatus;
    });
  }

  Future<Map<String, bool>> fetchCheckedStatusFromPrefs(DateTime date) async {
    final prefs = await SharedPreferences.getInstance();
    final dateStr = date.toIso8601String().substring(0, 10);
    final allKeys = prefs.getKeys();

    final Map<String, bool> status = {};
    for (final key in allKeys) {
      if (key.endsWith('_$dateStr')) {
        status[key] = prefs.getBool(key) ?? false;
      }
    }
    return status;
  }

  void saveCheckedStatus({
    required String ingredientName,
    required bool isChecked,
    required DateTime date,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final dateStr = date.toIso8601String().substring(0, 10);
    final key = '${ingredientName}_$dateStr';
    await prefs.setBool(key, isChecked);
  }

  @override
  Widget build(BuildContext context) {
    final dateStr = selectedDate.toIso8601String().substring(0, 10);

    return Scaffold(
      backgroundColor: const Color(0xFFECF5E3),
      appBar: AppBar(
        backgroundColor: const Color(0xFFECF5E3),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF007400)),
          onPressed: () => context.go('/home'),
        ),
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
              decoration: const BoxDecoration(borderRadius: BorderRadius.only(
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
                            value: isChecked,
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