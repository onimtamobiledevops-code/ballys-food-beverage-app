import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_theme.dart';

/// "Profile" tab - account info, settings shortcuts, and logout.
class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
      child: Column(
        children: [
          CircleAvatar(
            radius: 42,
            backgroundColor: AppColors.surfaceBlack,
            child: Text(
              (user?.name.isNotEmpty ?? false) ? user!.name[0].toUpperCase() : 'B',
              style: const TextStyle(
                color: AppColors.primaryOrange,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            user?.name ?? 'Guest',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            user?.email ?? '',
            style: const TextStyle(color: AppColors.greyText, fontSize: 13),
          ),
          const SizedBox(height: 24),

          _buildOption(context, icon: Icons.person_outline, label: 'Edit Profile'),
          _buildOption(context, icon: Icons.location_on_outlined, label: 'Delivery Addresses'),
          _buildOption(context, icon: Icons.payment_outlined, label: 'Payment Methods'),
          _buildOption(context, icon: Icons.notifications_outlined, label: 'Notifications'),
          _buildOption(context, icon: Icons.privacy_tip_outlined, label: 'Privacy & Security'),
          _buildOption(context, icon: Icons.help_outline, label: 'Help & Support'),

          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                context.read<AuthProvider>().logout();
                Navigator.pushReplacementNamed(context, AppRoutes.login);
              },
              icon: const Icon(Icons.logout, color: AppColors.primaryRed),
              label: const Text(
                'Log out',
                style: TextStyle(color: AppColors.primaryRed, fontWeight: FontWeight.bold),
              ),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                side: const BorderSide(color: AppColors.primaryRed),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOption(BuildContext context, {required IconData icon, required String label}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.surfaceBlack,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primaryOrange),
        title: Text(label, style: const TextStyle(color: Colors.white, fontSize: 14)),
        trailing: const Icon(Icons.chevron_right, color: AppColors.greyText),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        onTap: () {},
      ),
    );
  }
}
