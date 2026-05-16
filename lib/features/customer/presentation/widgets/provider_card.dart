import 'package:book_me_mobile_app/features/shared/domain/entities/provider.dart';
import 'package:flutter/material.dart';

class ProviderCard extends StatelessWidget {
  const ProviderCard({
    required this.provider,
    this.onTap,
    this.actions,
    super.key,
  });

  final Provider provider;
  final VoidCallback? onTap;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    final badges = <Widget>[
      if (provider.photoVerified)
        const _Badge(label: 'Photo verified', icon: Icons.photo_camera_rounded),
      if (provider.nicVerified)
        const _Badge(label: 'ID verified', icon: Icons.verified_user_rounded),
      ...provider.skills.map(
        (skill) => _Badge(label: skill, icon: Icons.handyman_rounded),
      ),
    ];
    final headlineSkill = provider.skills.isNotEmpty
        ? provider.skills.first
        : '-';
    final areaText = provider.serviceAreas.isNotEmpty
        ? provider.serviceAreas.join(', ')
        : '-';

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      headlineSkill,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.chevron_right),
                ],
              ),
              const SizedBox(height: 4),
              Text('ID: ${provider.id}'),
              const SizedBox(height: 4),
              Text('Areas: $areaText'),
              const SizedBox(height: 4),
              Text('Experience: ${provider.experienceYears} years'),
              const SizedBox(height: 8),
              if (badges.isNotEmpty)
                Wrap(spacing: 8, runSpacing: 8, children: badges),
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
              if (actions != null && actions!.isNotEmpty) ...[
                const SizedBox(height: 10),
                Wrap(spacing: 8, runSpacing: 8, children: actions!),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(icon, size: 16),
      label: Text(label),
      visualDensity: VisualDensity.compact,
    );
  }
}
