import 'package:equatable/equatable.dart';
import '../../data/models/category_model.dart';
import '../../data/models/doctor_model.dart';

enum HomeStatus { initial, loading, success, failure }

class HomeState extends Equatable {
  final HomeStatus status;
  final List<DoctorModel> doctors;
  final List<CategoryModel> categories;
  final String? errorMessage;

  const HomeState({
    this.status = HomeStatus.initial,
    this.doctors = const [],
    this.categories = const [],
    this.errorMessage,
  });

  HomeState copyWith({
    HomeStatus? status,
    List<DoctorModel>? doctors,
    List<CategoryModel>? categories,
    String? errorMessage,
  }) {
    return HomeState(
      status: status ?? this.status,
      doctors: doctors ?? this.doctors,
      categories: categories ?? this.categories,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, doctors, categories, errorMessage];
}
