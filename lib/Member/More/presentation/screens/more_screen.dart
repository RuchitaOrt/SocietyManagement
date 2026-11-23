
import 'package:flutter/material.dart';
import 'package:society_management/feature/admin/presentation/screens/admin_main_screen.dart';

import 'change_password_screen.dart';

const Color primaryColor = Color(0xFFE93691);
const Color orangeColor = Color(0xFFF97316);
const Color pageColor = Color(0xFFF5F7FA);
const Color textColor = Color(0xFF25324B);
const Color mutedColor = Color(0xFF71809A);
const Color borderColor = Color(0xFFE5EAF2);
class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  static const Color pink = Color(0xFFEC268F);
  static const Color darkText = Color(0xFF202B43);
  static const Color lightText = Color(0xFF718096);
  static const Color background = Color(0xFFF5F7FB);

  static const Color orange = Color(0xFFFF795B);
  static const Color navy = Color(0xFF25324A);
  static const Color muted = Color(0xFF71829F);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
             backgroundColor: AdminColors.page,

     appBar: AppBar(
  centerTitle: false,
  backgroundColor: AdminColors.page,
  surfaceTintColor: AdminColors.page,
  elevation: 0,
  titleSpacing: 18,
  title: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      ShaderMask(
        shaderCallback: (bounds) => const LinearGradient(
          colors: [primaryColor, orangeColor],
        ).createShader(bounds),
        child: const Text(
          'Account & Support',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      const SizedBox(height: 3),
      const Text(
        'View and manage your society information',
        style: TextStyle(
          color: mutedColor,
          fontSize: 11,
          fontWeight: FontWeight.w400,
        ),
      ),
    ],
  ),
),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          
          _buildMoreTile(
            icon: Icons.lock_outline_rounded,
            title: 'Change Password',
            subtitle: 'Update your account password',
            iconColor: pink,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ChangePasswordScreen(),
                ),
              );
            },
          ),

          const SizedBox(height: 12),

          _buildMoreTile(
            icon: Icons.help_outline_rounded,
            title: 'Help & Support',
            subtitle: 'Get assistance and contact support',
            iconColor: const Color(0xFF4A90E2),
            onTap: () {
              _showHelpDialog(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: darkText,
        ),
      ),
    );
  }

  Widget _buildMoreTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return Card(
      color: Colors.white,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                height: 46,
                width: 46,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: darkText,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: lightText,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: lightText,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Help & Support'),
          content: const Text(
            'Need help? Please contact your society administrator '
            'for assistance.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text(
                'Close',
                style: TextStyle(color: pink),
              ),
            ),
          ],
        );
      },
    );
  }
}
