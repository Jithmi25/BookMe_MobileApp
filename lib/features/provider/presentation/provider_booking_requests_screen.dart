import 'package:book_me_mobile_app/app/constants/constants.dart';
import 'package:book_me_mobile_app/features/shared/domain/entities/booking.dart';
import 'package:book_me_mobile_app/features/shared/domain/repositories/booking_repository.dart';
import 'package:flutter/material.dart';

class ProviderBookingRequestsScreen extends StatefulWidget {
  const ProviderBookingRequestsScreen({
    required this.providerId,
    required this.repository,
    super.key,
  });

  final String providerId;
  final BookingRepository repository;

  @override
  State<ProviderBookingRequestsScreen> createState() =>
      _ProviderBookingRequestsScreenState();
}

class _ProviderBookingRequestsScreenState
    extends State<ProviderBookingRequestsScreen> {
  late Future<List<Booking>> _bookingsFuture;
  final Set<String> _updatingBookingIds = <String>{};

  @override
  void initState() {
    super.initState();
    _bookingsFuture = _loadBookings();
  }

  Future<List<Booking>> _loadBookings() {
    return widget.repository.getBookingsForProvider(widget.providerId);
  }

  void _refreshBookings() {
    setState(() {
      _bookingsFuture = _loadBookings();
    });
  }

  Future<void> _updateStatus(Booking booking, String status) async {
    setState(() {
      _updatingBookingIds.add(booking.id);
    });

    try {
      await widget.repository.updateBookingStatus(
        bookingId: booking.id,
        status: status,
      );
      _refreshBookings();
    } finally {
      if (mounted) {
        setState(() {
          _updatingBookingIds.remove(booking.id);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Booking requests')),
      body: FutureBuilder<List<Booking>>(
        future: _bookingsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Failed to load booking requests.'),
                  const SizedBox(height: 8),
                  OutlinedButton(
                    onPressed: _refreshBookings,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final bookings = snapshot.data ?? const <Booking>[];
          final requests = bookings
              .where((booking) => booking.status == BookingStatuses.pending)
              .toList(growable: false);

          if (requests.isEmpty) {
            return const Center(
              child: Text('No pending booking requests right now.'),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              _refreshBookings();
              await _bookingsFuture;
            },
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: requests.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final booking = requests[index];
                final isUpdating = _updatingBookingIds.contains(booking.id);

                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          booking.category,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text('Booking ID: ${booking.id}'),
                        Text('Customer: ${booking.customerId}'),
                        Text(
                          'Date: ${_formatDate(booking.date)} at ${booking.time}',
                        ),
                        Text(
                          'Amount: LKR ${booking.amount.toStringAsFixed(0)}',
                        ),
                        const SizedBox(height: 8),
                        Text(
                          booking.note,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: isUpdating
                                    ? null
                                    : () => _updateStatus(
                                        booking,
                                        BookingStatuses.cancelled,
                                      ),
                                child: isUpdating
                                    ? const SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Text('Reject'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: isUpdating
                                    ? null
                                    : () => _updateStatus(
                                        booking,
                                        BookingStatuses.accepted,
                                      ),
                                child: const Text('Accept'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }
}
