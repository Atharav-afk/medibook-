import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/auth_repository.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository _authRepository;

  LoginCubit({AuthRepository? authRepository})
      : _authRepository = authRepository ?? AuthRepository(),
        super(const LoginState());

  Future<void> login({required String email, required String password}) async {
    emit(state.copyWith(status: LoginStatus.loading));
    try {
      await _authRepository.login(email: email, password: password);
      emit(state.copyWith(status: LoginStatus.success));
    } catch (e) {
      emit(state.copyWith(
        status: LoginStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}
