
import 'package:flutter/material.dart';
import 'package:lolly_app/controllers/forgot_password_controller.dart';
import 'package:lolly_app/views/screens/forgot_password/forgot_pasword_widgets.dart';
import 'package:lolly_app/views/screens/forgot_password/vertification_screen.dart';
import 'package:lolly_app/views/screens/login_sigup_screen/login.dart';

class InputEmailScreen extends StatefulWidget {
  const InputEmailScreen({super.key});

  @override
  State<InputEmailScreen> createState() => _InputEmailScreenState();
}

class _InputEmailScreenState extends State<InputEmailScreen> {
  final _formkey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: CustomAppBar(backPage: LoginScreen()),
          body: Container(
            width: double.infinity,
            height: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 70),
            color: Color.fromRGBO(204, 255, 152, 1),
            child: SingleChildScrollView(
              child: Center(
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Color(0xFF343632).withAlpha((255*0.3).toInt()),
                    borderRadius: BorderRadius.circular(30)
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 15,),
                      Form(
                        key: _formkey,
                        child: Column(
                          children: [
                            AddLogo(),
                            const SizedBox(height: 20,),
                            CreateScreen(
                                description: 'Nhập email để lấy lại mật khẩu',
                                content: (context,controller){
                                  return TextFormField(
                                    controller: _emailController,
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600
                                    ),
                                    decoration: InputDecoration(
                                      labelText: 'Email',
                                      labelStyle: TextStyle(
                                        fontWeight: FontWeight.bold
                                      ),
                                      prefixIcon: Image.asset('assets/icons/email.png', height: 25,width: 25,),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide(color: Colors.grey,width: 1.5)
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(20),
                                          borderSide: BorderSide(color: Colors.grey,width: 1.5)
                                      ),
                                      filled: true,
                                      fillColor: Color(0xFFECF5E3),
                                      contentPadding: EdgeInsets.symmetric( horizontal: 22),
                                    ),
                                    keyboardType: TextInputType.emailAddress,

                                    validator: (value){
                                      if(value ==null || value.isEmpty){
                                        return'Vui lòng nhập email';
                                      }
                                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                                        return 'Email không hợp lệ';
                                      }
                                      return null;
                                    },
                                  );
                                },
                                btnText: 'Tiếp theo',
                                onNext: () async {
                                  if (_formkey.currentState!.validate()) {
                                    final email = _emailController.text.trim();
                                    try {
                                      final success = await ForgotPasswordController.sendOtp(email);
                                      if (success) {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(builder: (context) => VertificationScreen(email: email)),
                                        );
                                      } else {
                                        print('❌ sendOtp trả về false với email: $email');
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text("Gửi OTP thất bại, vui lòng thử lại."),
                                          ),
                                        );
                                      }
                                    } catch (e) {
                                      print('❌ Lỗi khi gọi sendOtp: $e');
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text("Đã xảy ra lỗi, vui lòng thử lại sau."),
                                        ),
                                      );
                                    }
                                  }
                                }

                            )
                          ],
                        ),
                      )

                    ],
                  ),
                ),
              ),
            ),
          ),
        )
    );
  }
}
