import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final bool showError;

  const PasswordField({
    super.key,
    required this.label,
    required this.controller,
    this.validator,
    this.focusNode,
    this.showError = false,
  });

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      validator: widget.validator,
      obscureText: _obscure,
      decoration: InputDecoration(
        labelText: widget.label,
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
          onPressed: () => setState(() => _obscure = !_obscure),
        ),
        errorText: widget.showError ? widget.validator?.call(widget.controller.text) : null,
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}

class AuthWidgets extends StatelessWidget {
  final String title;
  final bool isRegister;

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController? usernameController;
  final TextEditingController? confirmPasswordController;

  final String? Function(String?) emailValidator;
  final String? Function(String?) passwordValidator;
  final String? Function(String?)? usernameValidator;
  final String? Function(String?)? confirmPasswordValidator;
  final FocusNode emailFocus;
  final FocusNode passwordFocus;
  final bool showEmailError;
  final bool showPasswordError;
  final GlobalKey<FormState> formKey;
  final VoidCallback onSubmit;
  final String btnText;
  final Widget? footer;

  const AuthWidgets({
    super.key,
    required this.title,
    required this.isRegister,
    required this.emailController,
    required this.passwordController,
    this.usernameController,
    this.confirmPasswordController,
    required this.emailValidator,
    required this.passwordValidator,
    this.usernameValidator,
    this.confirmPasswordValidator,
    required this.onSubmit,
    required this.btnText,
    required this.formKey,
    required this.emailFocus,
    required this.passwordFocus,
    required this.showEmailError,
    required this.showPasswordError, this.footer,
  });

  InputDecoration CustomTextFormField(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: Colors.grey[100],
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: Center(
          child: Container(
            width: 800,
            height: 460,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: const Color(0xffECF5E3),
            ),
            child: Row(
              children: [
                // logo
                Expanded(
                  flex: 1,
                  child: Image.asset(
                    'assets/img/logo.png',
                    height: 500,
                    width: 500,
                    fit: BoxFit.contain,
                  ),
                ),
                // form
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Email
                          TextFormField(
                            controller: emailController,
                            focusNode: emailFocus,
                            decoration: CustomTextFormField('Email', Icons.email).copyWith(
                              errorText: showEmailError ? emailValidator(emailController.text) : null,
                            ),
                          ),

                          const SizedBox(height: 15),

                          // Username nếu là đăng ký
                          if (isRegister)
                            TextFormField(
                              controller: usernameController,
                              decoration: CustomTextFormField('Username', Icons.person).copyWith(
                                errorText: showEmailError ? usernameValidator?.call(usernameController?.text ?? '') : null,
                              ),
                            ),
                          if (isRegister) const SizedBox(height: 15),

                          // Password (có icon mắt)
                          PasswordField(
                            label: 'Password',
                            controller: passwordController,
                            validator: passwordValidator,
                            focusNode: passwordFocus,
                            showError: showPasswordError,
                          ),

                          const SizedBox(height: 25),

                          // Confirm Password nếu là đăng ký
                          if (isRegister)
                            PasswordField(
                              label: 'Confirm Password',
                              controller: confirmPasswordController!,
                              validator: confirmPasswordValidator,
                              showError: showPasswordError,
                            ),
                          if (isRegister) const SizedBox(height: 15),

                          SizedBox(
                            width: double.infinity,
                            height: 45,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xff007400),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                textStyle: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              onPressed: onSubmit,
                              child: Text(btnText),
                            ),
                          ),

                          if (footer != null) ...[
                            const SizedBox(height: 12),
                            footer!,
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}