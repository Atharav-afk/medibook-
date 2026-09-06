import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/constants/app_constants.dart';

/// Thin wrapper exposing the raw Firestore collection references.
/// Repositories build on top of this instead of calling FirebaseFirestore
/// directly, keeping the data layer in one place.
class FirestoreService {
  final FirebaseFirestore _db;

  FirestoreService({FirebaseFirestore? firestore})
      : _db = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get users =>
      _db.collection(AppConstants.usersCollection);

  CollectionReference<Map<String, dynamic>> get doctors =>
      _db.collection(AppConstants.doctorsCollection);

  CollectionReference<Map<String, dynamic>> get categories =>
      _db.collection(AppConstants.categoriesCollection);

  CollectionReference<Map<String, dynamic>> get appointments =>
      _db.collection(AppConstants.appointmentsCollection);
}
