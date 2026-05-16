import 'package:book_me_mobile_app/app/constants/constants.dart';
import 'package:book_me_mobile_app/features/shared/domain/entities/booking.dart';
import 'package:book_me_mobile_app/features/shared/domain/repositories/booking_repository.dart';

class LocalMockBookingRepository implements BookingRepository {
  const LocalMockBookingRepository();

  static final List<Booking> _bookings = <Booking>[
    Booking(
      id: 'booking_0001',
      customerId: '0701234567',
      providerId: 'provider_nimal',
      category: 'Plumber',
      date: DateTime.now().add(const Duration(days: 1)),
      time: '10:00',
      note: 'Fix kitchen leak and replace washer',
      status: BookingStatuses.pending,
      paymentMethod: 'cash',
      amount: 3500,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Booking(
      id: 'booking_0002',
      customerId: '0701234567',
      providerId: 'provider_kasun',
      category: 'Electrician',
      date: DateTime.now(),
      time: '14:00',
      note: 'Replace damaged wiring in lounge',
      status: BookingStatuses.accepted,
      paymentMethod: 'card',
      amount: 4500,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Booking(
      id: 'booking_0003',
      customerId: '0701234567',
      providerId: 'provider_sajini',
      category: 'Cleaner',
      date: DateTime.now().subtract(const Duration(days: 3)),
      time: '09:00',
      note: 'Deep clean bathroom and kitchen',
      status: BookingStatuses.completed,
      paymentMethod: 'mobile_wallet',
      amount: 2200,
      createdAt: DateTime.now().subtract(const Duration(days: 6)),
    ),
    Booking(
      id: 'booking_0004',
      customerId: '0709998887',
      providerId: 'provider_dinesh',
      category: 'Carpenter',
      date: DateTime.now().add(const Duration(days: 2)),
      time: '11:00',
      note: 'Build small storage shelf',
      status: BookingStatuses.cancelled,
      paymentMethod: 'cash',
      amount: 4800,
      createdAt: DateTime.now().subtract(const Duration(days: 4)),
    ),
    Booking(
      id: 'booking_0005',
      customerId: '0701234567',
      providerId: 'provider_tharindu',
      category: 'Plumber',
      date: DateTime.now().subtract(const Duration(days: 1)),
      time: '16:00',
      note: 'Emergency pipe replacement',
      status: BookingStatuses.disputed,
      paymentMethod: 'card',
      amount: 5200,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
  ];
  static int _idCounter = 6;

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
