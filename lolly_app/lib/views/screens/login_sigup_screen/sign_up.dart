import 'package:flutter/material.dart';
import 'package:lolly_app/controllers/authentication_controller.dart';
import 'package:lolly_app/models/auth_model.dart';
import 'package:lolly_app/views/screens/login_sigup_screen/auth_widgets.dart';
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _usernameController = TextEditingController();

  void _handleSignUp() {
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Mật khẩu và mật khẩu không khớp!"),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
      return ;
    }
    AuthenticationController.signUp(
      context: context,
      email: _emailController.text,
      password: _passwordController.text,
      username: _usernameController.text,
    );
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: AuthWidgets(
              authModel: AuthModel(
                  title: 'ĐĂNG KÝ TÀI KHOẢN',
                  description: 'Chào mừng bạn!',
                  isRegister: true,
                  onButton: _handleSignUp,
                  emailController: _emailController,
                  passWordController: _passwordController,
                  confirmPasswordController: _confirmPasswordController,
                  usernameController: _usernameController,
                  
                  btnText: 'Đăng ký',
              )
          ),
        )
    );
  }
}
