import 'package:book_me_mobile_app/features/auth/application/auth_controller.dart';
import 'package:book_me_mobile_app/features/shared/presentation/widgets/profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProviderProfileScreen extends StatefulWidget {
  const ProviderProfileScreen({required this.authController, super.key});

  final AuthController authController;

  @override
  State<ProviderProfileScreen> createState() => _ProviderProfileScreenState();
}

class _ProviderProfileScreenState extends State<ProviderProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _specialtyController;
  String? _profileImagePath;
  bool _isEditing = false;
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final state = widget.authController.state;
    _nameController = TextEditingController(text: state.userName ?? '');
    _phoneController = TextEditingController(text: state.phoneNumber ?? '');
    _specialtyController = TextEditingController(text: 'Your specialty');
    _profileImagePath = state.profilePhoto;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _specialtyController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
      );
      if (pickedFile != null) {
        setState(() {
          _profileImagePath = pickedFile.path;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error picking image: $e')));
    }
  }

  void _saveProfile() {
    // Validate inputs
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Name cannot be empty')));
      return;
    }

    // TODO: Save profile to Firestore with image
    // For now, just update UI
    setState(() {
      _isEditing = false;
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Profile saved successfully')));
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.authController.state;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          if (!_isEditing)
            TextButton(
              onPressed: () => setState(() => _isEditing = true),
              child: const Text('Edit'),
            )
          else
            TextButton(onPressed: _saveProfile, child: const Text('Save')),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Avatar with image picker
            ProfileAvatar(
              imagePath: _profileImagePath,
              size: 140,
              onTap: _isEditing ? _pickImage : null,
            ),
            if (_isEditing)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'Tap to change photo',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                ),
              ),
            const SizedBox(height: 40),

            // Provider Role Badge
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.business, color: Colors.green[700]),
                  const SizedBox(width: 12),
                  Text(
                    'Service Provider',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.green[700],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Name Field
            TextField(
              controller: _nameController,
              enabled: _isEditing,
              decoration: InputDecoration(
                labelText: 'Full Name',
                prefixIcon: const Icon(Icons.person),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Phone Field
            TextField(
              controller: _phoneController,
              enabled: false,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                prefixIcon: const Icon(Icons.phone),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                helperText: 'Your phone number cannot be changed',
              ),
            ),
            const SizedBox(height: 16),

            // Specialty Field
            TextField(
              controller: _specialtyController,
              enabled: _isEditing,
              decoration: InputDecoration(
                labelText: 'Specialty',
                prefixIcon: const Icon(Icons.work),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                hintText: 'E.g., Plumbing, Carpentry, Electrical Work',
              ),
            ),
            const SizedBox(height: 16),

            // Member Since
            TextField(
              enabled: false,
              decoration: InputDecoration(
                labelText: 'Member Since',
                prefixIcon: const Icon(Icons.calendar_today),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              controller: TextEditingController(
                text: state.createdAt != null
                    ? '${state.createdAt!.year}-${state.createdAt!.month.toString().padLeft(2, '0')}-${state.createdAt!.day.toString().padLeft(2, '0')}'
                    : 'N/A',
              ),
            ),
            const SizedBox(height: 32),

            // Action Buttons
            if (_isEditing)
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          _isEditing = false;
                          _nameController.text = state.userName ?? '';
                          _specialtyController.text = 'Your specialty';
                          _profileImagePath = state.profilePhoto;
                        });
                      },
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _saveProfile,
                      child: const Text('Save Changes'),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
