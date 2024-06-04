import 'package:eco_swap/data/source/RentalDataSource.dart';
import 'package:eco_swap/model/Rental.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

// Classi di mock definite manualmente
class MockFirebaseStorage extends Mock implements FirebaseStorage {}
class MockFirebaseDatabase extends Mock implements FirebaseDatabase {}
class MockDatabaseReference extends Mock implements DatabaseReference {}
class MockStorageReference extends Mock implements Reference {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockFirebaseDatabase mockFirebaseDatabase;
  late MockFirebaseStorage mockFirebaseStorage;
  late RentalDataSource rentalDataSource;
  late MockDatabaseReference mockDatabaseReference;
  late MockStorageReference mockStorageReference;

  setUp(() {
    mockFirebaseDatabase = MockFirebaseDatabase();
    mockFirebaseStorage = MockFirebaseStorage();
    mockDatabaseReference = MockDatabaseReference();
    mockStorageReference = MockStorageReference();

    when(mockFirebaseDatabase.reference()).thenReturn(mockDatabaseReference);
    when(mockFirebaseStorage.ref()).thenReturn(mockStorageReference);

    rentalDataSource = RentalDataSource.test(mockFirebaseStorage, mockFirebaseDatabase);


    when(mockDatabaseReference.set(any)).thenAnswer((_) async => Future.value());
  });

  group('Rental Loading Test', () {
    test('Load Rental from Firebase', () async {
      final Rental rental = Rental(
          "", "provaUser", "titolo", "descrizione", 1, 2, "3", "4", "123", "", "posizione", "12/12/12", "2", "2");

      final result = await rentalDataSource.loadRental(rental);
      expect(result, equals('Success'));

      // Verifica che i metodi child e set siano stati chiamati
      verify(mockDatabaseReference.child('rentals')).called(1);
      verify(mockDatabaseReference.child(rental.idToken)).called(1);
      verify(mockDatabaseReference.set(rental.toMap())).called(1);
    });
  });
}
