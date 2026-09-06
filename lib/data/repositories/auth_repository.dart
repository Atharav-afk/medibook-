import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import '../services/firebase_auth_service.dart';
import '../services/firestore_service.dart';

/// Coordinates Firebase Auth + the users Firestore collection.
/// This is the only place that knows about both services for auth flows.
class AuthRepository {
  final FirebaseAuthService _authService;
  final FirestoreService _firestoreService;

  AuthRepository({
    FirebaseAuthService? authService,
    FirestoreService? firestoreService,
  })  : _authService = authService ?? FirebaseAuthService(),
        _firestoreService = firestoreService ?? FirestoreService();

  Stream<User?> get authStateChanges => _authService.authStateChanges;

  User? get currentUser => _authService.currentUser;

  Future<UserModel> register({
    required String name,
    required String email,
    required String mobile,
    required String password,
  }) async {
    try {
      final credential =
          await _authService.register(email: email, password: password);
      final uid = credential.user!.uid;

      final user = UserModel(uid: uid, name: name, email: email, mobile: mobile);
      await _firestoreService.users.doc(uid).set(user.toMap());
      return user;
    } catch (e) {
      throw _authService.friendlyError(e);
    }
  }

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final credential =
          await _authService.login(email: email, password: password);
      final uid = credential.user!.uid;
      return getUserProfile(uid);
    } catch (e) {
      throw _authService.friendlyError(e);
    }
  }

  Future<UserModel> getUserProfile(String uid) async {
    final doc = await _firestoreService.users.doc(uid).get();
    if (!doc.exists) {
      throw 'User profile not found.';
    }
    return UserModel.fromMap(doc.data()!, uid);
  }

  Future<void> updateProfile(UserModel user) async {
    await _firestoreService.users.doc(user.uid).update(user.toMap());
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _authService.sendPasswordResetEmail(email);
    } catch (e) {
      throw _authService.friendlyError(e);
    }
  }

  Future<void> logout() {
    return _authService.logout();
  }
}
