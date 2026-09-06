import 'package:cloud_firestore/cloud_firestore.dart';

/// Represents an appointment document in the appointments collection.
class AppointmentModel {
  final String appointmentId;
  final String userId;
  final String doctorId;
  final String doctorName;
  final String specialization;
  final String patientName;
  final String patientEmail;
  final String patientMobile;
  final String date; // stored as 'yyyy-MM-dd' for easy querying
  final String time;
  final String reason;
  final double fee;
  final String status; // upcoming | completed | cancelled
  final DateTime createdAt;

  const AppointmentModel({
    required this.appointmentId,
    required this.userId,
    required this.doctorId,
    required this.doctorName,
    required this.specialization,
    required this.patientName,
    required this.patientEmail,
    required this.patientMobile,
    required this.date,
    required this.time,
    required this.reason,
    required this.fee,
    required this.status,
    required this.createdAt,
  });

  factory AppointmentModel.fromMap(Map<String, dynamic> map, String id) {
    return AppointmentModel(
      appointmentId: id,
      userId: map['userId'] ?? '',
      doctorId: map['doctorId'] ?? '',
      doctorName: map['doctorName'] ?? '',
      specialization: map['specialization'] ?? '',
      patientName: map['patientName'] ?? '',
      patientEmail: map['patientEmail'] ?? '',
      patientMobile: map['patientMobile'] ?? '',
      date: map['date'] ?? '',
      time: map['time'] ?? '',
      reason: map['reason'] ?? '',
      fee: (map['fee'] ?? 0).toDouble(),
      status: map['status'] ?? 'upcoming',
      createdAt: map['createdAt'] is Timestamp
          ? (map['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'appointmentId': appointmentId,
      'userId': userId,
      'doctorId': doctorId,
      'doctorName': doctorName,
      'specialization': specialization,
      'patientName': patientName,
      'patientEmail': patientEmail,
      'patientMobile': patientMobile,
      'date': date,
      'time': time,
      'reason': reason,
      'fee': fee,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  AppointmentModel copyWith({String? status}) {
    return AppointmentModel(
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
      status: status ?? this.status,
      createdAt: createdAt,
    );
  }
}
