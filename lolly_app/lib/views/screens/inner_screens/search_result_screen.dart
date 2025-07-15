import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lolly_app/views/screens/nav_screens/widgets/dish_item.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SearchResultScreen extends StatefulWidget {
  final String keyword;

  const SearchResultScreen({Key? key, required this.keyword}) : super(key: key);

  @override
  State<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  final supabase = Supabase.instance.client;
  List<dynamic> _results = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _searchDishes(widget.keyword);
  }

  Future<void> _searchDishes(String keyword) async {
    final lowerKeyword = removeDiacritics(keyword.toLowerCase());

    // 1. Lấy tất cả món ăn
    final dishesResponse = await supabase.from('dishes').select();
    final List<Map<String, dynamic>> dishes = List<Map<String, dynamic>>.from(dishesResponse);

    // 2. Lấy tất cả nguyên liệu
    final ingredientsResponse = await supabase.from('ingredients').select();
    final List<Map<String, dynamic>> ingredients = List<Map<String, dynamic>>.from(ingredientsResponse);

    // 3. Lấy tất cả liên kết dish-ingredient
    final dishIngResponse = await supabase.from('dish_ingredients').select();
    final List<Map<String, dynamic>> dishIngredients = List<Map<String, dynamic>>.from(dishIngResponse);

    // 4. Lọc các món theo keyword
    final filtered = dishes.where((dish) {
      final dishName = removeDiacritics(dish['dish_name'].toString().toLowerCase());
      if (dishName.contains(lowerKeyword)) return true;

      // Lấy các nguyên liệu liên quan đến món này
      final relatedDishIngredients = dishIngredients.where(
            (di) => di['dish_id'] == dish['id'],
      );

      final containsInIngredients = relatedDishIngredients.any((di) {
        final ingId = di['ingredient_id'];
        final ing = ingredients.firstWhere(
              (i) => i['ingredient_id'] == ingId,
          orElse: () => {},
        );
        final ingName = removeDiacritics(ing['ingredient_name']?.toString().toLowerCase() ?? '');
        return ingName.contains(lowerKeyword);
      });

      return containsInIngredients;
    }).toList();

    // 5. Cập nhật kết quả
    setState(() {
      _results = filtered;
      _loading = false;
    });
  }



  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: const Color(0xFFECF5E3),
        appBar: AppBar(
          backgroundColor: const Color(0xFFECF5E3),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF007400)),
            onPressed: () {
              FocusScope.of(context).unfocus();
              context.pop(); // pop trong GoRouter để quay về
            },
          ),
          title: const Text(
            "Kết quả tìm kiếm",
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
        body: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(32),
                topLeft: Radius.circular(32),
              ),
              color: Colors.white,
            ),
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _results.isEmpty
                ? const Center(child: Text('Không tìm thấy món nào.'))
                : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView.builder(
                                itemCount: _results.length,
                                itemBuilder: (context, index) {
                  final dish = _results[index];
                  // return Padding(
                  //   padding: const EdgeInsets.only(right: 12.0, bottom: 12),
                  //   child: DishItemWidget(dishData: dish),
                  // );
                  return GestureDetector(
                    onTap: () {
                      context.push('/dish/${dish['id']}');
                      // print("chọn món có id: ");
                      // print(dish['id']);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 12.0, bottom: 20),
                      child: DishItemWidget(dishData: dish),
                    ),
                  );
                                },
                              ),
                ),
          ),
        ),
      ),
    );
  }
}
