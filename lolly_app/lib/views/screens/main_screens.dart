import 'package:flutter/material.dart';
import 'package:lolly_app/views/screens/nav_screens/account_screen.dart';
import 'package:lolly_app/views/screens/nav_screens/add_dish_screen.dart';
import 'package:lolly_app/views/screens/nav_screens/calendar_screen.dart';
import 'package:lolly_app/views/screens/nav_screens/home_screen.dart';
import 'package:lolly_app/views/screens/nav_screens/shopping_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _pageIndex = 0;
  final  List<Widget> _pages = [
    HomeScreen(),
    CalendarScreen(),
    AddDishScreen(),
    ShoppingScreen(),
    AccountScreen()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      //Thanh Menu
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: const Color(0xFFECF5E3),
          currentIndex: _pageIndex,
          onTap: (value) {
            setState(() {
              _pageIndex = value;
            });
          },
          selectedItemColor: const Color(0xFF007400),
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Trang chủ'),
            BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Lịch'),
            BottomNavigationBarItem(icon: SizedBox.shrink(), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Đi chợ'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Tài khoản'),
          ],
        ),
      ),

      // Thêm công thức
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: SizedBox(
        height: 70,
        width: 70,
        child: FloatingActionButton(
          onPressed: () {
            setState(() {
              _pageIndex = 2;
            });
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
      body: _pages[_pageIndex],

    );
  }
}
