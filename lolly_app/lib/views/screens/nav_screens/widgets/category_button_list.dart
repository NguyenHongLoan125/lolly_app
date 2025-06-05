import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
class SubCategoryButtons extends StatefulWidget {
  final String categoryName;
  final void Function(String)? onSubCategorySelected;
  final String? selectedSubCategory; // thêm cái này

  const SubCategoryButtons({
    super.key,
    required this.categoryName,
    this.onSubCategorySelected,
    this.selectedSubCategory,
  });

  @override
  State<SubCategoryButtons> createState() => _SubCategoryButtonsState();
}

class _SubCategoryButtonsState extends State<SubCategoryButtons> {
  late String? selected;

  @override
  void initState() {
    super.initState();
    selected = widget.selectedSubCategory;
  }

  @override
  void didUpdateWidget(covariant SubCategoryButtons oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedSubCategory != widget.selectedSubCategory) {
      selected = widget.selectedSubCategory;
    }
  }

  Future<List<String>> fetchSubCategories(String categoryName) async {
    final List<Map<String, dynamic>> data = await Supabase.instance.client
        .from('sub_categories')
        .select('sub_category_name, categories!inner(category_name)')
        .eq('categories.category_name', categoryName);

    return data.map<String>((e) => e['sub_category_name'] as String).toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: fetchSubCategories(widget.categoryName),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }

        final subCategories = snapshot.data!;
        final allButtons = ["Tất cả", ...subCategories];

        return Row(
          children: allButtons.map((subCat) {
            final isSelected = selected == subCat || (selected == null && subCat == "Tất cả");

            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: OutlinedButton(
                onPressed: () {
                  setState(() {
                    selected = subCat == "Tất cả" ? null : subCat;
                  });
                  widget.onSubCategorySelected?.call(selected ?? "Tất cả");
                },
                style: OutlinedButton.styleFrom(
                  backgroundColor: isSelected ? Color(0xFF007400) : const Color.fromARGB(100, 0, 116, 0),
                  side: const BorderSide(color: Colors.white),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  subCat,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

}
