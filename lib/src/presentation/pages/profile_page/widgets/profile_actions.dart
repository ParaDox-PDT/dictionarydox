import 'package:flutter/material.dart';

class ProfileActions extends StatelessWidget {
  final VoidCallback onLogout;
  final VoidCallback onDeleteAccount;

  const ProfileActions({
    super.key,
    required this.onLogout,
    required this.onDeleteAccount,
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
          _ActionTile(
            icon: Icons.logout,
            title: 'Sign Out',
            subtitle: 'Sign out from your account',
            backgroundColor: Colors.red[100]!, // Ochroq qizil
            iconColor: Colors.red[700]!,
            onTap: onLogout,
          ),
          Divider(
            height: 1,
            thickness: 1,
            color: Colors.grey[200],
          ),
          _ActionTile(
            icon: Icons.delete_forever,
            title: 'Delete Account',
            subtitle: 'Permanently delete your account',
            backgroundColor: Colors.red[900]!, // To'q qizil
            iconColor: Colors.white,
            textColor: Colors.white,
            onTap: onDeleteAccount,
          ),
        ],
      ),
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
