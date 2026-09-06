import 'package:intl/intl.dart';

/// Helpers for formatting and comparing dates consistently across the app.
class DateTimeUtils {
  DateTimeUtils._();

  /// Storage format used in Firestore, e.g. 2026-08-22
  static String toStorageFormat(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  /// Display format shown to the user, e.g. 22 Aug 2026
  static String toDisplayFormat(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  static String toDisplayFromStorage(String storageDate) {
    try {
      final date = DateFormat('yyyy-MM-dd').parse(storageDate);
      return toDisplayFormat(date);
    } catch (_) {
      return storageDate;
    }
  }

  /// Returns the weekday name, e.g. "Monday", used to match availableDays.
  static String weekdayName(DateTime date) {
    return DateFormat('EEEE').format(date);
  }

  static bool isPastDate(DateTime date) {
    final today = DateTime.now();
    final justDate = DateTime(date.year, date.month, date.day);
    final justToday = DateTime(today.year, today.month, today.day);
    return justDate.isBefore(justToday);
  }
}
