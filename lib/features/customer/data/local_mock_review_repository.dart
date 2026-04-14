import 'package:book_me_mobile_app/features/shared/domain/entities/review.dart';
import 'package:book_me_mobile_app/features/shared/domain/repositories/review_repository.dart';

class LocalMockReviewRepository implements ReviewRepository {
  const LocalMockReviewRepository();

  static final List<Review> _reviews = <Review>[];
  static int _idCounter = 1;

  @override
  Future<Review> submitReview({
    required String bookingId,
    required String customerId,
    required String providerId,
    required int stars,
    required String comment,
  }) {
    final review = Review(
      id: 'review_${_idCounter.toString().padLeft(4, '0')}',
      bookingId: bookingId,
      customerId: customerId,
      providerId: providerId,
      stars: stars.clamp(1, 5),
      comment: comment.trim(),
      createdAt: DateTime.now(),
    );

    _idCounter += 1;
    _reviews.add(review);
    return Future<Review>.value(review);
  }

  @override
  Future<List<Review>> getReviewsForProvider(String providerId) async {
    return _reviews
        .where((review) => review.providerId == providerId)
        .toList(growable: false);
  }

  @override
  Future<bool> updateProviderRating({
    required String providerId,
    required List<Review> reviews,
  }) {
    // Local mock doesn't persist provider rating updates
    return Future<bool>.value(true);
  }
}
