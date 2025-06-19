import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainScreen extends StatelessWidget {
  final Widget child;

  const MainScreen({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    final String location = GoRouter
        .of(context)
        .routerDelegate
        .currentConfiguration
        .uri
        .toString();
    int currentIndex = 0;

    if (location.contains('/calendar')) {
      currentIndex = 1;
    } else if (location.contains('/add')) {
      currentIndex = 2;
    } else if (location.contains('/shopping')) {
      currentIndex = 3;
    } else if (location.contains('/account')) {
      currentIndex = 4;
    } else {
      currentIndex = 0;
    }

    return Stack(
      children: [
        Scaffold(
          body: child,
          bottomNavigationBar: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              backgroundColor: const Color(0xFFECF5E3),
              currentIndex: currentIndex,
              onTap: (value) {
                switch (value) {
                  case 0:
                    context.go('/home');
                    break;
                  case 1:
                    context.go('/calendar');
                    break;
                  case 2:
                    context.go('/add');
                    break;
                  case 3:
                    context.go('/shopping');
                    break;
                  case 4:
                    context.go('/account');
                    break;
                }
              },
              selectedItemColor: const Color(0xFF007400),
              unselectedItemColor: Colors.grey,
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(Icons.home), label: 'Trang chủ'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.calendar_today), label: 'Lịch'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.add, color: Colors.transparent),
                    label: ''),
                BottomNavigationBarItem(
                    icon: Icon(Icons.shopping_cart), label: 'Đi chợ'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.person), label: 'Tài khoản'),
              ],
            ),
          ),
        ),

        Positioned(
          bottom: 50,
          left: MediaQuery.of(context).size.width / 2 - 35,
          child: SizedBox(
            height: 70,
            width: 70,
            child: FloatingActionButton(
              onPressed: () {
                context.go('/add');
              },
              backgroundColor: const Color(0xFF007400),
              shape: const CircleBorder(),
              child: const Icon(
                Icons.add,
                size: 50,
                color: Colors.white,
              ),
            ),
          ),
        ),

      ],
    );
  }
}