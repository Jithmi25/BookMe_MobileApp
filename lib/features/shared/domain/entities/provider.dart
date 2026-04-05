import 'dart:convert';

import 'package:book_me_mobile_app/app/utils/json_utils.dart';

class Provider {
  const Provider({
    required this.id,
    required this.userId,
    required this.skills,
    required this.serviceAreas,
    required this.experienceYears,
    this.availability,
    required this.priceMin,
    required this.priceMax,
    required this.ratingAvg,
    required this.ratingCount,
    required this.nicVerified,
    required this.photoVerified,
  });

  final String id;
  final String userId;
  final List<String> skills;
  final List<String> serviceAreas;
  final int experienceYears;
  final String? availability;
  final double priceMin;
  final double priceMax;
  final double ratingAvg;
  final int ratingCount;
  final bool nicVerified;
  final bool photoVerified;

  Provider copyWith({
    String? id,
    String? userId,
    List<String>? skills,
    List<String>? serviceAreas,
    int? experienceYears,
    String? availability,
    double? priceMin,
    double? priceMax,
    double? ratingAvg,
    int? ratingCount,
    bool? nicVerified,
    bool? photoVerified,
  }) {
    return Provider(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      skills: skills ?? this.skills,
      serviceAreas: serviceAreas ?? this.serviceAreas,
      experienceYears: experienceYears ?? this.experienceYears,
      availability: availability ?? this.availability,
      priceMin: priceMin ?? this.priceMin,
      priceMax: priceMax ?? this.priceMax,
      ratingAvg: ratingAvg ?? this.ratingAvg,
      ratingCount: ratingCount ?? this.ratingCount,
      nicVerified: nicVerified ?? this.nicVerified,
      photoVerified: photoVerified ?? this.photoVerified,
    );
  }

  factory Provider.fromRawJson(String source) {
    return Provider.fromJson(jsonDecode(source) as Map<String, dynamic>);
  }

  String toRawJson() {
    return jsonEncode(toJson());
  }

  factory Provider.fromJson(Map<String, dynamic> json) {
    return Provider(
      id: (json['id'] as String?) ?? (json['providerId'] as String?) ?? '',
      userId: (json['userId'] as String?) ?? '',
      skills: JsonUtils.parseStringList(json['skills']),
      serviceAreas: JsonUtils.parseStringList(json['serviceAreas']),
      experienceYears: (json['experienceYears'] as num?)?.toInt() ?? 0,
      availability: json['availability'] as String?,
      priceMin: (json['priceMin'] as num?)?.toDouble() ?? 0,
      priceMax: (json['priceMax'] as num?)?.toDouble() ?? 0,
      ratingAvg: (json['ratingAvg'] as num?)?.toDouble() ?? 0,
      ratingCount: (json['ratingCount'] as num?)?.toInt() ?? 0,
      nicVerified: (json['nicVerified'] as bool?) ?? false,
      photoVerified: (json['photoVerified'] as bool?) ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'skills': skills,
      'serviceAreas': serviceAreas,
      'experienceYears': experienceYears,
      'availability': availability,
      'priceMin': priceMin,
      'priceMax': priceMax,
      'ratingAvg': ratingAvg,
      'ratingCount': ratingCount,
      'nicVerified': nicVerified,
      'photoVerified': photoVerified,
    };
  }
}
