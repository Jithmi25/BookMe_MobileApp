import 'package:book_me_mobile_app/features/customer/data/firestore_review_repository.dart';
import 'package:book_me_mobile_app/features/shared/domain/entities/booking.dart';
import 'package:book_me_mobile_app/features/shared/domain/repositories/review_repository.dart';
import 'package:flutter/material.dart';

class ReviewSubmissionScreen extends StatefulWidget {
  const ReviewSubmissionScreen({required this.booking, super.key});

  final Booking booking;

  @override
  State<ReviewSubmissionScreen> createState() => _ReviewSubmissionScreenState();
}

class _ReviewSubmissionScreenState extends State<ReviewSubmissionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _commentController = TextEditingController();
  final ReviewRepository _reviewRepository = FirestoreReviewRepository();

  int _selectedStars = 5;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Leave a review')),
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
                            'Review for ${widget.booking.providerId}',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Booking ID: ${widget.booking.id}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          Text(
                            'Service: ${widget.booking.category}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'How would you rate this service?',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: Wrap(
                      spacing: 8,
                      children: List.generate(5, (index) {
                        final stars = index + 1;
                        final isSelected = _selectedStars >= stars;

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedStars = stars;
                            });
                          },
                          child: Icon(
                            Icons.star_rounded,
                            size: 40,
                            color: isSelected
                                ? Colors.amber
                                : colorScheme.outlineVariant,
                          ),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _commentController,
                    minLines: 4,
                    maxLines: 6,
                    maxLength: 500,
                    decoration: const InputDecoration(
                      labelText: 'Your feedback (optional)',
                      hintText: 'Share your experience with this provider',
                      alignLabelWithHint: true,
                    ),
                    validator: (value) {
                      final text = value?.trim() ?? '';
                      if (text.length > 500) {
                        return 'Comment must be 500 characters or less.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: _isSubmitting ? null : _submitReview,
                    icon: _isSubmitting
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.send_rounded),
                    label: Text(
                      _isSubmitting ? 'Submitting...' : 'Submit review',
                    ),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: _isSubmitting ? null : _skipReview,
                    child: const Text('Skip for now'),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Your honest feedback helps other customers and providers improve.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submitReview() async {
    final isValidForm = _formKey.currentState?.validate() ?? false;

    if (!isValidForm) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      await _reviewRepository.submitReview(
        bookingId: widget.booking.id,
        customerId: widget.booking.customerId,
        providerId: widget.booking.providerId,
        stars: _selectedStars,
        comment: _commentController.text,
      );

      if (!mounted) {
        return;
      }

      await _showSuccessDialog();
      if (!mounted) {
        return;
      }

      Navigator.of(context).pop();
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  Future<void> _showSuccessDialog() {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Review submitted'),
          content: const Text(
            'Thank you for your feedback! This helps the provider improve.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Done'),
            ),
          ],
        );
      },
    );
  }

  void _skipReview() {
    Navigator.of(context).pop();
  }
}
