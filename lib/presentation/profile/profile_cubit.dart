import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/auth_repository.dart';
import 'profile_state.dart';

/// Handles updating the user's profile fields in Firestore.
/// Logout lives on the app-wide AuthCubit since it affects the whole app.
class ProfileCubit extends Cubit<ProfileState> {
  final AuthRepository _authRepository;

  ProfileCubit({AuthRepository? authRepository})
      : _authRepository = authRepository ?? AuthRepository(),
        super(const ProfileState());

  Future<void> updateProfile({
    required UserModel currentUser,
    required String name,
    required String mobile,
  }) async {
    emit(state.copyWith(status: ProfileUpdateStatus.loading));
    try {
      final updated = currentUser.copyWith(name: name, mobile: mobile);
      await _authRepository.updateProfile(updated);
      emit(state.copyWith(status: ProfileUpdateStatus.success));
    } catch (e) {
      emit(state.copyWith(
        status: ProfileUpdateStatus.failure,
        errorMessage: 'Could not update profile. Please try again.',
      ));
    }
  }
}
