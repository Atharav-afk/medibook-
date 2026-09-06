import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/auth_repository.dart';
import 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  final AuthRepository _authRepository;

  ForgotPasswordCubit({AuthRepository? authRepository})
      : _authRepository = authRepository ?? AuthRepository(),
        super(const ForgotPasswordState());

  Future<void> sendResetEmail(String email) async {
    emit(state.copyWith(status: ForgotPasswordStatus.loading));
    try {
      await _authRepository.sendPasswordResetEmail(email);
      emit(state.copyWith(status: ForgotPasswordStatus.success));
    } catch (e) {
      emit(state.copyWith(
        status: ForgotPasswordStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}
