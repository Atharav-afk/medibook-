import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/auth_repository.dart';
import 'auth_state.dart';

/// Tracks the app-wide authentication session.
/// Splash listens to this to decide where to navigate; Profile uses it
/// to display/update the current user; other cubits read currentUser.
class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;
  StreamSubscription? _authSubscription;

  AuthCubit({AuthRepository? authRepository})
      : _authRepository = authRepository ?? AuthRepository(),
        super(const AuthState.unknown()) {
    _authSubscription = _authRepository.authStateChanges.listen((user) async {
      if (user == null) {
        emit(const AuthState.unauthenticated());
      } else {
        try {
          final profile = await _authRepository.getUserProfile(user.uid);
          emit(AuthState.authenticated(profile));
        } catch (_) {
          emit(const AuthState.unauthenticated());
        }
      }
    });
  }

  Future<void> refreshProfile() async {
    final uid = _authRepository.currentUser?.uid;
    if (uid == null) return;
    final profile = await _authRepository.getUserProfile(uid);
    emit(AuthState.authenticated(profile));
  }

  Future<void> logout() async {
    await _authRepository.logout();
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }
}
