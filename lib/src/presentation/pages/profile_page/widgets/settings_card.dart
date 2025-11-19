import 'package:flutter/material.dart';

class SettingsCard extends StatelessWidget {
  final VoidCallback? onLogout;
  final VoidCallback? onDeleteAccount;

  const SettingsCard({
    super.key,
    this.onLogout,
    this.onDeleteAccount,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _SettingsTile(
            icon: Icons.edit,
            title: 'Edit Profile',
            subtitle: 'Update your information',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Edit profile coming soon!')),
              );
            },
          ),
          Divider(
            height: 1,
            thickness: 1,
            color: Colors.grey[200],
          ),
          _SettingsTile(
            icon: Icons.notifications,
            title: 'Notifications',
            subtitle: 'Manage notification settings',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Notification settings coming soon!'),
                ),
              );
            },
          ),
          if (onLogout != null) ...[
            Divider(
              height: 1,
              thickness: 1,
              color: Colors.grey[200],
            ),
            _ActionTile(
              icon: Icons.logout,
              title: 'Sign Out',
              subtitle: 'Sign out from your account',
              backgroundColor: Colors.orangeAccent, // Opacity bilan
              iconColor: Colors.white,
              textColor: Colors.white,
              onTap: onLogout!,
            ),
          ],
          if (onDeleteAccount != null) ...[
            Divider(
              height: 1,
              thickness: 1,
              color: Colors.grey[200],
            ),
            _ActionTile(
              icon: Icons.delete_forever,
              title: 'Delete Account',
              subtitle: 'Permanently delete your account',
              backgroundColor: Colors.red, // Opacitysiz
              iconColor: Colors.white,
              textColor: Colors.white,
              onTap: onDeleteAccount!,
            ),
          ],
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: Theme.of(context).primaryColor,
      ),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color backgroundColor;
  final Color iconColor;
  final Color? textColor;
  final VoidCallback onTap;

  const _ActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.backgroundColor,
    required this.iconColor,
    this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        color: backgroundColor,
        child: ListTile(
          leading: Icon(
            icon,
            color: iconColor,
          ),
          title: Text(
            title,
            style: TextStyle(
              color: textColor ?? Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: TextStyle(
              color: textColor?.withOpacity(0.8) ?? Colors.grey[600],
            ),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: textColor ?? Colors.grey[600],
          ),
        ),
      ),
    );
  }
}
