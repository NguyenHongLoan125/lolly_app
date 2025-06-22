import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:go_router/go_router.dart';
import 'package:lolly_app/views/screens/inner_screens/category_dish_screen.dart';
import 'package:lolly_app/views/screens/inner_screens/favorite_screen.dart';
import 'package:lolly_app/views/screens/inner_screens/posted_dish_screen.dart';
import 'package:lolly_app/views/screens/login_sigup_screen/login.dart';
import 'package:lolly_app/views/screens/main_screens.dart';
import 'package:lolly_app/views/screens/nav_screens/account_screen.dart';
import 'package:lolly_app/views/screens/nav_screens/add_dish_screen.dart';
import 'package:lolly_app/views/screens/nav_screens/calendar_screen.dart';
import 'package:lolly_app/views/screens/nav_screens/home_screen.dart';
import 'package:lolly_app/views/screens/nav_screens/shopping_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'models/catygory_models.dart';
import 'package:lolly_app/controllers/category_controller.dart';

Future<String?> _appRedirect(BuildContext context, GoRouterState state) async {
  final loggedIn = Supabase.instance.client.auth.currentUser != null;
  final isOnLoginPage = state.matchedLocation == '/login';

  if (!loggedIn) {
    return '/login';
  } else if (loggedIn && isOnLoginPage) {
    return '/home';
  }

  return null;
}
final GoRouter router = GoRouter(
  initialLocation: '/login',
  redirect: _appRedirect,
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    ShellRoute(
      builder: (context, state, child) => MainScreen(child: child),
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) =>  HomeScreen(),
        ),
        GoRoute(
          path: '/home/:categoryName',
          builder: (context, state) {
            final categoryName = state.pathParameters['categoryName']!;
            return FutureBuilder<CategoryModel?>(
              future: Get.find<CategoryController>().fetchCategoryByName(categoryName),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Scaffold(body: Center(child: CircularProgressIndicator()));
                }
                if (!snapshot.hasData) {
                  return const Scaffold(body: Center(child: Text("Không tìm thấy danh mục")));
                }
                return CategoryDishScreen(
                  categoryModel: snapshot.data!,
                  subCategoryName: null,
                );
              },
            );
          },
        ),
        GoRoute(
          path: '/home/:categoryName/:subCategoryName',
          builder: (context, state) {
            final categoryName = state.pathParameters['categoryName']!;
            final subCategoryName = state.pathParameters['subCategoryName']!;
            return FutureBuilder<CategoryModel?>(
              future: Get.find<CategoryController>().fetchCategoryByName(categoryName),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Scaffold(body: Center(child: CircularProgressIndicator()));
                }
                if (!snapshot.hasData) {
                  return const Scaffold(body: Center(child: Text("Không tìm thấy danh mục phụ")));
                }
                return CategoryDishScreen(
                  categoryModel: snapshot.data!,
                  subCategoryName: subCategoryName,
                );
              },
            );
          },
        ),
        GoRoute(
          path: '/calendar',
          pageBuilder: (context, state) =>  NoTransitionPage(child: CalendarScreen()),
        ),
        GoRoute(
          path: '/add',
          pageBuilder: (context, state) =>  NoTransitionPage(child: AddDishScreen()),
        ),
        GoRoute(
          path: '/shopping',
          pageBuilder: (context, state) =>  NoTransitionPage(child: ShoppingScreen()),
        ),
        GoRoute(
          path: '/account',
          pageBuilder: (context, state) => NoTransitionPage(child: AccountScreen()),
        ),

      ],
    ),
    GoRoute(
      path: '/favorites',
      builder: (context, state) => FavoriteScreen(),
    ),
    GoRoute(
      path: '/posted',
      builder: (context, state) => PostedDishScreen(),
    ),
  ],
  errorPageBuilder: (context, state) {
      return MaterialPage(
        key: state.pageKey,
        child: Scaffold(
          body: Center(
            child: Text(
              state.error.toString(),
            ),
          ),
        ),
      );
    },
);