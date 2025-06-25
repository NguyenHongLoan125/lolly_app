
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lolly_app/controllers/forgot_password_controller.dart';
import 'package:lolly_app/views/screens/forgot_password/forgot_pasword_widgets.dart';
import 'package:lolly_app/views/screens/forgot_password/input_email_screen.dart';
import 'package:lolly_app/views/screens/forgot_password/new_password_screen.dart';
import 'package:pin_code_fields/pin_code_fields.dart';


class VertificationScreen extends StatefulWidget {
  final String email;
  const VertificationScreen({super.key, required this.email});

  @override
  State<VertificationScreen> createState() => _VertificationScreenState();
}

class _VertificationScreenState extends State<VertificationScreen> {
  final TextEditingController _otpController = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar:CustomAppBar(backRoute: '/input-email'),

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
                                  content: (context, controller) {
                                    return PinCodeTextField(
                                      appContext: context,
                                      length: 6,
                                      controller: _otpController,
                                      keyboardType: TextInputType.number,
                                      autoFocus: true,
                                      animationType: AnimationType.fade,
                                      pinTheme: PinTheme(
                                        shape: PinCodeFieldShape.box,
                                        borderRadius: BorderRadius.circular(8),
                                        fieldHeight: 48,
                                        fieldWidth: 48,
                                        inactiveColor: Colors.white,
                                        selectedColor: Colors.white,
                                        activeColor: Color.fromRGBO(0, 116, 0, 1),
                                      ),
                                      animationDuration: const Duration(milliseconds: 300),
                                      validator: (value) {
                                        if (value == null || value.isEmpty || value.length != 6) {
                                          return 'Mã OTP phải có 6 chữ số';
                                        }
                                        return null;
                                      },
                                    );
                                  },

                                  btnText: 'Tiếp theo',
                                  onNext: () async {
                                    if (_formkey.currentState!.validate()) {
                                      final otp = _otpController.text.trim();
                                      try {
                                        final success = await ForgotPasswordController.verifyOtp(widget.email, otp);
                                        if (success) {
                                          context.go(
                                            '/new-password',
                                            extra: {
                                              'email': widget.email,
                                              'otp': otp,
                                            },
                                          );


                                        } else {
                                          print('❌ verifyOtp trả về false với email: ${widget.email}, otp: $otp');
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                              content: Text("OTP không đúng, vui lòng thử lại."),
                                            ),
                                          );
                                        }
                                      } catch (e) {
                                        print('❌ Lỗi khi gọi verifyOtp: $e');
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text("Đã xảy ra lỗi, vui lòng thử lại sau."),
                                          ),
                                        );
                                      }
                                    }
                                  },

                                  description: 'Nhập mã OTP'
                              )
                            ],
                          )
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
