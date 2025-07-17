import 'package:flutter/material.dart';

class CommonTable extends StatelessWidget {
  final List<String> columns;
  final List<List<Widget>> rows;

  const CommonTable({
    super.key,
    required this.columns,
    required this.rows,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: columns.map((title) => DataColumn(label: Text(title,style: TextStyle(fontWeight: FontWeight.bold),))).toList(),
        rows: rows.map((cells) {
          return DataRow(cells: cells.map((cell) => DataCell(cell)).toList());
        }).toList(),
      ),
    );
  }
}
