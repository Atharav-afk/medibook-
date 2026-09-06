import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/id_generator.dart';
import '../models/appointment_model.dart';
import '../services/firestore_service.dart';

/// Handles creating, reading, and cancelling appointments, including the
/// business rule that a doctorId + date + time combination can only be
/// booked once (while active).
class AppointmentRepository {
  final FirestoreService _firestoreService;

  AppointmentRepository({FirestoreService? firestoreService})
      : _firestoreService = firestoreService ?? FirestoreService();

  /// Returns the list of time slots for a doctor/date that are already
  /// booked (status upcoming or completed) so the UI can disable them.
  Future<List<String>> getBookedSlots({
    required String doctorId,
    required String date,
  }) async {
    final snapshot = await _firestoreService.appointments
        .where('doctorId', isEqualTo: doctorId)
        .where('date', isEqualTo: date)
        .where('status', whereIn: [
      AppConstants.statusUpcoming,
      AppConstants.statusCompleted,
    ]).get();

    return snapshot.docs
        .map((doc) => doc.data()['time'] as String? ?? '')
        .where((slot) => slot.isNotEmpty)
        .toList();
  }

  /// Creates the appointment inside a Firestore transaction so two users
  /// can never book the exact same doctorId + date + time slot.
  Future<AppointmentModel> bookAppointment({
    required String userId,
    required String doctorId,
    required String doctorName,
    required String specialization,
    required String patientName,
    required String patientEmail,
    required String patientMobile,
    required String date,
    required String time,
    required String reason,
    required double fee,
  }) async {
    final appointmentId = IdGenerator.bookingId();
    final docRef = _firestoreService.appointments.doc(appointmentId);

    return _firestoreService.appointments.firestore.runTransaction((tx) async {
      // Re-check for a conflicting active booking inside the transaction.
      final conflictQuery = await _firestoreService.appointments
          .where('doctorId', isEqualTo: doctorId)
          .where('date', isEqualTo: date)
          .where('time', isEqualTo: time)
          .where('status', whereIn: [
        AppConstants.statusUpcoming,
        AppConstants.statusCompleted,
      ]).get();

      if (conflictQuery.docs.isNotEmpty) {
        throw 'This slot was just booked by someone else. Please choose another.';
      }

      final appointment = AppointmentModel(
        appointmentId: appointmentId,
        userId: userId,
        doctorId: doctorId,
        doctorName: doctorName,
        specialization: specialization,
        patientName: patientName,
        patientEmail: patientEmail,
        patientMobile: patientMobile,
        date: date,
        time: time,
        reason: reason,
        fee: fee,
        status: AppConstants.statusUpcoming,
        createdAt: DateTime.now(),
      );

      tx.set(docRef, appointment.toMap());
      return appointment;
    });
  }

  /// Returns all appointments for a user, ordered by most recently created.
  Future<List<AppointmentModel>> getUserAppointments(String userId) async {
    final snapshot = await _firestoreService.appointments
        .where('userId', isEqualTo: userId)
        .get();

    final appointments = snapshot.docs
        .map((doc) => AppointmentModel.fromMap(doc.data(), doc.id))
        .toList();

    appointments.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return appointments;
  }

  /// Marks an appointment as cancelled. Because "booked" status is checked
  /// as upcoming/completed only, this automatically frees up the slot.
  Future<void> cancelAppointment(String appointmentId) async {
    await _firestoreService.appointments.doc(appointmentId).update({
      'status': AppConstants.statusCancelled,
    });
  }
}
