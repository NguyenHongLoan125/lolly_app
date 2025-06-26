import 'package:flutter/material.dart';
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
    final lowerKeyword = keyword.toLowerCase();

    // Lấy tất cả món ăn
    final dishesResponse = await supabase.from('dishes').select();
    final dishes = dishesResponse as List;

    // Lấy tất cả nguyên liệu
    final ingredientsResponse = await supabase.from('ingredients').select();
    final ingredients = ingredientsResponse as List;

    // Tìm món ăn theo tên hoặc nguyên liệu
    final filtered = dishes.where((dish) {
      final dishName = dish['dish_name'].toString().toLowerCase();
      final relatedIngredients = ingredients.where(
            (ing) => ing['dish_id'] == dish['id'],
      );

      final containsInIngredients = relatedIngredients.any(
            (ing) => ing['ingredient_name'].toString().toLowerCase().contains(lowerKeyword),
      );

      return dishName.contains(lowerKeyword) || containsInIngredients;
    }).toList();

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
                  return Padding(
                    padding: const EdgeInsets.only(right: 12.0, bottom: 12),
                    child: DishItemWidget(dishData: dish),
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
