import 'package:book_me_mobile_app/features/auth/application/auth_controller.dart';
import 'package:book_me_mobile_app/features/auth/presentation/role_selection_screen.dart';
import 'package:book_me_mobile_app/features/customer/presentation/customer_home_screen.dart';
import 'package:book_me_mobile_app/features/provider/presentation/provider_home_screen.dart';
import 'package:flutter/material.dart';

class AppRouter {
  const AppRouter._();

  static const String roleSelection = '/';
  static const String customerHome = '/customer-home';
  static const String providerHome = '/provider-home';

  static Route<dynamic> generateRoute({
    required RouteSettings settings,
    required AuthController authController,
  }) {
    final targetRoute = _guardRoute(
      requestedRoute: settings.name,
      authController: authController,
    );

    switch (targetRoute) {
      case customerHome:
        return MaterialPageRoute(
          settings: const RouteSettings(name: customerHome),
          builder: (_) => CustomerHomeScreen(authController: authController),
        );
      case providerHome:
        return MaterialPageRoute(
          settings: const RouteSettings(name: providerHome),
          builder: (_) => ProviderHomeScreen(authController: authController),
        );
      case roleSelection:
      default:
        return MaterialPageRoute(
          settings: const RouteSettings(name: roleSelection),
          builder: (_) => RoleSelectionScreen(authController: authController),
        );
    }
  }

  static String _guardRoute({
    required String? requestedRoute,
    required AuthController authController,
  }) {
    final currentRoute = requestedRoute ?? roleSelection;
    final authState = authController.state;

    if (!authState.isAuthenticated) {
      if (currentRoute == customerHome || currentRoute == providerHome) {
        return roleSelection;
      }
      return roleSelection;
    }

    if (currentRoute == roleSelection) {
      return authState.isProvider ? providerHome : customerHome;
    }

    if (currentRoute == customerHome && authState.isProvider) {
      return providerHome;
    }

    if (currentRoute == providerHome && authState.isCustomer) {
      return customerHome;
    }

    return currentRoute;
  }
}
