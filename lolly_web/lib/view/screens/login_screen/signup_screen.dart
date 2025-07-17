import 'package:flutter/material.dart';
import 'package:lolly_web/view/screens/login_screen/auth_widgets.dart';
import 'package:lolly_web/view/screens/login_screen/login_screen.dart';
import '../../../controller/auth_controller.dart';
import '../../../models/auth_model.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _usernameCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();

  bool _showEmailError = false;
  bool _showPasswordError = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _usernameCtrl.dispose();
    _confirmCtrl.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  String? _emailValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email không được để trống';
    }
    if (!value.contains('@')) {
      return 'Email không hợp lệ';
    }
    return null;
  }

  String? _passwordValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Mật khẩu không được để trống';
    }
    if (value.length < 6) {
      return 'Mật khẩu phải tối thiểu 6 ký tự';
    }
    return null;
  }

  String? _usernameValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Tên đăng nhập không được để trống';
    }
    return null;
  }

  String? _confirmValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Vui lòng xác nhận lại mật khẩu';
    }
    if (value != _passwordCtrl.text) {
      return 'Mật khẩu xác nhận không khớp';
    }
    return null;
  }

  void _submit() {
    final model = AuthModel(
      email: _emailCtrl.text.trim(),
      password: _passwordCtrl.text.trim(),
      username: _usernameCtrl.text.trim(),
      confirmPassword: _confirmCtrl.text.trim(),
    );

    AuthenticationController.signUp(
      context: context,
      email: model.email,
      password: model.password,
      username: model.username!,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthWidgets(
      title: 'ĐĂNG KÝ',
      isRegister: true,
      emailController: _emailCtrl,
      passwordController: _passwordCtrl,
      usernameController: _usernameCtrl,
      confirmPasswordController: _confirmCtrl,
      emailValidator: _emailValidator,
      passwordValidator: _passwordValidator,
      usernameValidator: _usernameValidator,
      confirmPasswordValidator: _confirmValidator,
      emailFocus: _emailFocus,
      passwordFocus: _passwordFocus,
      showEmailError: _showEmailError,
      showPasswordError: _showPasswordError,
      formKey: _formKey,
      btnText: 'Tạo tài khoản',
      onSubmit: () {
        setState(() {
          _showEmailError = true;
          _showPasswordError = true;
        });

        if (_formKey.currentState!.validate()) {
          _submit();
        }
      },
      footer: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Đã có tài khoản?",
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold
            ),
          ),
          TextButton(
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              foregroundColor: const Color(0xff007400),
            ).copyWith(
              overlayColor: WidgetStateProperty.all(Colors.transparent),
              foregroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.hovered)) {
                  return Colors.white;
                }
                return const Color(0xff007400);
              }),
            ),
            onPressed: () {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context)=>LoginScreen())
              );
            },
            child: const Text(
              "Đăng nhập",
              style: TextStyle(
                  color: Color(0xff007400),
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold
              ),
            ),
          ),
        ],
      ),
    );
  }
}
