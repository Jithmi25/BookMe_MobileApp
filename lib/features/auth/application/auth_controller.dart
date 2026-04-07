import 'package:book_me_mobile_app/app/constants/constants.dart';
import 'package:book_me_mobile_app/features/auth/application/auth_state.dart';
import 'package:flutter/foundation.dart';

class AuthController extends ChangeNotifier {
  AuthState _state = const AuthState.unauthenticated();

  AuthState get state => _state;

  void signInWithPhone({required String phoneNumber, required String role}) {
    if (!UserRoles.isValid(role)) {
      return;
    }

    _state = AuthState.authenticated(phoneNumber: phoneNumber, role: role);
    notifyListeners();
  }

  void signOut() {
    _state = const AuthState.unauthenticated();
    notifyListeners();
  }
}
