import 'package:book_me_mobile_app/features/shared/domain/entities/review.dart';

abstract class ReviewRepository {
  Future<Review> submitReview({
    required String bookingId,
    required String customerId,
    required String providerId,
    required int stars,
    required String comment,
  });

  Future<List<Review>> getReviewsForProvider(String providerId);

  Future<bool> updateProviderRating({
    required String providerId,
    required List<Review> reviews,
  });
}
