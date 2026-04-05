import 'dart:convert';

import 'package:book_me_mobile_app/app/constants/constants.dart';
import 'package:book_me_mobile_app/app/utils/json_utils.dart';

class User {
  const User({
    required this.id,
    required this.role,
    required this.name,
    required this.phone,
    this.profilePhoto,
    required this.createdAt,
  });

  final String id;
  final String role;
  final String name;
  final String phone;
  final String? profilePhoto;
  final DateTime createdAt;

  User copyWith({
    String? id,
    String? role,
    String? name,
    String? phone,
    String? profilePhoto,
    DateTime? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      role: role ?? this.role,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory User.fromRawJson(String source) {
    return User.fromJson(jsonDecode(source) as Map<String, dynamic>);
  }

  String toRawJson() {
    return jsonEncode(toJson());
  }

  factory User.fromJson(Map<String, dynamic> json) {
    final roleValue = (json['role'] as String?) ?? UserRoles.customer;

    return User(
      id: (json['id'] as String?) ?? (json['userId'] as String?) ?? '',
      role: UserRoles.isValid(roleValue) ? roleValue : UserRoles.customer,
      name: (json['name'] as String?) ?? '',
      phone: (json['phone'] as String?) ?? '',
      profilePhoto: json['profilePhoto'] as String?,
      createdAt: JsonUtils.parseDateTime(json['createdAt']) ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'role': role,
      'name': name,
      'phone': phone,
      'profilePhoto': profilePhoto,
      'createdAt': JsonUtils.writeDateTime(createdAt),
    };
  }
}
