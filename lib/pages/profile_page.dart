import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:smartwatch_rent_web/controllers/auth_controller.dart';

class ProfilePage extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();

  ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Transparent background
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Transparent app bar
        elevation: 0,
        title: const Text('Profile', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () => authController.signOut(),
          ),
        ],
      ),
      extendBodyBehindAppBar: true, // Allows background to show behind app bar
      body: Container(
        child: Obx(() {
          if (authController.userProfile.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          final profile = authController.userProfile;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 80), // Space for app bar

                // Location Card with glass effect
                const SizedBox(height: 20),

                // Profile Section
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    'Personal Information',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Profile Picture with glass effect
                Center(
                  child: _buildGlassCard(
                    shape: BoxShape.circle,
                    padding: const EdgeInsets.all(20),
                    child: const Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // User Details with glass cards
                _buildGlassCard(
                  child: Column(
                    children: [
                      _buildProfileItem(
                        icon: Icons.person,
                        label: 'Name',
                        value: profile['name'] ?? 'Not provided',
                      ),
                      const Divider(color: Colors.white54, height: 1),
                      _buildProfileItem(
                        icon: Icons.email,
                        label: 'Email',
                        value: profile['email'] ?? authController.email.value,
                      ),
                      const Divider(color: Colors.white54, height: 1),
                      _buildProfileItem(
                        icon: Icons.phone,
                        label: 'Phone',
                        value: profile['phone'] ?? 'Not provided',
                      ),
                      const Divider(color: Colors.white54, height: 1),
                      _buildProfileItem(
                        icon: Icons.cake,
                        label: 'Date of Birth',
                        value:
                            profile['dob'] != null
                                ? DateFormat(
                                  'MMMM d, y',
                                ).format(DateTime.parse(profile['dob']))
                                : 'Not provided',
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.2),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: const BorderSide(color: Colors.white),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 12,
                      ),
                    ),
                    onPressed: () {
                      Get.snackbar(
                        'Coming Soon',
                        'Edit profile feature will be added soon',
                        backgroundColor: Colors.white.withOpacity(0.3),
                        colorText: Colors.white,
                      );
                    },
                    child: const Text('Edit Profile'),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildGlassCard({
    required Widget child,
    BoxShape shape = BoxShape.rectangle,
    EdgeInsetsGeometry? padding,
  }) {
    return Container(
      decoration: BoxDecoration(
        shape: shape,
        borderRadius:
            shape == BoxShape.rectangle ? BorderRadius.circular(20) : null,
        color: Colors.white.withOpacity(0.1),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius:
            shape == BoxShape.rectangle
                ? BorderRadius.circular(20)
                : BorderRadius.zero,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child:
              padding != null ? Padding(padding: padding, child: child) : child,
        ),
      ),
    );
  }

  Widget _buildProfileItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(icon, color: Colors.white.withOpacity(0.8)),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
