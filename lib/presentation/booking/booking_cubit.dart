import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/utils/date_time_utils.dart';
import '../../data/models/doctor_model.dart';
import '../../data/repositories/appointment_repository.dart';
import 'booking_state.dart';

/// Drives the whole multi-step booking flow (date -> time -> details ->
/// confirmation) so every step shares one source of truth.
class BookingCubit extends Cubit<BookingState> {
  final AppointmentRepository _appointmentRepository;

  BookingCubit({
    required DoctorModel doctor,
    AppointmentRepository? appointmentRepository,
  })  : _appointmentRepository = appointmentRepository ?? AppointmentRepository(),
        super(BookingState(doctor: doctor));

  Future<void> selectDate(DateTime date) async {
    if (DateTimeUtils.isPastDate(date)) {
      emit(state.copyWith(errorMessage: 'You cannot select a past date.'));
      return;
    }
    emit(state.copyWith(
      status: BookingStatus.loadingSlots,
      selectedDate: date,
      selectedTime: null,
    ));
    try {
      final booked = await _appointmentRepository.getBookedSlots(
        doctorId: state.doctor.id,
        date: DateTimeUtils.toStorageFormat(date),
      );
      emit(state.copyWith(
        status: BookingStatus.selectingTime,
        bookedSlots: booked,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: BookingStatus.failure,
        errorMessage: 'Could not load time slots. Please try again.',
      ));
    }
  }

  void selectTime(String time) {
    emit(state.copyWith(
      status: BookingStatus.enteringDetails,
      selectedTime: time,
    ));
  }

  void setPatientDetails({
    required String name,
    required String mobile,
    required String email,
    required String reason,
  }) {
    emit(state.copyWith(
      patientName: name,
      patientMobile: mobile,
      patientEmail: email,
      reason: reason,
    ));
  }

  Future<void> confirmBooking(String userId) async {
    emit(state.copyWith(status: BookingStatus.submitting));
    try {
      final appointment = await _appointmentRepository.bookAppointment(
        userId: userId,
        doctorId: state.doctor.id,
        doctorName: state.doctor.name,
        specialization: state.doctor.specialization,
        patientName: state.patientName,
        patientEmail: state.patientEmail,
        patientMobile: state.patientMobile,
        date: DateTimeUtils.toStorageFormat(state.selectedDate!),
        time: state.selectedTime!,
        reason: state.reason,
        fee: state.doctor.fee,
      );
      emit(state.copyWith(
        status: BookingStatus.success,
        confirmedAppointment: appointment,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: BookingStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}
