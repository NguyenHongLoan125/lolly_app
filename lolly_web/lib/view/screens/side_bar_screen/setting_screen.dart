import 'package:flutter/material.dart';


class SettingScreen extends StatefulWidget {
  static const String id = 'setting_screen';
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: Center(
            child: Text('Setting'),
          ),
        )
    );
  }
}