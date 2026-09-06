import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/doctor_repository.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final DoctorRepository _doctorRepository;

  HomeCubit({DoctorRepository? doctorRepository})
      : _doctorRepository = doctorRepository ?? DoctorRepository(),
        super(const HomeState());

  Future<void> loadHome() async {
    emit(state.copyWith(status: HomeStatus.loading));
    try {
      final doctors = await _doctorRepository.getAllDoctors();
      final categories = await _doctorRepository.getCategories();
      emit(state.copyWith(
        status: HomeStatus.success,
        doctors: doctors,
        categories: categories,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: HomeStatus.failure,
        errorMessage: 'Could not load doctors. Please try again.',
      ));
    }
  }
}
