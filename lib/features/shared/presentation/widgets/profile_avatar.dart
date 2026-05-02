import 'dart:io';

import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({
    required this.imagePath,
    this.size = 120,
    this.onTap,
    super.key,
  });

  final String? imagePath;
  final double size;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: size / 2,
        backgroundColor: Colors.grey[300],
        child: imagePath == null
            ? Icon(Icons.person, size: size * 0.5, color: Colors.grey[600])
            : _buildImage(),
      ),
    );
  }

  Widget _buildImage() {
    if (imagePath == null) {
      return const SizedBox.shrink();
    }

    // Check if it's a local file path or URL
    if (imagePath!.startsWith('http://') || imagePath!.startsWith('https://')) {
      return ClipOval(
        child: Image.network(
          imagePath!,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Icon(
              Icons.person,
              size: size * 0.5,
              color: Colors.grey[600],
            );
          },
        ),
      );
    } else {
      // Local file
      final file = File(imagePath!);
      if (file.existsSync()) {
        return ClipOval(child: Image.file(file, fit: BoxFit.cover));
      } else {
        return Icon(Icons.person, size: size * 0.5, color: Colors.grey[600]);
      }
    }
  }
}
