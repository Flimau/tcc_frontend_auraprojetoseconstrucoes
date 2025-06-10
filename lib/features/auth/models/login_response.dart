class LoginResponse {
  final String token;
  final bool primeiroLogin;

  LoginResponse({required this.token, required this.primeiroLogin});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'],
      primeiroLogin: json['primeiroLogin'] ?? false,
    );
  }
}
