import 'package:eco_swap/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eco_swap/view/welcome/LoginPage.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:eco_swap/data/repository/IUserRepository.dart';
import 'package:eco_swap/data/viewmodel/UserViewModel.dart';
import 'package:firebase_core/firebase_core.dart';

// Classe mock per IUserRepository
class MockUserRepository extends Mock implements IUserRepository {}

// Classe mock per UserViewModel
class MockUserViewModel extends Mock implements UserViewModel {}

void main() {
  group('LoginPage Widget Test', () {
    late MockUserRepository mockUserRepository;
    late MockUserViewModel mockUserViewModel;

    setUpAll(() async {
      // Inizializza manualmente Firebase durante i test
      TestWidgetsFlutterBinding.ensureInitialized();
    });

    setUp(() {
      mockUserRepository = MockUserRepository();
      mockUserViewModel = MockUserViewModel();

    });

    // Definisci la funzione _buildLoginPage
    Future<void> _buildLoginPage(WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
              body: LoginPage(),
          ),
        ),
      );
    }

    testWidgets('Login with valid credentials', (WidgetTester tester) async {
      await tester.runAsync(() async {
        await _buildLoginPage(tester);

        // Simula l'inserimento di email e password
        await tester.enterText(find.byKey(const Key('emailField')), '1@2.com');
        await tester.enterText(find.byKey(const Key('passwordField')), '123456');

        // Simula il tap sul pulsante di login
        await tester.tap(find.byKey(const Key('loginButton')));
        await tester.pump();

        // Verifica che il metodo di login sia stato chiamato
        verify(mockUserViewModel.login(
          email: '1@2.com',
          password: '123456',
        )).called(1);

        // Attendi un breve periodo per consentire il completamento delle operazioni asincrone
        await Future.delayed(const Duration(seconds: 1));

        // Assicurati che non ci siano widget in sospeso
        await tester.pumpAndSettle();
      });
    });

  });
}
