import 'package:flutter/material.dart';

class ProviderHomeScreen extends StatelessWidget {
  const ProviderHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Provider Home')),
      body: const Center(
        child: Text(
          'Next: profile setup, availability, and booking request management.',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
