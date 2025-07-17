import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:lolly_web/view/screens/side_bar_screen/dashboard_screen.dart';
import 'package:lolly_web/view/screens/side_bar_screen/dishes_screen.dart';
import 'package:lolly_web/view/screens/side_bar_screen/setting_screen.dart';
import 'package:lolly_web/view/screens/side_bar_screen/users_screen.dart';
import 'package:lolly_web/controller/navigation_controller.dart';




class MainScreen extends StatefulWidget {
  static const String id = 'main-screen';
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String _selectedRoute = MainScreen.id;
  OverlayEntry ? overlayEntry;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: AdminScaffold(appBar: AppBar(
          backgroundColor: Color(0xff007400),
          title: const Text(
            "Trang quản lý cho Admin ",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.account_circle, color: Colors.white),
              onPressed: () {
                NavigationController().getUserProfile(context);
              },
            ),

            IconButton(
              icon: const Icon(Icons.logout, color: Colors.white),
              onPressed: () {
                NavigationController().showLogoutDialog(context);
              },
            ),

          ],
        ),

        //side bar
            sideBar: SideBar(
              header: Container(
                height: 50,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xffCCFF98),
                ),
              ),
              footer: Container(
                height: 50,
                width: double.infinity,
                color: Color(0xffCCFF98),
                child: Center(
                ),
              ),
              items: const [
                AdminMenuItem(
                  title: 'Bảng điều khiển',
                  route: DashboardScreen.id,
                  icon: Icons.dashboard,
                ),
                AdminMenuItem(
                  title: 'Người dùng',
                  route: UsersScreen.id,
                  icon: Icons.person,
                ),
                AdminMenuItem(
                  title: 'Món ăn',
                  route: DishesScreen.id,
                  icon: Icons.restaurant,
                ),
                AdminMenuItem(
                  title: 'Cài đặt',
                  route: SettingScreen.id,
                  icon: Icons.settings,
                ),
              ],
              selectedRoute: _selectedRoute,
              onSelected: (item) {
                if (item.route != null) {
                  setState(() {
                    _selectedRoute = item.route!;
                  });
                }
              },

            ),


        body:  _buildBody(_selectedRoute),
        )
    );
  }
  Widget _buildBody(String route) {
    switch (route) {
      // case DashboardScreen.id:
      //   return const DashboardScreen();
      case UsersScreen.id:
        return const UsersScreen();
      case DishesScreen.id:
        return const DishesScreen();
      case SettingScreen.id:
        return const SettingScreen();
      default:
        // return const Center(child: Text('Dashboard'));
        return const DashboardScreen();
    }
  }

}
