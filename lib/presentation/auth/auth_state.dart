import 'package:equatable/equatable.dart';
import '../../data/models/user_model.dart';

/// Shared auth status used by the Splash screen and app-wide auth checks.
enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthState extends Equatable {
  final AuthStatus status;
  final UserModel? user;

  const AuthState({required this.status, this.user});

  const AuthState.unknown() : this(status: AuthStatus.unknown);
  const AuthState.authenticated(UserModel user)
      : this(status: AuthStatus.authenticated, user: user);
  const AuthState.unauthenticated()
      : this(status: AuthStatus.unauthenticated);

  @override
  List<Object?> get props => [status, user];
}
