import 'package:book_me_mobile_app/app/router/app_router.dart';
import 'package:flutter/material.dart';

class PermissionsRequestScreen extends StatefulWidget {
  const PermissionsRequestScreen({super.key});

  @override
  State<PermissionsRequestScreen> createState() => _PermissionsRequestScreenState();
}

class _PermissionsRequestScreenState extends State<PermissionsRequestScreen> {
  bool _location = true;
  bool _camera = false;
  bool _notifications = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Permissions')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 8),
            const Text('We need a few permissions to make BookMe work well.'),
            const SizedBox(height: 12),
            SwitchListTile(
              value: _location,
              onChanged: (v) => setState(() => _location = v),
              title: const Text('Location'),
              subtitle: const Text('Show nearby service providers'),
            ),
            SwitchListTile(
              value: _camera,
              onChanged: (v) => setState(() => _camera = v),
              title: const Text('Camera (optional)'),
              subtitle: const Text('Upload issue photos when requesting a job'),
            ),
            SwitchListTile(
              value: _notifications,
              onChanged: (v) => setState(() => _notifications = v),
              title: const Text('Notifications'),
              subtitle: const Text('Booking updates and provider arrival alerts'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pushReplacementNamed(context, AppRouter.roleSelection),
              child: const Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }
}
