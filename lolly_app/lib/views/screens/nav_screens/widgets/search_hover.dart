import 'package:flutter/material.dart';
import 'package:lolly_app/views/screens/inner_screens/search_result_screen.dart';

class SearchTapWidget extends StatefulWidget {
  @override
  _SearchTapWidgetState createState() => _SearchTapWidgetState();
}

class _SearchTapWidgetState extends State<SearchTapWidget> {
  bool _isSearching = false;
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        setState(() {
          _isSearching = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }
  void _goToSearchResult() {
    final keyword = _controller.text.trim();
    if (keyword.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SearchResultScreen(keyword: keyword),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: _isSearching
          ? Container(
        decoration: BoxDecoration(
          color: Color(0xFFECF5E3),
          border: Border.all(color: Color(0xFF007400), width: 1),
          borderRadius: BorderRadius.circular(100),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: Duration(milliseconds: 200),
              width: 200,
              curve: Curves.easeInOut,
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                autofocus: true,
                onSubmitted: (_) => _goToSearchResult(), // Nhấn Enter sẽ chuyển trang
                decoration: InputDecoration(
                  hintText: 'Tìm món...',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 8),
                ),
                onChanged: (value) {
                  print("Đang tìm: $value");
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: IconButton(
                icon: Icon(Icons.search, color: Color(0xFF007400), size: 25),
                onPressed: _goToSearchResult, // Nhấn nút cũng chuyển trang
              ),

            ),
          ],
        ),
      )
          : IconButton(
        icon: Icon(Icons.search, color: Color(0xFF007400), size: 30),
        onPressed: () {
          setState(() {
            _isSearching = true;
          });
        },
      ),
    );
  }
}
