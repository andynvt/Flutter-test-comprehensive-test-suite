import 'package:flutter_test/flutter_test.dart';
import 'package:demo_test/services/auth_service.dart';

void main() {
  late AuthService authService;

  setUp(() {
    authService = AuthService();
  });

  group('AuthService', () {
    test('initial state is not authenticated', () {
      expect(authService.isAuthenticated, false);
      expect(authService.username, null);
    });

    test('login with valid credentials', () async {
      final result = await authService.login('testuser', 'password123');
      expect(result, true);
      expect(authService.isAuthenticated, true);
      expect(authService.username, 'testuser');
    });

    test('login with empty username throws exception', () async {
      expect(
        () => authService.login('', 'password123'),
        throwsException,
      );
    });

    test('login with empty password throws exception', () async {
      expect(
        () => authService.login('testuser', ''),
        throwsException,
      );
    });

    test('login with short password throws exception', () async {
      expect(
        () => authService.login('testuser', '12345'),
        throwsException,
      );
    });

    test('logout clears authentication state', () async {
      await authService.login('testuser', 'password123');
      await authService.logout();
      expect(authService.isAuthenticated, false);
      expect(authService.username, null);
    });
  });
}
