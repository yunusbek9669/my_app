import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../../models/user_info.dart';

class ProfileScreen extends StatelessWidget {
  final UserInfo userInfo;
  final VoidCallback? onLogout;

  const ProfileScreen({
    Key? key,
    required this.userInfo,
    this.onLogout,
  }) : super(key: key);

  // Base64 dan byte array olish
  Uint8List? _getImageBytes() {
    final imageData = userInfo.imageUrl; // imageUrl yoki photoUrl
    if (imageData == null || imageData.isEmpty) {
      return null;
    }

    try {
      // Agar data URI bo'lsa
      if (imageData.startsWith('data:')) {
        final base64String = imageData.split(',').last;
        return base64Decode(base64String);
      }
      // Oddiy base64 string bo'lsa
      return base64Decode(imageData);
    } catch (e) {
      debugPrint('Image decode error: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final imageBytes = _getImageBytes();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        actions: [
          if (onLogout != null)
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: onLogout,
              tooltip: 'Chiqish',
            ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Refresh logic - parent widget'dan keladi
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Avatar
              Hero(
                tag: "userInfo-${userInfo.pinfl}",
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: imageBytes != null
                      ? MemoryImage(imageBytes)
                      : null,
                  child: imageBytes == null
                      ? Text(
                    userInfo.fullName.isNotEmpty
                        ? userInfo.fullName[0].toUpperCase()
                        : '?',
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                      : null,
                ),
              ),
              const SizedBox(height: 16),

              // Full name
              Text(
                userInfo.fullName,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),

              // PINFL
              Text(
                'PINFL: ${userInfo.pinfl}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 24),

              // Info Cards
              _buildInfoCard(
                context,
                icon: Icons.cake_outlined,
                title: 'Tug\'ilgan sana',
                value: userInfo.birthDate ?? 'Kiritilmagan',
              ),
              const SizedBox(height: 12),

              _buildInfoCard(
                context,
                icon: Icons.person_outline,
                title: 'Jins',
                value: _getGenderText(userInfo.gender),
              ),
              const SizedBox(height: 12),

              _buildInfoCard(
                context,
                icon: Icons.phone_outlined,
                title: 'Telefon',
                value: userInfo.phone ?? 'Kiritilmagan',
              ),
              const SizedBox(height: 12),

              _buildInfoCard(
                context,
                icon: Icons.email_outlined,
                title: 'Email',
                value: userInfo.email ?? 'Kiritilmagan',
              ),
              const SizedBox(height: 12),

              _buildInfoCard(
                context,
                icon: Icons.location_on_outlined,
                title: 'Manzil',
                value: userInfo.address ?? 'Kiritilmagan',
                maxLines: 3,
              ),
              const SizedBox(height: 24),

              // Edit profile button (optional)
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    // Navigate to edit profile
                    // Navigator.pushNamed(context, '/edit-profile', arguments: userInfo);
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text('Profilni tahrirlash'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String value,
        int maxLines = 1,
      }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, color: Theme.of(context).primaryColor, size: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: maxLines,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getGenderText(String? gender) {
    if (gender == null || gender.isEmpty) return 'Kiritilmagan';

    switch (gender.toLowerCase()) {
      case 'male':
      case 'erkak':
      case 'm':
        return 'Erkak';
      case 'female':
      case 'ayol':
      case 'f':
        return 'Ayol';
      default:
        return gender;
    }
  }
}