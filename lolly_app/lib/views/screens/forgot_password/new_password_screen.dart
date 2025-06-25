import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lolly_app/controllers/forgot_password_controller.dart';
import 'package:lolly_app/views/screens/forgot_password/forgot_pasword_widgets.dart';
import 'package:lolly_app/views/screens/forgot_password/vertification_screen.dart';
import 'package:lolly_app/views/screens/login_sigup_screen/login.dart';


class NewPasswordScreen extends StatefulWidget {
  final String email;
  final String otp;
  const NewPasswordScreen({super.key, required this.email, required this.otp});

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  bool _isObscurePW = true;
  bool _isObscureCPW = true;

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  final _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: CustomAppBar(
            backRoute: '/vertification',
            extra: widget.email,
          ),
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
                          key:_formkey,
                          child: Column(
                            children: [
                              AddLogo(),
                              const SizedBox(height: 20,),
                              CreateScreen(
                                  content: (context, controller){
                                    return Column(
                                      children: [
                                        //password
                                        TextFormField(
                                          controller: _passwordController,
                                            style: TextStyle(
                                            fontSize: 16,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600
                                            ),
                                            decoration: InputDecoration(
                                              labelText: 'Mật khẩu',
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
                                              suffixIcon: IconButton(
                                                 icon: Icon( _isObscurePW ? Icons.visibility_off : Icons.visibility,),
                                                onPressed: (){
                                                   setState(() {
                                                     _isObscurePW = !_isObscurePW;
                                                   });
                                                },
                                              ),
                                            ),
                                            keyboardType: TextInputType.emailAddress,
                                            obscureText: _isObscurePW,
                                          validator: (value){
                                            if(value ==null || value.isEmpty){
                                              return'Vui lòng nhập mật khẩu';
                                            }
                                            return null;
                                          },
                                        ),
                                        const SizedBox(height: 20,),

                                        //Confirm PW
                                        TextFormField(
                                          controller: _confirmPasswordController,
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600
                                          ),
                                          decoration: InputDecoration(
                                            labelText: 'Xác nhận mật khẩu',
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
                                            suffixIcon: IconButton(
                                              icon: Icon( _isObscureCPW ? Icons.visibility_off : Icons.visibility,),
                                              onPressed: (){
                                                setState(() {
                                                  _isObscureCPW = !_isObscureCPW;
                                                });
                                              },
                                            ),
                                          ),
                                          keyboardType: TextInputType.emailAddress,
                                          obscureText: _isObscureCPW,
                                          validator: (value){
                                            if(value ==null || value.isEmpty){
                                              return'Vui lòng nhập mật khẩu';
                                            } else if (value != _passwordController.text) {
                                              return 'Mật khẩu không khớp';
                                            }
                                            return null;
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                  btnText: 'Tiếp theo',
                                  onNext: () async {
                                    if (_formkey.currentState!.validate()) {
                                      final password = _passwordController.text.trim();
                                      try {
                                        final success = await ForgotPasswordController.resetPassword(
                                          widget.email,
                                          widget.otp,
                                          password,
                                        );

                                        if (success) {
                                          context.go('/login');

                                        } else {
                                          print('❌ resetPassword trả về false');
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text('Đổi mật khẩu thất bại, thử lại sau')),
                                          );
                                        }
                                      } catch (e) {
                                        print('❌ Lỗi khi gọi resetPassword: $e');
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Đã xảy ra lỗi, thử lại sau')),
                                        );
                                      }
                                    }
                                  },

                                  description: 'Nhập mật khẩu mới'
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
