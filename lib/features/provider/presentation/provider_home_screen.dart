import 'package:book_me_mobile_app/app/router/app_router.dart';
import 'package:book_me_mobile_app/features/auth/application/auth_controller.dart';
import 'package:flutter/material.dart';

class ProviderHomeScreen extends StatelessWidget {
  const ProviderHomeScreen({required this.authController, super.key});

  final AuthController authController;

  @override
  Widget build(BuildContext context) {
    final state = authController.state;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Provider Home'),
        actions: [
          IconButton(
            onPressed: () {
              authController.signOut();
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRouter.roleSelection,
                (route) => false,
              );
            },
            icon: const Icon(Icons.logout),
            tooltip: 'Sign out',
          ),
        ],
      ),
      body: Center(
        child: Text(
          'Signed in as ${state.phoneNumber ?? '-'}\n'
          'Next: profile setup, availability, and booking request management.',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
