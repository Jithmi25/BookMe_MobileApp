import 'dart:convert';

import 'package:book_me_mobile_app/app/utils/json_utils.dart';

class Review {
  const Review({
    required this.id,
    required this.bookingId,
    required this.customerId,
    required this.providerId,
    required this.stars,
    required this.comment,
    required this.createdAt,
  });

  final String id;
  final String bookingId;
  final String customerId;
  final String providerId;
  final int stars;
  final String comment;
  final DateTime createdAt;

  Review copyWith({
    String? id,
    String? bookingId,
    String? customerId,
    String? providerId,
    int? stars,
    String? comment,
    DateTime? createdAt,
  }) {
    return Review(
      id: id ?? this.id,
      bookingId: bookingId ?? this.bookingId,
      customerId: customerId ?? this.customerId,
      providerId: providerId ?? this.providerId,
      stars: stars ?? this.stars,
      comment: comment ?? this.comment,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory Review.fromRawJson(String source) {
    return Review.fromJson(jsonDecode(source) as Map<String, dynamic>);
  }

  String toRawJson() {
    return jsonEncode(toJson());
  }

  factory Review.fromJson(Map<String, dynamic> json) {
    final parsedStars = (json['stars'] as num?)?.toInt() ?? 0;

    return Review(
      id: (json['id'] as String?) ?? (json['reviewId'] as String?) ?? '',
      bookingId: (json['bookingId'] as String?) ?? '',
      customerId: (json['customerId'] as String?) ?? '',
      providerId: (json['providerId'] as String?) ?? '',
      stars: parsedStars.clamp(1, 5),
      comment: (json['comment'] as String?) ?? '',
      createdAt: JsonUtils.parseDateTime(json['createdAt']) ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bookingId': bookingId,
      'customerId': customerId,
      'providerId': providerId,
      'stars': stars,
      'comment': comment,
      'createdAt': JsonUtils.writeDateTime(createdAt),
    };
  }
}
