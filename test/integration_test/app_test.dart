import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:demo_test/main.dart';
import 'package:demo_test/services/auth_service.dart';
import 'package:demo_test/providers/auth_provider.dart';
import 'package:provider/provider.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Authentication Flow Integration Tests', () {
    late AuthService authService;
    late AuthProvider authProvider;

    setUp(() {
      authService = AuthService();
      authProvider = AuthProvider(authService);
    });

    testWidgets('Complete login and logout flow', (WidgetTester tester) async {
      // Build our app and trigger a frame
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            Provider.value(value: authService),
            ChangeNotifierProvider.value(value: authProvider),
          ],
          child: const MainApp(),
        ),
      );

      // Wait for initial state to be rendered
      await tester.pumpAndSettle();

      // Verify initial state shows login screen
      expect(find.text('Login Screen'), findsOneWidget);
      expect(find.byType(TextField), findsNWidgets(2));

      // Enter credentials
      await tester.enterText(find.byType(TextField).first, 'testuser');
      await tester.enterText(find.byType(TextField).last, 'password123');
      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pumpAndSettle();

      // Verify logged in state shows home screen
      expect(find.text('Home Screen'), findsOneWidget);
      expect(find.text('Welcome, testuser!'), findsOneWidget);
      expect(find.byKey(const Key('logout_button')), findsOneWidget);

      // Logout
      await tester.tap(find.byKey(const Key('logout_button')));
      await tester.pumpAndSettle();

      // Verify logged out state shows login screen
      expect(find.text('Login Screen'), findsOneWidget);
      // expect(find.byType(TextField), findsNWidgets(2));
    });

    testWidgets('Error handling during login', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            Provider.value(value: authService),
            ChangeNotifierProvider.value(value: authProvider),
          ],
          child: const MainApp(),
        ),
      );

      // Wait for initial state to be rendered
      await tester.pumpAndSettle();

      // Try to login with empty credentials
      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pumpAndSettle();

      expect(find.text('Username and password cannot be empty'), findsOneWidget);

      // Try to login with short password
      await tester.enterText(find.byType(TextField).first, 'testuser');
      await tester.enterText(find.byType(TextField).last, '12345');
      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pumpAndSettle();

      expect(find.text('Password must be at least 6 characters'), findsOneWidget);
    });
  });
}
