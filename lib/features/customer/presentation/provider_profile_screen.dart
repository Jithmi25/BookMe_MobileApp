import 'package:book_me_mobile_app/features/customer/data/firestore_review_repository.dart';
import 'package:book_me_mobile_app/features/customer/presentation/booking_request_screen.dart';
import 'package:book_me_mobile_app/features/customer/presentation/widgets/detail_row.dart';
import 'package:book_me_mobile_app/features/shared/domain/entities/provider.dart';
import 'package:book_me_mobile_app/features/shared/domain/entities/review.dart';
import 'package:book_me_mobile_app/features/shared/domain/repositories/review_repository.dart';
import 'package:flutter/material.dart';

class ProviderProfileScreen extends StatefulWidget {
  const ProviderProfileScreen({
    required this.provider,
    required this.customerId,
    super.key,
  });

  final Provider provider;
  final String customerId;

  @override
  State<ProviderProfileScreen> createState() => _ProviderProfileScreenState();
}

class _ProviderProfileScreenState extends State<ProviderProfileScreen> {
  late Future<List<Review>> _reviewsFuture;
  final ReviewRepository _reviewRepository = FirestoreReviewRepository();

  @override
  void initState() {
    super.initState();
    _reviewsFuture = _reviewRepository.getReviewsForProvider(
      widget.provider.id,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final headlineSkill = provider.skills.isNotEmpty
        ? provider.skills.first
        : '-';
    final displayName = _formatDisplayName(provider.id);
    final ratingText = provider.ratingAvg.toStringAsFixed(1);
    final priceText =
        'LKR ${provider.priceMin.toStringAsFixed(0)} - ${provider.priceMax.toStringAsFixed(0)}';
    final avatarChild = provider.profilePhoto == null
        ? Text(
            displayName.isNotEmpty ? displayName[0].toUpperCase() : '?',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.w700,
            ),
          )
        : null;

    return Scaffold(
      appBar: AppBar(title: const Text('Provider profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    colorScheme.primaryContainer,
                    colorScheme.secondaryContainer,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(28),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 44,
                    backgroundColor: colorScheme.surface,
                    backgroundImage: provider.profilePhoto != null
                        ? NetworkImage(provider.profilePhoto!)
                        : null,
                    child: avatarChild,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    displayName,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    headlineSkill,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(
                        child: _MetricCard(
                          icon: Icons.star_rounded,
                          label: 'Rating',
                          value: ratingText,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _MetricCard(
                          icon: Icons.work_history_rounded,
                          label: 'Experience',
                          value: '${provider.experienceYears} yrs',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _MetricCard(
                          icon: Icons.payments_rounded,
                          label: 'Price',
                          value: priceText,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Profile details',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            DetailRow(
              icon: Icons.badge_outlined,
              label: 'Provider ID',
              value: provider.id,
            ),
            const SizedBox(height: 12),
            DetailRow(
              icon: Icons.handyman_outlined,
              label: 'Skills',
              value: provider.skills.join(', '),
            ),
            const SizedBox(height: 12),
            DetailRow(
              icon: Icons.map_outlined,
              label: 'Service areas',
              value: provider.serviceAreas.join(', '),
            ),
            const SizedBox(height: 12),
            DetailRow(
              icon: Icons.access_time_rounded,
              label: 'Availability',
              value: provider.availability ?? 'Not updated yet',
            ),
            const SizedBox(height: 12),
            DetailRow(
              icon: Icons.verified_outlined,
              label: 'Trust signals',
              value:
                  'NIC ${provider.nicVerified ? 'verified' : 'pending'} • Photo ${provider.photoVerified ? 'verified' : 'pending'}',
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => BookingRequestScreen(
                      provider: provider,
                      customerId: customerId,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.calendar_month_rounded),
              label: const Text('Request booking'),
            ),
            const SizedBox(height: 12),
            Text(
              'Customers can review the provider profile before moving into the booking request flow.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Text(
              'Customer reviews (${widget.provider.ratingCount})',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            FutureBuilder<List<Review>>(
              future: _reviewsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox(
                    height: 100,
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                final reviews = snapshot.data ?? const <Review>[];
                if (reviews.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        'No reviews yet. Be the first to review!',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }

                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: reviews.take(5).length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final review = reviews[index];
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  review.customerId,
                                  style: Theme.of(context).textTheme.labelMedium
                                      ?.copyWith(fontWeight: FontWeight.w600),
                                ),
                                Row(
                                  children: List.generate(
                                    5,
                                    (i) => Icon(
                                      Icons.star_rounded,
                                      size: 16,
                                      color: i < review.stars
                                          ? Colors.amber
                                          : colorScheme.outlineVariant,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if (review.comment.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Text(
                                review.comment,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                            const SizedBox(height: 6),
                            Text(
                              _formatDate(review.createdAt),
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  String _formatDisplayName(String value) {
    final cleaned = value.replaceFirst(RegExp(r'^provider_'), '');
    if (cleaned.isEmpty) {
      return 'Provider';
    }

    return cleaned
        .split('_')
        .where((segment) => segment.isNotEmpty)
        .map((segment) => segment[0].toUpperCase() + segment.substring(1))
        .join(' ');
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      decoration: BoxDecoration(
        color: colorScheme.surface.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Icon(icon, color: colorScheme.primary),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
