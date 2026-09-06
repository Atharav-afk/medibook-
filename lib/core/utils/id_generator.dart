import 'package:uuid/uuid.dart';

/// Generates unique, human-friendly booking IDs.
class IdGenerator {
  IdGenerator._();

  static const _uuid = Uuid();

  /// Produces something like "MB-3F2A9C1B" for easy display to the user.
  static String bookingId() {
    final raw = _uuid.v4().replaceAll('-', '').substring(0, 8).toUpperCase();
    return 'MB-$raw';
  }
}
