import 'package:eco_swap/data/source/UserAuthDataSource.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUserCredential extends Mock implements UserCredential {}

void main() {
  group('Login', () {
    late UserAuthDataSource userAuthDataSource;
    late MockFirebaseAuth mockFirebaseAuth;

    setUp(() {
      mockFirebaseAuth = MockFirebaseAuth();
      userAuthDataSource = UserAuthDataSource.test(mockFirebaseAuth);
    });

    test('Login utente con credenziali valide', () async {
      when(mockFirebaseAuth.signInWithEmailAndPassword(
        email: '1@2.com',
        password: '123456',
      )).thenAnswer((_) async => MockUserCredential());

      // Esegui il login utilizzando le credenziali valide
      final result = await userAuthDataSource.login(
        email: '1@2.com',
        password: '123456',
      );

      // Verifica se il risultato è "Success"
      expect(result, 'Success');
    });
  });
}
