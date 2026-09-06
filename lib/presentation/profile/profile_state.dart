import 'package:equatable/equatable.dart';

enum ProfileUpdateStatus { initial, loading, success, failure }

class ProfileState extends Equatable {
  final ProfileUpdateStatus status;
  final String? errorMessage;

  const ProfileState({this.status = ProfileUpdateStatus.initial, this.errorMessage});

  ProfileState copyWith({ProfileUpdateStatus? status, String? errorMessage}) {
    return ProfileState(
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage];
}
