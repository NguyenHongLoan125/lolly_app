import 'package:flutter/material.dart';
import 'package:lolly_app/controllers/authentication_controller.dart';
import 'package:lolly_app/models/auth_model.dart';
import 'package:lolly_app/views/screens/forgot_password/input_email_screen.dart';
import 'package:lolly_app/views/screens/login_sigup_screen/login.dart';
import 'package:lolly_app/views/screens/login_sigup_screen/sign_up.dart';

import '../../../controllers/auth_storage.dart';
 // Import file chứa logic kiểm tra

class AuthWidgets extends StatefulWidget {
  final AuthModel authModel;

  AuthWidgets({super.key, required this.authModel});

  @override
  State<AuthWidgets> createState() => _AuthWidgetsState();
}

class _AuthWidgetsState extends State<AuthWidgets> {
  final _formKey = GlobalKey<FormState>();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  // Hàm thiết kế icon trong khung text
  InputDecoration customForm(String label, String imageIcon, String hintText,) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(
        color: Colors.black,
        fontSize: 15,
        fontWeight: FontWeight.bold,
      ),
      labelText: label,
      labelStyle: TextStyle(
        color: Colors.black,
        fontSize: 15,
        fontWeight: FontWeight.bold,
      ),
      prefixIcon: Padding(
        padding: EdgeInsets.all(8.0),
        child: Image.asset(imageIcon, width: 40, height: 40),
      ),

      filled: true,
      fillColor: Color(0xFFECF5E3),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black, width: 1.5),
        borderRadius: BorderRadius.circular(30)
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey, width: 1.5),
        borderRadius: BorderRadius.circular(30)
      ),
      errorBorder: OutlineInputBorder( // Viền đỏ khi có lỗi
        borderSide: BorderSide(color: Colors.red, width: 2),
        borderRadius: BorderRadius.circular(30)
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red, width: 2),
        borderRadius: BorderRadius.circular(30)
      ),
    );
  }

  String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return "$fieldName không được để trống!";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 70),
          color: Color.fromRGBO(204, 255, 152, 1),
          child: SingleChildScrollView(
            child: Center(
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Color(0xFF343632).withAlpha((255 * 0.3).toInt()),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        widget.authModel.title,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        widget.authModel.description,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      const SizedBox(height: 30),
            
                      // Email
                      TextFormField(
                        controller: widget.authModel.emailController,
                        decoration: customForm(
                            'Email',
                            'assets/icons/email.png',
                            'Nhập email'),
                        validator: (value) => validateRequired(value, "Email"),
                      ),
                      const SizedBox(height: 20),
            
                      // Nếu là đăng ký, hiển thị Tên người dùng
                      if (widget.authModel.isRegister)
                        TextFormField(
                          controller: widget.authModel.usernameController,
                          decoration: customForm('Tên người dùng', 'assets/icons/email.png', 'Nhập tên'),
                          validator: (value) => validateRequired(value, "Tên người dùng"),
                        ),
            
                      const SizedBox(height: 20),
            
                      // Mật khẩu
                      TextFormField(
                        controller: widget.authModel.passWordController,
                        decoration: customForm(
                            'Mật khẩu',
                            'assets/icons/email.png',
                            'Nhập mật khẩu'
                        ).copyWith(
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword ? Icons.visibility_off : Icons.visibility,
                              color: Color(0xFF007400),
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),
                        obscureText: _obscurePassword,
                        validator: (value) => validateRequired(value, "Mật khẩu"),
                      ),
                      const SizedBox(height:10),

                      //nút remember me
                      if(!widget.authModel.isRegister)
                        Row(
                          children: [
                            Checkbox(
                              value: widget.authModel.isRememberMe,
                              onChanged: widget.authModel.onRememberChanged,
                              side: const BorderSide(
                                  color: Color(0xFF007400),
                                  width: 1.5
                              ),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)
                              ),
                              activeColor: Colors.green,
                              checkColor: Colors.white,
                              fillColor: MaterialStateProperty.resolveWith<Color>((states) {
                                if (states.contains(MaterialState.selected)) {
                                  return  Color.fromRGBO(204, 255, 152, 1); // màu khi được chọn
                                }
                                return Colors.grey.shade300; // màu khi chưa chọn
                              }),

                            ),
                            const SizedBox(width: 5,),
                            const Text(
                              'Ghi nhớ đăng nhập',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold
                              ),
                            ),

                          ],
                        ),


                      const SizedBox(height: 20),
            
                      //  Xác nhận mật khẩu
                      if (widget.authModel.isRegister)
                        TextFormField(
                          controller: widget.authModel.confirmPasswordController,
                          decoration: customForm(
                              'Xác nhận mật khẩu',
                              'assets/icons/email.png',
                              'Nhập lại mật khẩu'
                          ).copyWith(
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureConfirm ? Icons.visibility_off : Icons.visibility,
                                color: Color(0xFF007400),
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureConfirm = !_obscureConfirm;
                                });
                              },
                            ),
                          ),
                          obscureText: _obscureConfirm,
                          validator: (value) => validateRequired(value, "Xác nhận mật khẩu"),
                        ),



                      const SizedBox(height: 30),
            
                      // Nút xác nhận
                      Container(
                        height: 50,
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 25),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromRGBO(0, 116, 0, 1),
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              if (widget.authModel.isRegister) {
                                widget.authModel.onButton?.call();
                              }
                              else {
                                AuthenticationController.logIn(
                                  context: context,
                                  email: widget.authModel.emailController.text,
                                  password: widget.authModel.passWordController.text,
                                );

                                await AuthStorage.saveCredentials(
                                  widget.authModel.emailController.text,
                                  widget.authModel.passWordController.text,
                                  widget.authModel.isRememberMe ?? false
                                );
                              }
            
                            }
                          },
                          child: Text(
                            widget.authModel.btnText,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20,),
                      //câu điều hướng giữa 2 trang
                      if (widget.authModel.isRegister)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Bạn đã có tài khoản?',
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white
                              ),
                            ),
                            const SizedBox(width: 7,),
                            GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacement(context,
                                      MaterialPageRoute(
                                          builder: (context) => LoginScreen()
                                      )
                                  );
                                },
                                child: Text('Đăng nhập',
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold
                                  ),
                                ))
                          ],
                        )
                      else
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                                onTap: (){
                                  Navigator.pushReplacement(context,
                                      MaterialPageRoute(
                                          builder: (context)
                                              => InputEmailScreen()
                                      )
                                  );
                                },
                                child: Text('Quên mật khẩu?',
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500
                                  ),
                                )
                            ),
                            const SizedBox( height: 15,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Chưa có tài khoản?',
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white
                                  ),
                                ),
                                const SizedBox(width: 7,),
                                GestureDetector(
                                    onTap: (){
                                      Navigator.pushReplacement(context,
                                          MaterialPageRoute(builder: (context)
                                              => SignUpScreen()
                                          )
                                      );
                                    },
                                    child: Text ('Đăng ký ngay',
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold
                                      ),
                                    )
                                )
                              ],
                            )
                          ],
                        )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}