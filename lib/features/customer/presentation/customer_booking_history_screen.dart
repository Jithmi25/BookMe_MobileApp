import 'package:book_me_mobile_app/app/constants/constants.dart';
import 'package:book_me_mobile_app/features/customer/presentation/review_submission_screen.dart';
import 'package:book_me_mobile_app/features/shared/domain/entities/booking.dart';
import 'package:book_me_mobile_app/features/shared/domain/repositories/booking_repository.dart';
import 'package:flutter/material.dart';

class CustomerBookingHistoryScreen extends StatefulWidget {
  const CustomerBookingHistoryScreen({
    required this.customerId,
    required this.repository,
    super.key,
  });

  final String customerId;
  final BookingRepository repository;

  @override
  State<CustomerBookingHistoryScreen> createState() =>
      _CustomerBookingHistoryScreenState();
}

class _CustomerBookingHistoryScreenState
    extends State<CustomerBookingHistoryScreen> {
  late Future<List<Booking>> _bookingsFuture;

  @override
  void initState() {
    super.initState();
    _bookingsFuture = _loadBookings();
  }

  Future<List<Booking>> _loadBookings() {
    return widget.repository.getBookingsForCustomer(widget.customerId);
  }

  void _refreshBookings() {
    setState(() {
      _bookingsFuture = _loadBookings();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My booking history')),
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
                  const Text('Failed to load booking history.'),
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
          if (bookings.isEmpty) {
            return const Center(
              child: Text('No bookings yet. Create your first request.'),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              _refreshBookings();
              await _bookingsFuture;
            },
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: bookings.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final booking = bookings[index];

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
                        Text('Provider: ${booking.providerId}'),
                        Text(
                          'Date: ${_formatDate(booking.date)} at ${booking.time}',
                        ),
                        Text(
                          'Amount: LKR ${booking.amount.toStringAsFixed(0)}',
                        ),
                        const SizedBox(height: 8),
                        Text(booking.note),
                        if (booking.status == BookingStatuses.completed) ...[
                          const SizedBox(height: 12),
                          Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute<void>(
                                    builder: (_) => ReviewSubmissionScreen(
                                      booking: booking,
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.rate_review_rounded),
                              label: const Text('Leave a review'),
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
