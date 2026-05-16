import 'package:book_me_mobile_app/app/router/app_router.dart';
import 'package:book_me_mobile_app/features/auth/application/auth_controller.dart';
import 'package:book_me_mobile_app/features/customer/data/firestore_booking_repository.dart';
import 'package:book_me_mobile_app/features/provider/presentation/provider_booking_history_screen.dart';
import 'package:book_me_mobile_app/features/provider/presentation/provider_booking_requests_screen.dart';
import 'package:book_me_mobile_app/features/provider/presentation/provider_profile_screen.dart';
import 'package:book_me_mobile_app/features/shared/domain/entities/booking.dart';
import 'package:flutter/material.dart';

class ProviderHomeScreen extends StatefulWidget {
  const ProviderHomeScreen({required this.authController, super.key});

  final AuthController authController;

  @override
  State<ProviderHomeScreen> createState() => _ProviderHomeScreenState();
}

class _ProviderHomeScreenState extends State<ProviderHomeScreen> {
  static const String _providerId = 'provider_nimal';
  static const String _providerName = 'Nimal Perera';
  static const String _providerSkill = 'Plumber';
  static const String _providerArea = 'Colombo 05, Colombo 07, Rajagiriya';
  static const List<String> _weekSlots = <String>[
    'Mon 08:00',
    'Mon 10:00',
    'Mon 14:00',
    'Tue 09:00',
    'Tue 16:00',
    'Wed 11:00',
    'Fri 15:00',
  ];

  final FirestoreBookingRepository _bookingRepository =
      FirestoreBookingRepository();

  late Future<List<Booking>> _bookingsFuture;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _bookingsFuture = _loadBookings();
  }

  Future<List<Booking>> _loadBookings() {
    return _bookingRepository.getBookingsForProvider(_providerId);
  }

  void _refreshBookings() {
    setState(() {
      _bookingsFuture = _loadBookings();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.authController.state;
    final providerPhone = state.phoneNumber ?? 'provider_guest';
    final title = switch (_currentIndex) {
      0 => 'Calendar',
      1 => 'Booking Request',
      2 => 'Notifications',
      3 => 'Account',
      4 => 'History',
      _ => 'Provider Home',
    };

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            onPressed: () {
              widget.authController.signOut();
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
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: [
            _ProviderHomeTab(
              providerId: _providerId,
              providerName: _providerName,
              providerSkill: _providerSkill,
              providerArea: _providerArea,
              providerPhone: providerPhone,
              weekSlots: _weekSlots,
              bookingsFuture: _bookingsFuture,
              onRefresh: _refreshBookings,
            ),
            ProviderBookingRequestsScreen(
              providerId: _providerId,
              repository: _bookingRepository,
            ),
            const _ProviderNotificationsTab(),
            ProviderProfileScreen(authController: widget.authController),
            ProviderBookingHistoryScreen(
              providerId: _providerId,
              repository: _bookingRepository,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_outlined),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inbox_rounded),
            label: 'Booking Request',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_outlined),
            label: 'Notification',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Account',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_rounded),
            label: 'History',
          ),
        ],
      ),
    );
  }
}

class _ProviderNotificationsTab extends StatelessWidget {
  const _ProviderNotificationsTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        _NotificationCard(
          icon: Icons.verified_user_rounded,
          title: 'Profile verified',
          subtitle: 'Your photo and ID badges are active in the demo.',
        ),
        SizedBox(height: 12),
        _NotificationCard(
          icon: Icons.payments_rounded,
          title: 'Escrow payment held',
          subtitle: 'Funds will release after the customer confirms the job.',
        ),
        SizedBox(height: 12),
        _NotificationCard(
          icon: Icons.translate_rounded,
          title: 'Chat translation enabled',
          subtitle: 'Sinhala, Tamil, and English records are stored locally.',
        ),
      ],
    );
  }
}

class _NotificationCard extends StatelessWidget {
  const _NotificationCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(subtitle),
      ),
    );
  }
}

class _ProviderHomeTab extends StatelessWidget {
  const _ProviderHomeTab({
    required this.providerId,
    required this.providerName,
    required this.providerSkill,
    required this.providerArea,
    required this.providerPhone,
    required this.weekSlots,
    required this.bookingsFuture,
    required this.onRefresh,
  });

  final String providerId;
  final String providerName;
  final String providerSkill;
  final String providerArea;
  final String providerPhone;
  final List<String> weekSlots;
  final Future<List<Booking>> bookingsFuture;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        onRefresh();
        await bookingsFuture;
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primaryContainer,
                    Theme.of(context).colorScheme.secondaryContainer,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(28),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome back, $providerName',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$providerSkill • $providerArea',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Signed in as $providerPhone',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: const [
                      Chip(label: Text('Photo verified')),
                      Chip(label: Text('ID verified')),
                      Chip(label: Text('5-star rated')),
                      Chip(label: Text('Smart slots active')),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            FutureBuilder<List<Booking>>(
              future: bookingsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox(
                    height: 140,
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                final bookings = snapshot.data ?? const <Booking>[];
                final pending = bookings
                    .where((booking) => booking.status == 'pending')
                    .length;
                final accepted = bookings
                    .where((booking) => booking.status == 'accepted')
                    .length;
                final completed = bookings
                    .where((booking) => booking.status == 'completed')
                    .length;
                final disputed = bookings
                    .where((booking) => booking.status == 'disputed')
                    .length;
                final revenue = bookings
                    .where((booking) => booking.status == 'completed')
                    .fold<double>(0, (sum, booking) => sum + booking.amount);

                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _StatCard(
                            label: 'Pending',
                            value: pending.toString(),
                            icon: Icons.inbox_rounded,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _StatCard(
                            label: 'Accepted',
                            value: accepted.toString(),
                            icon: Icons.verified_rounded,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _StatCard(
                            label: 'Completed',
                            value: completed.toString(),
                            icon: Icons.check_circle_rounded,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _StatCard(
                            label: 'Disputed',
                            value: disputed.toString(),
                            icon: Icons.report_gmailerrorred_rounded,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _RevenueCard(revenue: revenue),
                  ],
                );
              },
            ),
            const SizedBox(height: 20),
            Text(
              'Live calendar',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: weekSlots
                  .map(
                    (slot) => Chip(
                      avatar: const Icon(Icons.event_available_rounded, size: 16),
                      label: Text(slot),
                    ),
                  )
                  .toList(growable: false),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Smart slot booking',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Choose from preset service windows so customers can book available time slots without overlap.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: const [
                        FilterChip(
                          label: Text('Morning'),
                          selected: true,
                          onSelected: null,
                        ),
                        FilterChip(
                          label: Text('Afternoon'),
                          selected: false,
                          onSelected: null,
                        ),
                        FilterChip(
                          label: Text('Emergency'),
                          selected: false,
                          onSelected: null,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Today\'s focus',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '1. Confirm new requests\n2. Complete accepted jobs\n3. Release payment after confirmation',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onRefresh,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Refresh dashboard'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon),
            const SizedBox(height: 12),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            Text(label),
          ],
        ),
      ),
    );
  }
}

class _RevenueCard extends StatelessWidget {
  const _RevenueCard({required this.revenue});

  final double revenue;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Icon(Icons.payments_rounded),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Completed revenue',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  'LKR ${revenue.toStringAsFixed(0)}',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.lock_rounded),
        ],
      ),
    );
  }
}
