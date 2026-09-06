import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/doctor_repository.dart';
import 'search_state.dart';

/// Handles dynamic search-as-you-type and category filtering.
/// Doctors are fetched once and filtered client-side, which is enough
/// for the small dataset expected in a college project.
class SearchCubit extends Cubit<SearchState> {
  final DoctorRepository _doctorRepository;

  SearchCubit({DoctorRepository? doctorRepository})
      : _doctorRepository = doctorRepository ?? DoctorRepository(),
        super(const SearchState());

  Future<void> init({String? initialCategory}) async {
    emit(state.copyWith(status: SearchStatus.loading));
    try {
      final doctors = await _doctorRepository.getAllDoctors();
      final categories = await _doctorRepository.getCategories();
      final filtered = _doctorRepository.filterDoctors(
        doctors: doctors,
        category: initialCategory,
      );
      emit(state.copyWith(
        status: SearchStatus.success,
        allDoctors: doctors,
        categories: categories,
        results: filtered,
        selectedCategory: initialCategory,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: SearchStatus.failure,
        errorMessage: 'Could not load doctors. Please try again.',
      ));
    }
  }

  void search(String query) {
    final filtered = _doctorRepository.filterDoctors(
      doctors: state.allDoctors,
      query: query,
      category: state.selectedCategory,
    );
    emit(state.copyWith(query: query, results: filtered));
  }

  void selectCategory(String? category) {
    final isSame = category == state.selectedCategory;
    final newCategory = isSame ? null : category;
    final filtered = _doctorRepository.filterDoctors(
      doctors: state.allDoctors,
      query: state.query,
      category: newCategory,
    );
    emit(state.copyWith(
      results: filtered,
      selectedCategory: newCategory,
      clearCategory: newCategory == null,
    ));
  }
}
