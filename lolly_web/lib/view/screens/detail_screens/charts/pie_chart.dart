import 'package:flutter/material.dart';
import 'package:lolly_web/controller/dashboard_controller.dart';
import 'package:lolly_web/models/dashboard_model.dart';
import 'package:lolly_web/view/widgets/pie_chart_widgets.dart';

class PieChartView extends StatefulWidget {
  const PieChartView({super.key});

  @override
  State<PieChartView> createState() => _PieChartViewState();
}

class _PieChartViewState extends State<PieChartView> {
  final _controller = DashBoardController();
  List<Category> _categories = [];
  int? _selectedCategoryId;
  Map<String, int> _chartData = {};

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final categories = await _controller.fetchCategories();
    setState(() {
      _categories = categories;
      if (categories.isNotEmpty) {
        _selectedCategoryId = categories.first.id;
      }
    });
    _loadChartData();
  }

  Future<void> _loadChartData() async {
    if (_selectedCategoryId == null) return;
    final subCategories = await _controller.fetchSubCategoriesByCategory(_selectedCategoryId!);
    final data = <String, int>{};
    for (final sub in subCategories) {
      final name = sub.name ?? 'Không rõ';
      data[name] = (data[name] ?? 0) + 1;
    }
    setState(() {
      _chartData = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButton<int>(
          value: _selectedCategoryId,
          isExpanded: true,
          items: _categories.map((cat) {
            return DropdownMenuItem<int>(
              value: cat.id,
              child: Text(cat.name ?? 'Không rõ'),
            );
          }).toList(),
          onChanged: _categories.isEmpty
              ? null
              : (value) {
            setState(() {
              _selectedCategoryId = value;
            });
            _loadChartData();
          },
        ),
        const SizedBox(height: 16),
        _chartData.isEmpty
            ? const Center(child: Text("Không có dữ liệu"))
            : PieChartWidget(data: _chartData),
      ],
    );
  }
}
