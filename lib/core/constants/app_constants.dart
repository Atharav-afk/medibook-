/// Central place for all constant values used across the app.
/// Keeping strings here avoids typos and duplicate hardcoded values.
class AppConstants {
  AppConstants._();

  static const String appName = 'MediBook';

  // Firestore collection names
  static const String usersCollection = 'users';
  static const String doctorsCollection = 'doctors';
  static const String categoriesCollection = 'categories';
  static const String appointmentsCollection = 'appointments';

  // Appointment status values
  static const String statusUpcoming = 'upcoming';
  static const String statusCompleted = 'completed';
  static const String statusCancelled = 'cancelled';

  // Default time slots offered by doctors if not customized
  static const List<String> defaultTimeSlots = [
    '09:00 AM',
    '10:00 AM',
    '11:00 AM',
    '02:00 PM',
    '03:00 PM',
    '04:00 PM',
  ];

  // Validation
  static const int minPasswordLength = 6;
  static const int mobileNumberLength = 10;
}
