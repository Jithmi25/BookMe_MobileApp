import 'package:book_me_mobile_app/app/router/app_router.dart';
import 'package:book_me_mobile_app/features/auth/application/auth_controller.dart';
import 'package:book_me_mobile_app/features/customer/data/firestore_booking_repository.dart';
import 'package:book_me_mobile_app/features/provider/presentation/provider_booking_history_screen.dart';
import 'package:book_me_mobile_app/features/provider/presentation/provider_booking_requests_screen.dart';
import 'package:flutter/material.dart';

class ProviderHomeScreen extends StatelessWidget {
  const ProviderHomeScreen({required this.authController, super.key});

  final AuthController authController;

  @override
  Widget build(BuildContext context) {
    final state = authController.state;
    const providerId = 'provider_nimal';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Provider Home'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, AppRouter.providerProfile);
            },
            icon: const Icon(Icons.person),
            tooltip: 'My Profile',
          ),
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
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Signed in as ${state.phoneNumber ?? '-'}\n'
                'Next: profile setup, availability, and booking request management.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => ProviderBookingRequestsScreen(
                        providerId: providerId,
                        repository: FirestoreBookingRepository(),
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.inbox_rounded),
                label: const Text('View booking requests'),
              ),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => ProviderBookingHistoryScreen(
                        providerId: providerId,
                        repository: FirestoreBookingRepository(),
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.history_rounded),
                label: const Text('View booking history'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
