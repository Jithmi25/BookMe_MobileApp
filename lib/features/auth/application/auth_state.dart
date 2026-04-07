import 'package:book_me_mobile_app/app/constants/constants.dart';

class AuthState {
  const AuthState._({
    required this.isAuthenticated,
    this.phoneNumber,
    this.role,
  });

  const AuthState.unauthenticated()
    : this._(isAuthenticated: false, phoneNumber: null, role: null);

  const AuthState.authenticated({
    required String phoneNumber,
    required String role,
  }) : this._(isAuthenticated: true, phoneNumber: phoneNumber, role: role);

  final bool isAuthenticated;
  final String? phoneNumber;
  final String? role;

  bool get isCustomer => role == UserRoles.customer;
  bool get isProvider => role == UserRoles.provider;
}
