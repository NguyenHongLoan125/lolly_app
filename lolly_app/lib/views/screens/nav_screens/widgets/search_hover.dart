import 'package:flutter/material.dart';

class SearchHoverWidget extends StatefulWidget {
  @override
  _SearchHoverWidgetState createState() => _SearchHoverWidgetState();
}

class _SearchHoverWidgetState extends State<SearchHoverWidget> {
  bool _isHovering = false;
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Icon(
              Icons.search,
              size: 35,
              color: Color(0xFF007400),
            ),
          ),
          AnimatedContainer(
            duration: Duration(milliseconds: 200),
            width: _isHovering ? 200 : 0,
            curve: Curves.easeInOut,
            child: _isHovering
                ? TextField(
              controller: _controller,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Tìm món...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 8),
              ),
              onChanged: (value) {
                // TODO: thực hiện tìm kiếm dựa vào từ khóa
                print("Đang tìm: $value");
              },
            )
                : SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
