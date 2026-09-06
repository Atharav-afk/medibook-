import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/appointment_repository.dart';
import 'appointments_state.dart';

/// Loads the current user's appointments and handles cancellation.
/// Cancelling simply updates the Firestore status to "cancelled", which
/// automatically frees up the slot (see AppointmentRepository.getBookedSlots).
class AppointmentsCubit extends Cubit<AppointmentsState> {
  final AppointmentRepository _appointmentRepository;

  AppointmentsCubit({AppointmentRepository? appointmentRepository})
      : _appointmentRepository = appointmentRepository ?? AppointmentRepository(),
        super(const AppointmentsState());

  Future<void> loadAppointments(String userId) async {
    emit(state.copyWith(status: AppointmentsStatus.loading));
    try {
      final appointments = await _appointmentRepository.getUserAppointments(userId);
      emit(state.copyWith(
        status: AppointmentsStatus.success,
        appointments: appointments,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AppointmentsStatus.failure,
        errorMessage: 'Could not load your appointments.',
      ));
    }
  }

  Future<void> cancelAppointment(String appointmentId, String userId) async {
    emit(state.copyWith(cancellingId: appointmentId));
    try {
      await _appointmentRepository.cancelAppointment(appointmentId);
      await loadAppointments(userId);
    } catch (e) {
      emit(state.copyWith(
        errorMessage: 'Could not cancel appointment. Please try again.',
        clearCancellingId: true,
      ));
    }
  }
}
