import 'package:book_me_mobile_app/core/localization/localization_service.dart';
import 'package:flutter/material.dart';

class WantedScreen extends StatefulWidget {
  const WantedScreen({required this.onPosted, required this.loc, super.key});

  final VoidCallback onPosted;
  final LocalizationService loc;

  @override
  State<WantedScreen> createState() => _WantedScreenState();
}

class _WantedScreenState extends State<WantedScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _descCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = widget.loc;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            loc.t('wanted_title'),
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _descCtrl,
                  minLines: 3,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    labelText: 'Describe your need',
                  ),
                  validator: (v) =>
                      (v ?? '').trim().length < 8 ? 'Enter more details' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _phoneCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Phone number',
                    prefixText: '+94 ',
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (v) =>
                      (v ?? '').trim().length < 7 ? 'Enter phone' : null,
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: _submitting ? null : _submit,
                  icon: _submitting
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.post_add_rounded),
                  label: Text(loc.t('post_wanted')),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _submitting = true);

    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    setState(() => _submitting = false);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(widget.loc.t('post_success'))));

    _descCtrl.clear();
    _phoneCtrl.clear();
    widget.onPosted();
  }
}
