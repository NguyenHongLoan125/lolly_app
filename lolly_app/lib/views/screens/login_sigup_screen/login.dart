import 'package:flutter/material.dart';
import 'package:lolly_app/models/auth_model.dart';
import 'package:lolly_app/views/screens/login_sigup_screen/auth_widgets.dart';

import '../../../controllers/authentication_controller.dart';
class LoginScreen extends StatefulWidget {

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passWordController = TextEditingController();
  @override
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

                btnText: 'Đăng nhập',
                emailController: emailController,
                passWordController: passWordController,
              )
          )
        )
    );
  }
}
