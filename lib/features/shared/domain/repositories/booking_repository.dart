import 'package:book_me_mobile_app/features/shared/domain/entities/booking.dart';

abstract class BookingRepository {
  Future<Booking> createBookingRequest({
    required String customerId,
    required String providerId,
    required String category,
    required DateTime date,
    required String time,
    required String note,
    required String paymentMethod,
    required double amount,
  });

  Future<List<Booking>> getBookingsForProvider(String providerId);

  Future<List<Booking>> getBookingsForCustomer(String customerId);

  Future<Booking?> updateBookingStatus({
    required String bookingId,
    required String status,
  });
}
