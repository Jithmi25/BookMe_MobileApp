import 'package:book_me_mobile_app/core/localization/localization_service.dart';
import 'package:book_me_mobile_app/features/customer/data/firestore_booking_repository.dart';
import 'package:book_me_mobile_app/features/customer/presentation/booking_request_screen.dart';
import 'package:book_me_mobile_app/features/shared/domain/entities/booking.dart';
import 'package:book_me_mobile_app/features/shared/domain/entities/provider.dart';
import 'package:book_me_mobile_app/features/shared/domain/repositories/booking_repository.dart';
import 'package:book_me_mobile_app/features/shared/presentation/widgets/async_state_widgets.dart';
import 'package:book_me_mobile_app/app/constants/constants.dart';
import 'package:flutter/material.dart';

class ActivitiesScreen extends StatefulWidget {
  const ActivitiesScreen({
    required this.customerId,
    required this.loc,
    super.key,
  });

  final String customerId;
  final LocalizationService loc;

  @override
  State<ActivitiesScreen> createState() => _ActivitiesScreenState();
}

class _ActivitiesScreenState extends State<ActivitiesScreen> {
  final BookingRepository _repo = FirestoreBookingRepository();
  late Future<List<Booking>> _bookingsFuture;
  int _tabIndex = 0;

  @override
  void initState() {
    super.initState();
    _bookingsFuture = _loadBookings();
  }

  Future<List<Booking>> _loadBookings() =>
      _repo.getBookingsForCustomer(widget.customerId);

  void _refresh() => setState(() => _bookingsFuture = _loadBookings());

  @override
  Widget build(BuildContext context) {
    final loc = widget.loc;

    final tabs = [
      loc.t('ongoing'),
      loc.t('completed'),
      loc.t('complaints'),
      loc.t('cancelled'),
    ];

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(
                tabs.length,
                (i) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(tabs[i]),
                    selected: _tabIndex == i,
                    onSelected: (_) => setState(() => _tabIndex = i),
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: FutureBuilder<List<Booking>>(
            future: _bookingsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const AppLoadingState(message: 'Loading activities...');
              }

              if (snapshot.hasError) {
                return AppErrorState(
                  message: 'Failed to load activities',
                  onRetry: _refresh,
                );
              }

              final bookings = snapshot.data ?? const <Booking>[];

              final filtered = bookings
                  .where((b) {
                    return switch (_tabIndex) {
                      0 =>
                        b.status == BookingStatuses.accepted ||
                            b.status == BookingStatuses.pending,
                      1 => b.status == BookingStatuses.completed,
                      2 => b.status == BookingStatuses.disputed,
                      3 => b.status == BookingStatuses.cancelled,
                      _ => false,
                    };
                  })
                  .toList(growable: false);

              if (filtered.isEmpty) {
                return AppEmptyState(title: 'No activities in this section');
              }

              return ListView.separated(
                padding: const EdgeInsets.all(12),
                itemCount: filtered.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final b = filtered[index];
                  return Card(
                    child: ListTile(
                      title: Text(b.category),
                      subtitle: Text(
                        'Provider ${b.providerId} • ${b.date.toLocal().toString().split(' ').first} ${b.time}',
                      ),
                      trailing: Wrap(
                        spacing: 8,
                        children: [
                          if (_tabIndex == 0)
                            TextButton.icon(
                              onPressed: () => _showEmergency(b),
                              icon: const Icon(
                                Icons.warning_amber_rounded,
                                color: Colors.red,
                              ),
                              label: Text(widget.loc.t('sos')),
                            ),
                          if (_tabIndex == 1)
                            FilledButton.tonalIcon(
                              onPressed: () => _rebook(b),
                              icon: const Icon(Icons.replay_rounded),
                              label: Text(widget.loc.t('rebook')),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  void _rebook(Booking booking) {
    final provider = Provider(
      id: booking.providerId,
      userId: booking.providerId,
      skills: [booking.category],
      serviceAreas: const <String>[],
      experienceYears: 0,
      availability: 'Re-book available',
      priceMin: booking.amount,
      priceMax: booking.amount,
      ratingAvg: 0,
      ratingCount: 0,
      nicVerified: false,
      photoVerified: false,
    );

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => BookingRequestScreen(
          provider: provider,
          customerId: widget.customerId,
        ),
      ),
    );
  }

  void _showEmergency(Booking booking) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Emergency'),
        content: Text('Send emergency alert for booking ${booking.id}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Emergency alert sent')),
              );
            },
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }
}
