import 'package:eco_swap/data/repository/IUserRepository.dart';
import 'package:eco_swap/data/viewmodel/UserViewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eco_swap/view/welcome/LoginPage.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

// Classe mock per IUserRepository
class MockUserRepository extends Mock implements IUserRepository {}

// Classe mock per UserViewModel
class MockUserViewModel extends Mock implements UserViewModel {}

void main() {
  group('LoginPage Widget Test', () {
    late MockUserRepository mockUserRepository;
    late MockUserViewModel mockUserViewModel;

    setUp(() {
      mockUserRepository = MockUserRepository();
      mockUserViewModel = MockUserViewModel();
    });

    Future<void> _buildLoginPage(WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Provider<UserViewModel>(
              create: (_) => mockUserViewModel,
              child: LoginPage(),
            ),
          ),
        ),
      );
    }

    testWidgets('Login with valid credentials', (WidgetTester tester) async {
      await _buildLoginPage(tester);

      // Simula l'inserimento di email e password
      await tester.enterText(find.byKey(const Key('emailField')), 'test@example.com');
      await tester.enterText(find.byKey(const Key('passwordField')), 'password123');

      // Simula il tap sul pulsante di login
      await tester.tap(find.byKey(const Key('loginButton')));
      await tester.pump();

      // Verifica che il metodo di login sia stato chiamato
      verify(mockUserViewModel.login(
        email: 'test@example.com',
        password: 'password123',
      )).called(1);
    });

    testWidgets('Shows error message on invalid credentials', (WidgetTester tester) async {
      await _buildLoginPage(tester);

      // Simula l'inserimento di email e password
      await tester.enterText(find.byKey(const Key('emailField')), 'invalid@example.com');
      await tester.enterText(find.byKey(const Key('passwordField')), 'wrongpassword');

      // Simula il tap sul pulsante di login
      await tester.tap(find.byKey(const Key('loginButton')));
      await tester.pump();

      // Simula la risposta di errore
      when(mockUserViewModel.login(
        email: 'invalid@example.com',
        password: 'wrongpassword',
      )).thenAnswer((_) async => 'Invalid credentials');

      // Verifica che venga mostrato un messaggio di errore
      expect(find.text('Invalid credentials'), findsOneWidget);
    });
  });
}
