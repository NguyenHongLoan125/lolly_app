import 'package:flutter/material.dart';
import 'package:lolly_web/view/screens/login_screen/auth_widgets.dart';
import 'package:lolly_web/view/screens/login_screen/signup_screen.dart';
import '../../../controller/auth_controller.dart';
import '../../../models/auth_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  bool _showEmailError = false;
  bool _showPasswordError = false;

  @override
  void initState() {
    super.initState();

    _emailFocus.addListener(() {
      if (_emailFocus.hasFocus) {
        setState(() => _showEmailError = false);
      }
    });

    _passwordFocus.addListener(() {
      if (_passwordFocus.hasFocus) {
        setState(() => _showPasswordError = false);
      }
    });
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
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

  void _submit() {
    final model = AuthModel(
      email: _emailCtrl.text.trim(),
      password: _passwordCtrl.text.trim(),
    );

    AuthenticationController.logIn(
      context: context,
      email: model.email,
      password: model.password,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthWidgets(
      title: 'ĐĂNG NHẬP',
      isRegister: false,
      emailController: _emailCtrl,
      passwordController: _passwordCtrl,
      emailValidator: _emailValidator,
      passwordValidator: _passwordValidator,
      onSubmit: () {
        setState(() {
          _showEmailError = true;
          _showPasswordError = true;
        });

        if (_emailValidator(_emailCtrl.text) == null &&
            _passwordValidator(_passwordCtrl.text) == null) {
          _submit();
        }
      },
      btnText: 'Đăng nhập',
      emailFocus: _emailFocus,
      passwordFocus: _passwordFocus,
      showEmailError: _showEmailError,
      showPasswordError: _showPasswordError,
      formKey: _formKey,
      footer: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Chưa có tài khoản?",
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
                  context, MaterialPageRoute(builder: (context)=>SignupScreen())
              );
            },
            child: const Text(
                "Đăng ký",
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
