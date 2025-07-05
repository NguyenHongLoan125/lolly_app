import 'package:flutter/material.dart';
void showCustomSnackbar(BuildContext context, String message) {
  final overlay = Overlay.of(context);
  final overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      bottom: 0, // ➜ trùng BottomNavigationBar
      left: 0,
      right: 0,
      child: Material(
        color: Colors.transparent,
        child: Container(
          height: 56,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.black87,
          ),
          child: Text(
            message,
            textAlign: TextAlign.left, // quan trọng
            style: const TextStyle(color: Colors.white),
          ),
        ),

      ),
    ),
  );

  overlay.insert(overlayEntry);

  Future.delayed(const Duration(seconds: 3)).then((_) => overlayEntry.remove());
}



class AnimatedSlideSnackbar extends StatefulWidget {
  final String message;
  const AnimatedSlideSnackbar({required this.message, Key? key}) : super(key: key);

  @override
  State<AnimatedSlideSnackbar> createState() => _AnimatedSlideSnackbarState();
}

class _AnimatedSlideSnackbarState extends State<AnimatedSlideSnackbar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetAnimation,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          widget.message,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
