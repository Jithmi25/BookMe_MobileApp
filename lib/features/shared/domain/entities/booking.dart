import 'dart:convert';

import 'package:book_me_mobile_app/app/constants/constants.dart';
import 'package:book_me_mobile_app/app/utils/json_utils.dart';

class Booking {
  const Booking({
    required this.id,
    required this.customerId,
    required this.providerId,
    required this.category,
    required this.date,
    required this.time,
    required this.note,
    required this.status,
    required this.paymentMethod,
    required this.amount,
    required this.createdAt,
  });

  final String id;
  final String customerId;
  final String providerId;
  final String category;
  final DateTime date;
  final String time;
  final String note;
  final String status;
  final String paymentMethod;
  final double amount;
  final DateTime createdAt;

  Booking copyWith({
    String? id,
    String? customerId,
    String? providerId,
    String? category,
    DateTime? date,
    String? time,
    String? note,
    String? status,
    String? paymentMethod,
    double? amount,
    DateTime? createdAt,
  }) {
    return Booking(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      providerId: providerId ?? this.providerId,
      category: category ?? this.category,
      date: date ?? this.date,
      time: time ?? this.time,
      note: note ?? this.note,
      status: status ?? this.status,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      amount: amount ?? this.amount,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory Booking.fromRawJson(String source) {
    return Booking.fromJson(jsonDecode(source) as Map<String, dynamic>);
  }

  String toRawJson() {
    return jsonEncode(toJson());
  }

  factory Booking.fromJson(Map<String, dynamic> json) {
    final statusValue = (json['status'] as String?) ?? BookingStatuses.pending;

    return Booking(
      id: (json['id'] as String?) ?? (json['bookingId'] as String?) ?? '',
      customerId: (json['customerId'] as String?) ?? '',
      providerId: (json['providerId'] as String?) ?? '',
      category: (json['category'] as String?) ?? '',
      date: JsonUtils.parseDateTime(json['date']) ?? DateTime.now(),
      time: (json['time'] as String?) ?? '',
      note: (json['note'] as String?) ?? '',
      status: BookingStatuses.isValid(statusValue)
          ? statusValue
          : BookingStatuses.pending,
      paymentMethod: (json['paymentMethod'] as String?) ?? 'cash',
      amount: (json['amount'] as num?)?.toDouble() ?? 0,
      createdAt: JsonUtils.parseDateTime(json['createdAt']) ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerId': customerId,
      'providerId': providerId,
      'category': category,
      'date': JsonUtils.writeDateTime(date),
      'time': time,
      'note': note,
      'status': status,
      'paymentMethod': paymentMethod,
      'amount': amount,
      'createdAt': JsonUtils.writeDateTime(createdAt),
    };
  }
}
