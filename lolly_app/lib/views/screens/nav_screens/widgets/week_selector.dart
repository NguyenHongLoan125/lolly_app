import 'package:flutter/material.dart';

class WeekSelector extends StatefulWidget {
  final void Function(DateTime selectedDate)? onDateSelected;

  const WeekSelector({super.key, this.onDateSelected});

  @override
  State<WeekSelector> createState() => _WeekSelectorState();
}

class _WeekSelectorState extends State<WeekSelector> {
  final List<String> days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  int selectedIndex = 0;
  late DateTime monday;


  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    monday = now.subtract(Duration(days: now.weekday - 1));
    selectedIndex = now.weekday - 1;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onDateSelected?.call(weekDates[selectedIndex]);
    });
  }

  List<DateTime> get weekDates =>
      List.generate(7, (index) => monday.add(Duration(days: index)));

  void previousWeek() {
    setState(() {
      monday = monday.subtract(const Duration(days: 7));
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onDateSelected?.call(weekDates[selectedIndex]);
    });
  }

  void nextWeek() {
    setState(() {
      monday = monday.add(const Duration(days: 7));
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onDateSelected?.call(weekDates[selectedIndex]);
    });
  }


  @override
  Widget build(BuildContext context) {
    final dates = weekDates;

    return Column(
      children: [
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios_new),
              onPressed: previousWeek,
            ),
            Column(
              children: [
                const Text("Tuần",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Text(
                  "${dates.first.day} - ${dates.last.day}/${dates.last.month}/${dates.last.year}",
                  style: const TextStyle(color: Colors.grey, fontSize: 20),
                ),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios_outlined),
              onPressed: nextWeek,
            ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 60,
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(days.length, (index) {
                final isSelected = index == selectedIndex;
                final date = dates[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });
                      widget.onDateSelected?.call(date);
                    },
                    child: Container(
                      width: 40,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF678A5D)
                            : const Color(0xFFDCEDD7),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            days[index],
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${date.day}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ],
    );
  }
}
