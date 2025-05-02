import '../exceptions/auth_exception.dart';

class AuthService {
  bool _isAuthenticated = false;
  String? _username;

  bool get isAuthenticated => _isAuthenticated;
  String? get username => _username;

  Future<bool> login(String? username, String? password) async {
    // Simple validation
    if (username == null || username.isEmpty || password == null || password.isEmpty) {
      throw AuthException('Username and password cannot be empty');
    }

    if (password.length < 6) {
      throw AuthException('Password must be at least 6 characters');
    }

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Simulate successful login
    _isAuthenticated = true;
    _username = username;
    return true;
  }

  Future<void> logout() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    _isAuthenticated = false;
    _username = null;
  }
}
