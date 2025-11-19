import 'package:dictionarydox/src/core/utils/responsive_utils.dart';
import 'package:dictionarydox/src/data/models/user_model.dart';
import 'package:dictionarydox/src/presentation/pages/profile_page/widgets/account_info_card.dart';
import 'package:dictionarydox/src/presentation/pages/profile_page/widgets/settings_card.dart';
import 'package:flutter/material.dart';

class WebProfileLayout extends StatelessWidget {
  final UserModel user;
  final VoidCallback onLogout;
  final VoidCallback onDeleteAccount;

  const WebProfileLayout({
    super.key,
    required this.user,
    required this.onLogout,
    required this.onDeleteAccount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: ResponsiveUtils.getResponsivePadding(context),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 32),
            // Profile Header Section
            _buildProfileHeader(context),
            const SizedBox(height: 48),
            // Main Content - Two Column Layout for Desktop
            ResponsiveUtils.isDesktop(context)
                ? _buildDesktopLayout(context)
                : _buildTabletLayout(context),
            const SizedBox(height: 48),
            // Footer
            Center(
              child: Text(
                'DictionaryDox v1.0.0',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[500],
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Column(
      children: [
        // Profile Picture
        DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Theme.of(context).primaryColor,
              width: 4,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: CircleAvatar(
            radius: ResponsiveUtils.isDesktop(context) ? 70 : 60,
            backgroundColor: Colors.white,
            backgroundImage:
                user.photoUrl != null ? NetworkImage(user.photoUrl!) : null,
            child: user.photoUrl == null
                ? Text(
                    user.displayName[0].toUpperCase(),
                    style: TextStyle(
                      fontSize: ResponsiveUtils.isDesktop(context) ? 56 : 48,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  )
                : null,
          ),
        ),
        const SizedBox(height: 24),
        // Display Name
        Text(
          user.displayName,
          style: TextStyle(
            fontSize: ResponsiveUtils.isDesktop(context) ? 32 : 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        // Email
        Text(
          user.email,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left Column - Account Info
        Expanded(
          flex: 1,
          child: AccountInfoCard(user: user),
        ),
        const SizedBox(width: 32),
        // Right Column - Settings and Actions
        Expanded(
          flex: 1,
          child: SettingsCard(
            onLogout: onLogout,
            onDeleteAccount: onDeleteAccount,
          ),
        ),
      ],
    );
  }

  Widget _buildTabletLayout(BuildContext context) {
    return Column(
      children: [
        AccountInfoCard(user: user),
        const SizedBox(height: 24),
        SettingsCard(
          onLogout: onLogout,
          onDeleteAccount: onDeleteAccount,
        ),
      ],
    );
  }
}

