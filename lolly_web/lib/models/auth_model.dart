class AuthModel {
  final String email;
  final String password;
  final String? username;
  final String? confirmPassword;

  AuthModel({
    required this.email,
    required this.password,
    this.username,
    this.confirmPassword,
  });
}
