import 'package:book_me_mobile_app/features/shared/domain/entities/provider.dart';
import 'package:flutter/material.dart';

class ProviderCard extends StatelessWidget {
  const ProviderCard({required this.provider, super.key});

  final Provider provider;

  @override
  Widget build(BuildContext context) {
    final headlineSkill = provider.skills.isNotEmpty
        ? provider.skills.first
        : '-';
    final areaText = provider.serviceAreas.isNotEmpty
        ? provider.serviceAreas.join(', ')
        : '-';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(headlineSkill, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            Text('ID: ${provider.id}'),
            const SizedBox(height: 4),
            Text('Areas: $areaText'),
            const SizedBox(height: 4),
            Text('Experience: ${provider.experienceYears} years'),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.star, size: 16),
                const SizedBox(width: 4),
                Text('${provider.ratingAvg} (${provider.ratingCount})'),
                const Spacer(),
                Text(
                  'LKR ${provider.priceMin.toStringAsFixed(0)} - ${provider.priceMax.toStringAsFixed(0)}',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
