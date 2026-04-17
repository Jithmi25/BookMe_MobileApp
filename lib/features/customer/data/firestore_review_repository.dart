import 'package:book_me_mobile_app/features/customer/data/local_mock_review_repository.dart';
import 'package:book_me_mobile_app/features/shared/domain/entities/review.dart';
import 'package:book_me_mobile_app/features/shared/domain/repositories/review_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class FirestoreReviewRepository implements ReviewRepository {
  FirestoreReviewRepository({
    FirebaseFirestore? firestore,
    LocalMockReviewRepository? fallbackRepository,
  }) : _firestore = firestore,
       _fallbackRepository =
           fallbackRepository ?? const LocalMockReviewRepository();

  final FirebaseFirestore? _firestore;
  final LocalMockReviewRepository _fallbackRepository;

  @override
  Future<Review> submitReview({
    required String bookingId,
    required String customerId,
    required String providerId,
    required int stars,
    required String comment,
  }) async {
    if (Firebase.apps.isEmpty) {
      return _fallbackRepository.submitReview(
        bookingId: bookingId,
        customerId: customerId,
        providerId: providerId,
        stars: stars,
        comment: comment,
      );
    }

    final firestore = _firestore ?? FirebaseFirestore.instance;

    final review = Review(
      id: firestore.collection('reviews').doc().id,
      bookingId: bookingId,
      customerId: customerId,
      providerId: providerId,
      stars: stars.clamp(1, 5),
      comment: comment.trim(),
      createdAt: DateTime.now(),
    );

    await firestore.collection('reviews').doc(review.id).set(review.toJson());

    // Update provider's aggregate rating
    await updateProviderRating(providerId: providerId, reviews: [review]);

    return review;
  }

  @override
  Future<List<Review>> getReviewsForProvider(String providerId) async {
    if (Firebase.apps.isEmpty) {
      return _fallbackRepository.getReviewsForProvider(providerId);
    }

    final firestore = _firestore ?? FirebaseFirestore.instance;

    final snapshot = await firestore
        .collection('reviews')
        .where('providerId', isEqualTo: providerId)
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => Review.fromJson(doc.data()))
        .toList(growable: false);
  }

  @override
  Future<bool> updateProviderRating({
    required String providerId,
    required List<Review> reviews,
  }) async {
    if (Firebase.apps.isEmpty) {
      return _fallbackRepository.updateProviderRating(
        providerId: providerId,
        reviews: reviews,
      );
    }

    final firestore = _firestore ?? FirebaseFirestore.instance;

    // Fetch all reviews for this provider
    final allReviews = await getReviewsForProvider(providerId);

    if (allReviews.isEmpty) {
      return true;
    }

    // Calculate aggregate rating
    final totalStars = allReviews.fold<int>(
      0,
      (total, review) => total + review.stars,
    );
    final averageRating = totalStars / allReviews.length;

    // Update provider document with new rating and count
    await firestore.collection('providers').doc(providerId).update({
      'ratingAvg': averageRating,
      'ratingCount': allReviews.length,
    });

    return true;
  }
}
