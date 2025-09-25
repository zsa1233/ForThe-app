import 'package:flutter/material.dart';
import 'edit_profile_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: ListView(
        children: [
          _buildSection(
            'Account',
            [
              _buildSettingTile(
                icon: Icons.person,
                title: 'Profile Information',
                subtitle: 'Update your name, email, and photo',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EditProfilePage(),
                    ),
                  );
                },
              ),
              _buildSettingTile(
                icon: Icons.lock,
                title: 'Privacy',
                subtitle: 'Manage your privacy settings',
                onTap: () {},
              ),
              _buildSettingTile(
                icon: Icons.security,
                title: 'Security',
                subtitle: 'Password and authentication',
                onTap: () {},
              ),
            ],
          ),
          _buildSection(
            'Preferences',
            [
              _buildSettingTile(
                icon: Icons.notifications,
                title: 'Notifications',
                subtitle: 'Configure notification preferences',
                onTap: () {},
                trailing: Switch(
                  value: true,
                  onChanged: (value) {},
                ),
              ),
              _buildSettingTile(
                icon: Icons.language,
                title: 'Language',
                subtitle: 'English',
                onTap: () {},
              ),
              _buildSettingTile(
                icon: Icons.dark_mode,
                title: 'Dark Mode',
                subtitle: 'Toggle dark mode',
                trailing: Switch(
                  value: false,
                  onChanged: (value) {},
                ),
              ),
            ],
          ),
          _buildSection(
            'Data & Storage',
            [
              _buildSettingTile(
                icon: Icons.download,
                title: 'Download My Data',
                subtitle: 'Get a copy of your Terra data',
                onTap: () {},
              ),
              _buildSettingTile(
                icon: Icons.storage,
                title: 'Clear Cache',
                subtitle: 'Free up storage space',
                onTap: () {},
              ),
            ],
          ),
          _buildSection(
            'About',
            [
              _buildSettingTile(
                icon: Icons.info,
                title: 'About Terra',
                subtitle: 'Version 1.0.0',
                onTap: () {},
              ),
              _buildSettingTile(
                icon: Icons.description,
                title: 'Terms of Service',
                subtitle: 'Read our terms',
                onTap: () {},
              ),
              _buildSettingTile(
                icon: Icons.privacy_tip,
                title: 'Privacy Policy',
                subtitle: 'How we handle your data',
                onTap: () {},
              ),
              _buildSettingTile(
                icon: Icons.help,
                title: 'Help & Support',
                subtitle: 'Get help or report issues',
                onTap: () {},
              ),
            ],
          ),
          _buildSection(
            'Account Actions',
            [
              _buildSettingTile(
                icon: Icons.logout,
                title: 'Log Out',
                subtitle: 'Sign out of your account',
                onTap: () {
                  _showLogoutDialog(context);
                },
                textColor: Colors.red,
              ),
              _buildSettingTile(
                icon: Icons.delete_forever,
                title: 'Delete Account',
                subtitle: 'Permanently delete your account',
                onTap: () {
                  _showDeleteAccountDialog(context);
                },
                textColor: Colors.red,
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
        ),
        Container(
          color: Colors.white,
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
    Widget? trailing,
    Color? textColor,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: (textColor ?? Colors.blue).withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: textColor ?? Colors.blue,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontSize: 12,
          color: Colors.grey,
        ),
      ),
      trailing: trailing ?? const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement logout logic
            },
            child: const Text(
              'Log Out',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'Are you sure you want to delete your account? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement account deletion logic
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}