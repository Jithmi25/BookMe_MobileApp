import 'package:book_me_mobile_app/app/constants/constants.dart';
import 'package:book_me_mobile_app/features/shared/domain/entities/booking.dart';
import 'package:book_me_mobile_app/features/shared/domain/entities/provider.dart';

class LocalMockBookingRepository {
  const LocalMockBookingRepository();

  static final List<Booking> _bookings = <Booking>[];
  static int _idCounter = 1;

  Booking createBookingRequest({
    required String customerId,
    required Provider provider,
    required DateTime date,
    required String time,
    required String note,
    required String paymentMethod,
  }) {
    final normalizedCustomerId = customerId.trim().isEmpty
        ? 'customer_guest'
        : customerId.trim();
    final category = provider.skills.isNotEmpty
        ? provider.skills.first
        : 'General';

    final booking = Booking(
      id: 'booking_${_idCounter.toString().padLeft(4, '0')}',
      customerId: normalizedCustomerId,
      providerId: provider.id,
      category: category,
      date: DateTime(date.year, date.month, date.day),
      time: time,
      note: note.trim(),
      status: BookingStatuses.pending,
      paymentMethod: paymentMethod,
      amount: (provider.priceMin + provider.priceMax) / 2,
      createdAt: DateTime.now(),
    );

    _idCounter += 1;
    _bookings.add(booking);
    return booking;
  }

  List<Booking> getBookingsForCustomer(String customerId) {
    return _bookings
        .where((booking) => booking.customerId == customerId)
        .toList(growable: false);
  }
}
