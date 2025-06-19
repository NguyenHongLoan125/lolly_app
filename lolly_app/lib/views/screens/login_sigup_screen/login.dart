import 'package:flutter/material.dart';
import 'package:lolly_app/models/auth_model.dart';
import 'package:lolly_app/views/screens/login_sigup_screen/auth_widgets.dart';

import '../../../controllers/auth_storage.dart';
import '../../../controllers/authentication_controller.dart';
class LoginScreen extends StatefulWidget {

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passWordController = TextEditingController();

  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  Future<void> _loadSavedCredentials() async {
    final creds = await AuthStorage.getSavedCredentials();
    if (creds.isNotEmpty) {
      setState(() {
        emailController.text = creds['email'] ?? '';
        passWordController.text = creds['password'] ?? '';
        _rememberMe = true;
      });
    }
  }

  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: AuthWidgets(
              authModel: AuthModel(
                  title: 'ĐĂNG NHẬP TÀI KHOẢN',
                  description: 'Chào mừng bạn!',
                  isRegister: false,
                  onButton: (){
                  AuthenticationController.logIn(
                    context: context,
                    email: emailController.text,
                    password: passWordController.text,
                  );

                },
                isRememberMe: _rememberMe,
                onRememberChanged: (value) {
                  setState(() {
                    _rememberMe = value ?? false;
                  });
                },
                btnText: 'Đăng nhập',
                emailController: emailController,
                passWordController: passWordController,
              )
          )
        )
    );
  }
}
