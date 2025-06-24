import 'package:flutter/material.dart';
import 'package:lolly_app/controllers/category_controller.dart';
import 'package:lolly_app/router.dart';
import 'package:lolly_app/views/screens/nav_screens/add_dish_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:get/get.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'controllers/dish_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://fajmrqekivpsntrdyklx.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZham1ycWVraXZwc250cmR5a2x4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDg2MjQxODUsImV4cCI6MjA2NDIwMDE4NX0.qP7fRO9HbRROLF-Rd0nJL9utUbC_PyRLn-VqFHbYcqU',
  );
  Get.put(CategoryController());
  Get.put(DishController());
  usePathUrlStrategy();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Lolly',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      debugShowCheckedModeBanner: false,

      //home: AddDishScreen(),
      // initialBinding: BindingsBuilder(() {
      //   Get.put<CategoryController>(CategoryController());
      //
      // }),
      routerConfig: router,


    );
  }
}

