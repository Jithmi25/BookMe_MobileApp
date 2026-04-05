class BookingStatuses {
  const BookingStatuses._();

  static const String pending = 'pending';
  static const String accepted = 'accepted';
  static const String completed = 'completed';
  static const String cancelled = 'cancelled';

  static const List<String> all = [pending, accepted, completed, cancelled];

  static bool isValid(String value) {
    return all.contains(value);
  }
}
