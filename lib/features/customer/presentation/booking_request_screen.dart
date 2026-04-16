import 'package:book_me_mobile_app/features/customer/data/firestore_booking_repository.dart';
import 'package:book_me_mobile_app/features/shared/domain/entities/booking.dart';
import 'package:book_me_mobile_app/features/shared/domain/entities/provider.dart';
import 'package:book_me_mobile_app/features/shared/domain/repositories/booking_repository.dart';
import 'package:flutter/material.dart';

class BookingRequestScreen extends StatefulWidget {
  const BookingRequestScreen({
    required this.provider,
    required this.customerId,
    super.key,
  });

  final Provider provider;
  final String customerId;

  @override
  State<BookingRequestScreen> createState() => _BookingRequestScreenState();
}

class _BookingRequestScreenState extends State<BookingRequestScreen> {
  static const List<String> _paymentMethods = <String>[
    'cash',
    'card',
    'mobile_wallet',
  ];

  final _formKey = GlobalKey<FormState>();
  final _noteController = TextEditingController();
  final BookingRepository _bookingRepository = FirestoreBookingRepository();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String _selectedPaymentMethod = _paymentMethods.first;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = widget.provider;
    final headlineSkill = provider.skills.isNotEmpty
        ? provider.skills.first
        : '-';
    final colorScheme = Theme.of(context).colorScheme;
    final dateText = _selectedDate == null
        ? 'Select date'
        : _formatDate(_selectedDate!);
    final timeText = _selectedTime == null
        ? 'Select time'
        : _formatTimeOfDay(_selectedTime!);

    return Scaffold(
      appBar: AppBar(title: const Text('Request booking')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Booking summary',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 12),
                          _SummaryLine(label: 'Provider', value: provider.id),
                          _SummaryLine(
                            label: 'Primary skill',
                            value: headlineSkill,
                          ),
                          _SummaryLine(
                            label: 'Price range',
                            value:
                                'LKR ${provider.priceMin.toStringAsFixed(0)} - ${provider.priceMax.toStringAsFixed(0)}',
                          ),
                          _SummaryLine(
                            label: 'Rating',
                            value:
                                '${provider.ratingAvg.toStringAsFixed(1)} (${provider.ratingCount})',
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Preferred date',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: _isSubmitting ? null : _pickDate,
                    icon: const Icon(Icons.calendar_month_rounded),
                    label: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(dateText),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Preferred time',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: _isSubmitting ? null : _pickTime,
                    icon: const Icon(Icons.schedule_rounded),
                    label: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(timeText),
                    ),
                  ),
                  if (_showDateTimeError)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        'Please select both date and time.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colorScheme.error,
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    initialValue: _selectedPaymentMethod,
                    decoration: const InputDecoration(
                      labelText: 'Payment method',
                      prefixIcon: Icon(Icons.payments_outlined),
                    ),
                    items: _paymentMethods
                        .map(
                          (method) => DropdownMenuItem<String>(
                            value: method,
                            child: Text(_humanizePaymentMethod(method)),
                          ),
                        )
                        .toList(growable: false),
                    onChanged: _isSubmitting
                        ? null
                        : (value) {
                            if (value == null) {
                              return;
                            }
                            setState(() {
                              _selectedPaymentMethod = value;
                            });
                          },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _noteController,
                    minLines: 3,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      labelText: 'Note for provider',
                      hintText: 'Share task details, location, and constraints',
                      alignLabelWithHint: true,
                    ),
                    validator: (value) {
                      final text = value?.trim() ?? '';
                      if (text.isEmpty) {
                        return 'Please add a short note for the provider.';
                      }
                      if (text.length < 8) {
                        return 'Please provide a bit more detail.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: _isSubmitting ? null : _submitBooking,
                    icon: _isSubmitting
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.check_circle_outline_rounded),
                    label: Text(
                      _isSubmitting
                          ? 'Submitting request...'
                          : 'Submit booking request',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool get _showDateTimeError =>
      (_selectedDate == null || _selectedTime == null) && _isSubmitting;

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: now.add(const Duration(days: 90)),
      initialDate: _selectedDate ?? now,
    );

    if (picked == null) {
      return;
    }

    setState(() {
      _selectedDate = DateTime(picked.year, picked.month, picked.day);
    });
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? const TimeOfDay(hour: 10, minute: 0),
    );

    if (picked == null) {
      return;
    }

    setState(() {
      _selectedTime = picked;
    });
  }

  Future<void> _submitBooking() async {
    setState(() {
      _isSubmitting = true;
    });

    final isValidForm = _formKey.currentState?.validate() ?? false;
    final hasDateTime = _selectedDate != null && _selectedTime != null;
    final bookingCategory = widget.provider.skills.isNotEmpty
        ? widget.provider.skills.first
        : 'General';

    if (!isValidForm || !hasDateTime) {
      setState(() {
        _isSubmitting = false;
      });
      return;
    }

    try {
      final createdBooking = await _bookingRepository.createBookingRequest(
        customerId: widget.customerId,
        providerId: widget.provider.id,
        category: bookingCategory,
        date: _selectedDate!,
        time: _formatTimeOfDay(_selectedTime!),
        note: _noteController.text,
        paymentMethod: _selectedPaymentMethod,
        amount: (widget.provider.priceMin + widget.provider.priceMax) / 2,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _isSubmitting = false;
      });

      await _showSuccessDialog(createdBooking);
      if (!mounted) {
        return;
      }
      Navigator.of(context).popUntil((route) => route.isFirst);
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isSubmitting = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to submit booking. Please try again.'),
        ),
      );
    }
  }

  Future<void> _showSuccessDialog(Booking booking) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Booking request sent'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Booking ID: ${booking.id}'),
              const SizedBox(height: 8),
              Text('Date: ${_formatDate(booking.date)}'),
              Text('Time: ${booking.time}'),
              Text('Payment: ${_humanizePaymentMethod(booking.paymentMethod)}'),
              Text('Status: ${booking.status}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Back to providers'),
            ),
          ],
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  String _formatTimeOfDay(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  String _humanizePaymentMethod(String value) {
    return value
        .split('_')
        .map((part) => part[0].toUpperCase() + part.substring(1))
        .join(' ');
  }
}

class _SummaryLine extends StatelessWidget {
  const _SummaryLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(label, style: Theme.of(context).textTheme.labelLarge),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
