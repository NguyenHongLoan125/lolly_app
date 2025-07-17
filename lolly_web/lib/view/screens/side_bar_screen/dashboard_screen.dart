import 'package:flutter/material.dart';
import 'package:lolly_web/controller/dashboard_controller.dart';
import 'package:lolly_web/view/widgets/block_widgets.dart';
import '../../../models/dashboard_model.dart';
import '../detail_screens/charts/pie_chart.dart';

class DashboardScreen extends StatefulWidget {
  static const String id = 'dashboard_screen';
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _controller = DashBoardController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffECF5E3),
      appBar: AppBar(
        backgroundColor: const Color(0xffECF5E3),
        centerTitle: true,
        title: const Text(
          'TỔNG QUAN',
          style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder<List<BlockModel>>(
        future: _controller.fetchStats(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No data available."));
          }

          final stats = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Block widgets
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: stats.map((block) {
                      final int count = stats.length;
                      final double screenWidth = MediaQuery.of(context).size.width;
                      final double padding = 32;
                      final double spacing = 12 * (count - 1);
                      final double itemWidth = (screenWidth - padding - spacing) / count;

                      return SizedBox(
                        width: itemWidth,
                        child: BlockWidgets(
                          block: block,
                          gradientColors: block.title.contains("member")
                              ? [Colors.pink, Colors.purple]
                              : [Colors.greenAccent, Colors.green],
                        ),
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(height: 24),

                // 2. Pie Chart Section
                const Text(
                  "Danh mục công thức",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 8,
                        color: Colors.black12,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const PieChartView(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
