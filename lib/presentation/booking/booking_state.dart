import 'package:equatable/equatable.dart';
import '../../data/models/appointment_model.dart';
import '../../data/models/doctor_model.dart';

enum BookingStatus {
  selectingDate,
  loadingSlots,
  selectingTime,
  enteringDetails,
  submitting,
  success,
  failure,
}

class BookingState extends Equatable {
  final BookingStatus status;
  final DoctorModel doctor;
  final DateTime? selectedDate;
  final String? selectedTime;
  final List<String> bookedSlots;
  final String patientName;
  final String patientMobile;
  final String patientEmail;
  final String reason;
  final AppointmentModel? confirmedAppointment;
  final String? errorMessage;

  const BookingState({
    required this.doctor,
    this.status = BookingStatus.selectingDate,
    this.selectedDate,
    this.selectedTime,
    this.bookedSlots = const [],
    this.patientName = '',
    this.patientMobile = '',
    this.patientEmail = '',
    this.reason = '',
    this.confirmedAppointment,
    this.errorMessage,
  });

  BookingState copyWith({
    BookingStatus? status,
    DateTime? selectedDate,
    String? selectedTime,
    List<String>? bookedSlots,
    String? patientName,
    String? patientMobile,
    String? patientEmail,
    String? reason,
    AppointmentModel? confirmedAppointment,
    String? errorMessage,
  }) {
    return BookingState(
      doctor: doctor,
      status: status ?? this.status,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedTime: selectedTime ?? this.selectedTime,
      bookedSlots: bookedSlots ?? this.bookedSlots,
      patientName: patientName ?? this.patientName,
      patientMobile: patientMobile ?? this.patientMobile,
      patientEmail: patientEmail ?? this.patientEmail,
      reason: reason ?? this.reason,
      confirmedAppointment: confirmedAppointment ?? this.confirmedAppointment,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        doctor.id,
        selectedDate,
        selectedTime,
        bookedSlots,
        patientName,
        patientMobile,
        patientEmail,
        reason,
        confirmedAppointment?.appointmentId,
        errorMessage,
      ];
}
