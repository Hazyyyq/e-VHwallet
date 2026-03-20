import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../routes/app_routes.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: [
                  Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.4),
                          spreadRadius: 1,
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.settings_rounded,
                      size: 28,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Settings',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _buildSectionHeader('Account'),
                  _buildSettingsItem(
                    context,
                    icon: Icons.person_outlined,
                    title: 'Edit Profile',
                    subtitle: 'Update your personal information',
                    onTap: () {},
                  ),
                  _buildSettingsItem(
                    context,
                    icon: Icons.lock_outlined,
                    title: 'Change PIN',
                    subtitle: 'Update your transaction PIN',
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.pin);
                    },
                  ),
                  _buildSettingsItem(
                    context,
                    icon: Icons.fingerprint_rounded,
                    title: 'Biometric Login',
                    subtitle: 'Use fingerprint or face to login',
                    trailing: Switch(
                      value: false,
                      onChanged: (value) {},
                      activeColor: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildSectionHeader('Security'),
                  _buildSettingsItem(
                    context,
                    icon: Icons.security_outlined,
                    title: 'Two-Factor Authentication',
                    subtitle: 'Add extra layer of security',
                    trailing: Switch(
                      value: false,
                      onChanged: (value) {},
                      activeColor: AppColors.primary,
                    ),
                  ),
                  _buildSettingsItem(
                    context,
                    icon: Icons.notifications_outlined,
                    title: 'Transaction Alerts',
                    subtitle: 'Get notified for every transaction',
                    trailing: Switch(
                      value: true,
                      onChanged: (value) {},
                      activeColor: AppColors.primary,
                    ),
                  ),
                  _buildSettingsItem(
                    context,
                    icon: Icons.history_outlined,
                    title: 'Login History',
                    subtitle: 'View your recent login activity',
                    onTap: () {},
                  ),
                  const SizedBox(height: 24),
                  _buildSectionHeader('Payment'),
                  _buildSettingsItem(
                    context,
                    icon: Icons.account_balance_outlined,
                    title: 'Linked Banks',
                    subtitle: 'Manage your bank accounts',
                    onTap: () {},
                  ),
                  _buildSettingsItem(
                    context,
                    icon: Icons.credit_card_outlined,
                    title: 'Default Payment Method',
                    subtitle: 'Set your preferred payment option',
                    onTap: () {},
                  ),
                  _buildSettingsItem(
                    context,
                    icon: Icons.qr_code_outlined,
                    title: 'QR Payment Settings',
                    subtitle: 'Configure QR payment preferences',
                    onTap: () {},
                  ),
                  _buildSettingsItem(
                    context,
                    icon: Icons.speed_outlined,
                    title: 'Transaction Limits',
                    subtitle: 'Set daily and monthly limits',
                    onTap: () {},
                  ),
                  const SizedBox(height: 24),
                  _buildSectionHeader('General'),
                  _buildSettingsItem(
                    context,
                    icon: Icons.language_outlined,
                    title: 'Language',
                    subtitle: 'English',
                    onTap: () {},
                  ),
                  _buildSettingsItem(
                    context,
                    icon: Icons.attach_money_rounded,
                    title: 'Currency',
                    subtitle: 'Malaysian Ringgit (RM)',
                    onTap: () {},
                  ),
                  _buildSettingsItem(
                    context,
                    icon: Icons.dark_mode_outlined,
                    title: 'Dark Mode',
                    subtitle: 'Coming soon',
                    trailing: Switch(
                      value: false,
                      onChanged: null,
                      activeColor: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildSectionHeader('Support'),
                  _buildSettingsItem(
                    context,
                    icon: Icons.help_outline_rounded,
                    title: 'Help Center',
                    subtitle: 'FAQs and guides',
                    onTap: () {},
                  ),
                  _buildSettingsItem(
                    context,
                    icon: Icons.chat_outlined,
                    title: 'Contact Us',
                    subtitle: 'Chat with our support team',
                    onTap: () {},
                  ),
                  _buildSettingsItem(
                    context,
                    icon: Icons.info_outline_rounded,
                    title: 'About',
                    subtitle: 'App version 1.0.0',
                    onTap: () {},
                  ),
                  _buildSettingsItem(
                    context,
                    icon: Icons.description_outlined,
                    title: 'Terms & Privacy',
                    subtitle: 'Legal information',
                    onTap: () {},
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        final confirmed = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Logout'),
                            content: const Text('Are you sure you want to logout?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text('Cancel'),
                              ),
                              ElevatedButton(
                                onPressed: () => Navigator.pop(context, true),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                ),
                                child: const Text('Logout'),
                              ),
                            ],
                          ),
                        );
                        
                        if (confirmed == true && context.mounted) {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            AppRoutes.login,
                            (route) => false,
                          );
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: Colors.red),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      icon: const Icon(Icons.logout_rounded),
                      label: const Text(
                        'Logout',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.grey[600],
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildSettingsItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
    Widget? trailing,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Colors.black87, size: 22),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 15,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[500],
          ),
        ),
        trailing: trailing ?? Icon(
          Icons.chevron_right_rounded,
          color: Colors.grey[400],
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
