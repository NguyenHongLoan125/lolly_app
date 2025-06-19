import 'package:flutter/material.dart';
import 'package:lolly_app/controllers/category_controller.dart';
import 'package:lolly_app/router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:get/get.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://fajmrqekivpsntrdyklx.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZham1ycWVraXZwc250cmR5a2x4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDg2MjQxODUsImV4cCI6MjA2NDIwMDE4NX0.qP7fRO9HbRROLF-Rd0nJL9utUbC_PyRLn-VqFHbYcqU',
  );
  Get.put(CategoryController());
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
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      debugShowCheckedModeBanner: false,
      //home: SignUpScreen(),
      // initialBinding: BindingsBuilder(() {
      //   Get.put<CategoryController>(CategoryController());
      //
      // }),
      routerConfig: router,

    );
  }
}

