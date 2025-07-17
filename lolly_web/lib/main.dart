import 'package:flutter/material.dart';
import 'package:lolly_web/view/main_screen.dart';
import 'package:lolly_web/view/screens/login_screen/login_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://fajmrqekivpsntrdyklx.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZham1ycWVraXZwc250cmR5a2x4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDg2MjQxODUsImV4cCI6MjA2NDIwMDE4NX0.qP7fRO9HbRROLF-Rd0nJL9utUbC_PyRLn-VqFHbYcqU',
  );
  // runApp(const MyApp());
  final session = Supabase.instance.client.auth.currentSession;
  runApp(MyApp(isLoggedIn: session != null));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp({super.key, required this.isLoggedIn});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lolly Admin Website',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: isLoggedIn ? const MainScreen() : const LoginScreen(),
    );
  }
}

