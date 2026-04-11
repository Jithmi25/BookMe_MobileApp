import 'package:book_me_mobile_app/app/constants/constants.dart';
import 'package:book_me_mobile_app/features/shared/domain/entities/booking.dart';
import 'package:book_me_mobile_app/features/shared/domain/repositories/booking_repository.dart';

class LocalMockBookingRepository implements BookingRepository {
  const LocalMockBookingRepository();

  static final List<Booking> _bookings = <Booking>[];
  static int _idCounter = 1;

  @override
  Future<Booking> createBookingRequest({
    required String customerId,
    required String providerId,
    required String category,
    required DateTime date,
    required String time,
    required String note,
    required String paymentMethod,
    required double amount,
  }) {
    final normalizedCustomerId = customerId.trim().isEmpty
        ? 'customer_guest'
        : customerId.trim();

    final booking = Booking(
      id: 'booking_${_idCounter.toString().padLeft(4, '0')}',
      customerId: normalizedCustomerId,
      providerId: providerId,
      category: category,
      date: DateTime(date.year, date.month, date.day),
      time: time,
      note: note.trim(),
      status: BookingStatuses.pending,
      paymentMethod: paymentMethod,
      amount: amount,
      createdAt: DateTime.now(),
    );

    _idCounter += 1;
    _bookings.add(booking);
    return Future<Booking>.value(booking);
  }

  @override
  Future<List<Booking>> getBookingsForProvider(String providerId) async {
    return _bookings
        .where((booking) => booking.providerId == providerId)
        .toList(growable: false);
  }

  @override
  Future<List<Booking>> getBookingsForCustomer(String customerId) async {
    return _bookings
        .where((booking) => booking.customerId == customerId)
        .toList(growable: false);
  }

  @override
  Future<Booking?> updateBookingStatus({
    required String bookingId,
    required String status,
  }) async {
    final bookingIndex = _bookings.indexWhere(
      (booking) => booking.id == bookingId,
    );
    if (bookingIndex == -1) {
      return null;
    }

    final updatedBooking = _bookings[bookingIndex].copyWith(status: status);
    _bookings[bookingIndex] = updatedBooking;
    return updatedBooking;
  }
}
