import 'package:book_me_mobile_app/features/auth/presentation/role_selection_screen.dart';
import 'package:book_me_mobile_app/features/customer/presentation/customer_home_screen.dart';
import 'package:book_me_mobile_app/features/provider/presentation/provider_home_screen.dart';
import 'package:flutter/widgets.dart';

class AppRouter {
  const AppRouter._();

  static const String roleSelection = '/';
  static const String customerHome = '/customer-home';
  static const String providerHome = '/provider-home';

  static Map<String, WidgetBuilder> get routes {
    return {
      roleSelection: (_) => const RoleSelectionScreen(),
      customerHome: (_) => const CustomerHomeScreen(),
      providerHome: (_) => const ProviderHomeScreen(),
    };
  }
}
