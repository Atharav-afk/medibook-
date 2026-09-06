import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/auth_repository.dart';
import 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final AuthRepository _authRepository;

  RegisterCubit({AuthRepository? authRepository})
      : _authRepository = authRepository ?? AuthRepository(),
        super(const RegisterState());

  Future<void> register({
    required String name,
    required String email,
    required String mobile,
    required String password,
  }) async {
    emit(state.copyWith(status: RegisterStatus.loading));
    try {
      await _authRepository.register(
        name: name,
        email: email,
        mobile: mobile,
        password: password,
      );
      emit(state.copyWith(status: RegisterStatus.success));
    } catch (e) {
      emit(state.copyWith(
        status: RegisterStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}
