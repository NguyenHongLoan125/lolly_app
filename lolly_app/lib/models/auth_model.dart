import 'package:flutter/material.dart';

class AuthModel {
  final String title;
  final String description;
  final bool isRegister;
  final String btnText;
  final VoidCallback onButton;
  final bool ? isRememberMe;
  final Function(bool?)? onRememberChanged;

  final TextEditingController emailController;
  final TextEditingController passWordController;
  final TextEditingController? usernameController;
  final TextEditingController? confirmPasswordController;

  const AuthModel({
    required this.title,
    required this.description,
    required this.isRegister,
    required this.onButton,
    required this.btnText,
    required this.emailController,
    required this.passWordController,
    this.confirmPasswordController,
    this.usernameController,
    required this.isRememberMe,
    required this.onRememberChanged,

  });
}



