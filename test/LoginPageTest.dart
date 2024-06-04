import 'package:eco_swap/data/source/UserAuthDataSource.dart';
import 'package:eco_swap/main.dart';
import 'package:eco_swap/view/welcome/LoginPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {
  @override
  Future<UserCredential> signInWithEmailAndPassword({
    required String? email,
    required String? password,
  }) =>
      super.noSuchMethod(
          Invocation.method(#signInWithEmailAndPassword, [email, password]),
          returnValue: Future.value(MockUserCredential()));

  @override
  Future<UserCredential> createUserWithEmailAndPassword({
    required String? email,
    required String? password,
  }) =>
      super.noSuchMethod(
          Invocation.method(#createUserWithEmailAndPassword, [email, password]),
          returnValue: Future.value(MockUserCredential()));
}

class MockUserCredential extends Mock implements UserCredential {}
class MockFirebaseStorage extends Mock implements FirebaseStorage {}
class MockFirebaseDatabase extends Mock implements FirebaseDatabase {}

void main() {
  late UserAuthDataSource userAuthDataSource;
  late MockFirebaseAuth mockFirebaseAuth;
  late MockFirebaseStorage mockFirebaseStorage;
  late MockFirebaseDatabase mockFirebaseDatabase;
  late MockUserCredential userCredential;
  late MockUser mockUser;

  setUp(() async {
    mockFirebaseAuth = MockFirebaseAuth();
    mockFirebaseStorage = MockFirebaseStorage();
    mockFirebaseDatabase = MockFirebaseDatabase();
    userCredential = MockUserCredential();
    mockUser = MockUser();
    userAuthDataSource = UserAuthDataSource.test(mockFirebaseAuth, mockFirebaseStorage, mockFirebaseDatabase);
    when(userCredential.user).thenReturn(mockUser);
  });

  group('Registration', () {
    test('registration should return: success message on successful registration', () async {
      // Arrange
      final email = 'test@example.com';
      final password = 'password123';
      final mockUserCredential = MockUserCredential();

      when(mockFirebaseAuth.createUserWithEmailAndPassword(email: email, password: password))
          .thenAnswer((_) async {
        return mockUserCredential;});

      // Act
      final result = await userAuthDataSource.registration(email: email, password: password);

      // Assert
      expect(result, 'Success');
      verify(mockFirebaseAuth.createUserWithEmailAndPassword(email: email, password: password)).called(1);
    });

    test('registration should return: weak password error message', () async {
      // Arrange
      final email = 'test@example.com';
      final password = '123';

      when(mockFirebaseAuth.createUserWithEmailAndPassword(email: email, password: password))
          .thenThrow(FirebaseAuthException(code: 'weak-password'));

      // Act
      final result = await userAuthDataSource.registration(email: email, password: password);

      // Assert
      expect(result, 'The password provided is too weak.');
      verify(mockFirebaseAuth.createUserWithEmailAndPassword(email: email, password: password)).called(1);
    });

    test('registration should return: email already in use error message', () async {
      // Arrange
      final email = 'test@example.com';
      final password = 'password123';

      when(mockFirebaseAuth.createUserWithEmailAndPassword(email: email, password: password))
          .thenThrow(FirebaseAuthException(code: 'email-already-in-use'));

      // Act
      final result = await userAuthDataSource.registration(email: email, password: password);

      // Assert
      expect(result, 'The account already exists for that email.');
      verify(mockFirebaseAuth.createUserWithEmailAndPassword(email: email, password: password)).called(1);
    });

    test('registration should return: generic error message', () async {
      // Arrange
      final email = 'test@example.com';
      final password = 'password123';

      when(mockFirebaseAuth.createUserWithEmailAndPassword(email: email, password: password))
          .thenThrow(FirebaseAuthException(code: 'some-other-error', message: 'An error occurred'));

      // Act
      final result = await userAuthDataSource.registration(email: email, password: password);

      // Assert
      expect(result, 'An error occurred');
      verify(mockFirebaseAuth.createUserWithEmailAndPassword(email: email, password: password)).called(1);
    });

    test('registration should return: non-FirebaseAuthException', () async {
      // Arrange
      final email = 'test@example.com';
      final password = 'password123';

      when(mockFirebaseAuth.createUserWithEmailAndPassword(email: email, password: password))
          .thenThrow(Exception('Non FirebaseAuthException error'));

      // Act
      final result = await userAuthDataSource.registration(email: email, password: password);

      // Assert
      expect(result, 'Exception: Non FirebaseAuthException error');
      verify(mockFirebaseAuth.createUserWithEmailAndPassword(email: email, password: password)).called(1);
    });
  });

  group('Login', () {


    test('Login with valid credential', () async {
      // Configura il mock per restituire un utente autenticato quando vengono fornite credenziali valide
      when(mockFirebaseAuth.signInWithEmailAndPassword(
        email: "1@2.com",
        password: "123456",
      )).thenAnswer((_) async => userCredential);

      // Esegui il login utilizzando le credenziali valide
      final result = await userAuthDataSource.login(
        email: '1@2.com',
        password: '123456',
      );

      // Verifica che il risultato sia "Success"
      expect(result, 'Success');
    });

    test('Login with wrong credential', () async {
      // Configura il mock per restituire un errore quando vengono fornite credenziali non valide
      when(mockFirebaseAuth.signInWithEmailAndPassword(
        email: "invalid@example.com",
        password: "invalidpassword",
      )).thenThrow(FirebaseAuthException(code: 'wrong-password'));

      // Esegui il login utilizzando credenziali non valide
      final result = await userAuthDataSource.login(
        email: 'invalid@example.com',
        password: 'invalidpassword',
      );

      // Verifica che il risultato sia un messaggio di errore appropriato
      expect(result, 'Wrong password provided for that user.');
    });
  });

  testWidgets('LoginPage should display email and password fields', (WidgetTester tester) async {
    setUp(() async {
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp();
      runApp(MyApp());
    });
    await tester.pumpWidget(MaterialApp(home: LoginPage()));
    expect(find.byKey(const Key('emailField')), findsOneWidget);
    expect(find.byKey(const Key('passwordField')), findsOneWidget);
  });

}
