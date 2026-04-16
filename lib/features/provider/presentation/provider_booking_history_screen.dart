import 'package:book_me_mobile_app/app/constants/constants.dart';
import 'package:book_me_mobile_app/features/shared/domain/entities/booking.dart';
import 'package:book_me_mobile_app/features/shared/domain/repositories/booking_repository.dart';
import 'package:book_me_mobile_app/features/shared/presentation/widgets/async_state_widgets.dart';
import 'package:flutter/material.dart';

class ProviderBookingHistoryScreen extends StatefulWidget {
  const ProviderBookingHistoryScreen({
    required this.providerId,
    required this.repository,
    super.key,
  });

  final String providerId;
  final BookingRepository repository;

  @override
  State<ProviderBookingHistoryScreen> createState() =>
      _ProviderBookingHistoryScreenState();
}

class _ProviderBookingHistoryScreenState
    extends State<ProviderBookingHistoryScreen> {
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

  Future<void> _markAsCompleted(Booking booking) async {
    setState(() {
      _updatingBookingIds.add(booking.id);
    });

    try {
      await widget.repository.updateBookingStatus(
        bookingId: booking.id,
        status: BookingStatuses.completed,
      );
      _refreshBookings();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to mark booking as completed. Try again.'),
          ),
        );
      }
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
      appBar: AppBar(title: const Text('Booking history')),
      body: FutureBuilder<List<Booking>>(
        future: _bookingsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const AppLoadingState(message: 'Loading booking history...');
          }

          if (snapshot.hasError) {
            return AppErrorState(
              message: 'Failed to load booking history.',
              onRetry: _refreshBookings,
            );
          }

          final bookings = snapshot.data ?? const <Booking>[];
          final history = bookings
              .where((booking) => booking.status != BookingStatuses.pending)
              .toList(growable: false);

          if (history.isEmpty) {
            return AppEmptyState(
              title: 'No accepted, completed, or cancelled bookings yet.',
              subtitle: 'Accepted bookings will appear here once updated.',
              icon: Icons.history_toggle_off_rounded,
              actionLabel: 'Reload',
              onAction: _refreshBookings,
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              _refreshBookings();
              await _bookingsFuture;
            },
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: history.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final booking = history[index];
                final isUpdating = _updatingBookingIds.contains(booking.id);

                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                booking.category,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                            _StatusChip(status: booking.status),
                          ],
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
                        Text(booking.note),
                        if (booking.status == BookingStatuses.accepted) ...[
                          const SizedBox(height: 12),
                          Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton.icon(
                              onPressed: isUpdating
                                  ? null
                                  : () => _markAsCompleted(booking),
                              icon: isUpdating
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Icon(Icons.task_alt_rounded),
                              label: const Text('Mark as completed'),
                            ),
                          ),
                        ],
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

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final colors = switch (status) {
      BookingStatuses.completed => (
        background: Colors.green.shade100,
        foreground: Colors.green.shade900,
      ),
      BookingStatuses.accepted => (
        background: Colors.blue.shade100,
        foreground: Colors.blue.shade900,
      ),
      BookingStatuses.cancelled => (
        background: Colors.red.shade100,
        foreground: Colors.red.shade900,
      ),
      _ => (
        background: Colors.orange.shade100,
        foreground: Colors.orange.shade900,
      ),
    };

    return Chip(
      label: Text(_labelFor(status)),
      backgroundColor: colors.background,
      labelStyle: TextStyle(
        color: colors.foreground,
        fontWeight: FontWeight.w600,
      ),
      visualDensity: VisualDensity.compact,
      side: BorderSide.none,
    );
  }

  String _labelFor(String value) {
    return switch (value) {
      BookingStatuses.pending => 'Pending',
      BookingStatuses.accepted => 'Accepted',
      BookingStatuses.completed => 'Completed',
      BookingStatuses.cancelled => 'Cancelled',
      _ => 'Unknown',
    };
  }
}
