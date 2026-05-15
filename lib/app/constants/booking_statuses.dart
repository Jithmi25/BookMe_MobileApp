class BookingStatuses {
  const BookingStatuses._();

  static const String pending = 'pending';
  static const String accepted = 'accepted';
  static const String completed = 'completed';
  static const String cancelled = 'cancelled';
  static const String disputed = 'disputed';

  static const List<String> all = [
    pending,
    accepted,
    completed,
    cancelled,
    disputed,
  ];

  static bool isValid(String value) {
    return all.contains(value);
  }
}
