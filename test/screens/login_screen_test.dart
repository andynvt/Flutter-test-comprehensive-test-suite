import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:demo_test/screens/login_screen.dart';
import 'package:demo_test/providers/auth_provider.dart';
import 'package:demo_test/services/auth_service.dart';

void main() {
  late AuthService authService;
  late AuthProvider authProvider;

  setUp(() {
    authService = AuthService();
    authProvider = AuthProvider(authService);
  });

  testWidgets('LoginScreen shows login form', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider.value(
          value: authProvider,
          child: const LoginScreen(),
        ),
      ),
    );

    expect(find.text('Login Screen'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(2));
    expect(find.byType(ElevatedButton), findsOneWidget);
  });

  testWidgets('LoginScreen shows error message on invalid login', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider.value(
          value: authProvider,
          child: const LoginScreen(),
        ),
      ),
    );

    await tester.enterText(find.byType(TextField).first, '');
    await tester.enterText(find.byType(TextField).last, '');
    await tester.tap(find.byKey(const Key('login_button')));
    await tester.pumpAndSettle();

    expect(find.text('Username and password cannot be empty'), findsOneWidget);
  });

  testWidgets('LoginScreen shows loading indicator during login', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider.value(
          value: authProvider,
          child: const LoginScreen(),
        ),
      ),
    );

    await tester.enterText(find.byType(TextField).first, 'testuser');
    await tester.enterText(find.byType(TextField).last, 'password123');
    await tester.tap(find.byKey(const Key('login_button')));
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Wait for the delayed timer to complete
    await tester.pumpAndSettle();
  });
}
