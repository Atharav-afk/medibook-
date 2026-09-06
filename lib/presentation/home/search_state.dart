import 'package:equatable/equatable.dart';
import '../../data/models/category_model.dart';
import '../../data/models/doctor_model.dart';

enum SearchStatus { loading, success, failure }

class SearchState extends Equatable {
  final SearchStatus status;
  final List<DoctorModel> allDoctors;
  final List<DoctorModel> results;
  final List<CategoryModel> categories;
  final String query;
  final String? selectedCategory;
  final String? errorMessage;

  const SearchState({
    this.status = SearchStatus.loading,
    this.allDoctors = const [],
    this.results = const [],
    this.categories = const [],
    this.query = '',
    this.selectedCategory,
    this.errorMessage,
  });

  SearchState copyWith({
    SearchStatus? status,
    List<DoctorModel>? allDoctors,
    List<DoctorModel>? results,
    List<CategoryModel>? categories,
    String? query,
    String? selectedCategory,
    bool clearCategory = false,
    String? errorMessage,
  }) {
    return SearchState(
      status: status ?? this.status,
      allDoctors: allDoctors ?? this.allDoctors,
      results: results ?? this.results,
      categories: categories ?? this.categories,
      query: query ?? this.query,
      selectedCategory:
          clearCategory ? null : (selectedCategory ?? this.selectedCategory),
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props =>
      [status, allDoctors, results, categories, query, selectedCategory, errorMessage];
}
