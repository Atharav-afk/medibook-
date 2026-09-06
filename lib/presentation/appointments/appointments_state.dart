import 'package:equatable/equatable.dart';
import '../../data/models/appointment_model.dart';

enum AppointmentsStatus { initial, loading, success, failure }

class AppointmentsState extends Equatable {
  final AppointmentsStatus status;
  final List<AppointmentModel> appointments;
  final String? errorMessage;
  final String? cancellingId;

  const AppointmentsState({
    this.status = AppointmentsStatus.initial,
    this.appointments = const [],
    this.errorMessage,
    this.cancellingId,
  });

  List<AppointmentModel> get upcoming =>
      appointments.where((a) => a.status == 'upcoming').toList();

  List<AppointmentModel> get completed =>
      appointments.where((a) => a.status == 'completed').toList();

  List<AppointmentModel> get cancelled =>
      appointments.where((a) => a.status == 'cancelled').toList();

  AppointmentsState copyWith({
    AppointmentsStatus? status,
    List<AppointmentModel>? appointments,
    String? errorMessage,
    String? cancellingId,
    bool clearCancellingId = false,
  }) {
    return AppointmentsState(
      status: status ?? this.status,
      appointments: appointments ?? this.appointments,
      errorMessage: errorMessage,
      cancellingId: clearCancellingId ? null : (cancellingId ?? this.cancellingId),
    );
  }

  @override
  List<Object?> get props => [status, appointments, errorMessage, cancellingId];
}
