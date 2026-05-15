import 'package:flutter/material.dart';

class CustomerNotificationsScreen extends StatelessWidget {
  const CustomerNotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = <_NotificationItem>[
      const _NotificationItem(
        title: 'Booking accepted',
        subtitle: 'Your electrician booking is confirmed for today.',
        icon: Icons.check_circle_rounded,
      ),
      const _NotificationItem(
        title: 'Wallet payment secured',
        subtitle: 'Your escrow payment will be released after job completion.',
        icon: Icons.lock_rounded,
      ),
      const _NotificationItem(
        title: 'New support reply',
        subtitle: 'Support responded to your secure chat request.',
        icon: Icons.support_agent_rounded,
      ),
    ];

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = items[index];

        return Card(
          child: ListTile(
            leading: CircleAvatar(child: Icon(item.icon)),
            title: Text(item.title),
            subtitle: Text(item.subtitle),
          ),
        );
      },
    );
  }
}

class _NotificationItem {
  const _NotificationItem({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final IconData icon;
}
