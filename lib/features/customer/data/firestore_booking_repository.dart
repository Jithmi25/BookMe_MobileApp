import 'package:book_me_mobile_app/app/constants/constants.dart';
import 'package:book_me_mobile_app/features/customer/data/local_mock_booking_repository.dart';
import 'package:book_me_mobile_app/features/shared/domain/entities/booking.dart';
import 'package:book_me_mobile_app/features/shared/domain/repositories/booking_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class FirestoreBookingRepository implements BookingRepository {
  FirestoreBookingRepository({
    FirebaseFirestore? firestore,
    LocalMockBookingRepository? fallbackRepository,
  }) : _firestore = firestore ?? FirebaseFirestore.instance,
       _fallbackRepository =
           fallbackRepository ?? const LocalMockBookingRepository();

  final FirebaseFirestore _firestore;
  final LocalMockBookingRepository _fallbackRepository;

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
  }) async {
    if (Firebase.apps.isEmpty) {
      final booking = _fallbackRepository.createBookingRequest(
        customerId: customerId,
        providerId: providerId,
        category: category,
        date: date,
        time: time,
        note: note,
        paymentMethod: paymentMethod,
        amount: amount,
      );
      return booking;
    }

    final booking = Booking(
      id: _firestore.collection(FirestoreCollections.bookings).doc().id,
      customerId: customerId.trim().isEmpty
          ? 'customer_guest'
          : customerId.trim(),
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

    await _firestore
        .collection(FirestoreCollections.bookings)
        .doc(booking.id)
        .set(booking.toJson());

    return booking;
  }

  @override
  Future<List<Booking>> getBookingsForProvider(String providerId) async {
    if (Firebase.apps.isEmpty) {
      return _fallbackRepository.getBookingsForProvider(providerId);
    }

    final snapshot = await _firestore
        .collection(FirestoreCollections.bookings)
        .where('providerId', isEqualTo: providerId)
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => Booking.fromJson(doc.data()))
        .toList(growable: false);
  }

  @override
  Future<List<Booking>> getBookingsForCustomer(String customerId) async {
    if (Firebase.apps.isEmpty) {
      return _fallbackRepository.getBookingsForCustomer(customerId);
    }

    final snapshot = await _firestore
        .collection(FirestoreCollections.bookings)
        .where('customerId', isEqualTo: customerId)
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => Booking.fromJson(doc.data()))
        .toList(growable: false);
  }

  @override
  Future<Booking?> updateBookingStatus({
    required String bookingId,
    required String status,
  }) async {
    if (Firebase.apps.isEmpty) {
      return _fallbackRepository.updateBookingStatus(
        bookingId: bookingId,
        status: status,
      );
    }

    await _firestore
        .collection(FirestoreCollections.bookings)
        .doc(bookingId)
        .update({'status': status});

    final snapshot = await _firestore
        .collection(FirestoreCollections.bookings)
        .doc(bookingId)
        .get();

    if (!snapshot.exists || snapshot.data() == null) {
      return null;
    }

    return Booking.fromJson(snapshot.data()!);
  }
}
