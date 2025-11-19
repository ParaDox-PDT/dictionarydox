import 'package:dictionarydox/src/core/utils/responsive_utils.dart';
import 'package:dictionarydox/src/data/models/user_model.dart';
import 'package:dictionarydox/src/presentation/pages/profile_page/widgets/account_info_card.dart';
import 'package:dictionarydox/src/presentation/pages/profile_page/widgets/profile_app_bar.dart';
import 'package:dictionarydox/src/presentation/pages/profile_page/widgets/settings_card.dart';
import 'package:flutter/material.dart';

class MobileProfileLayout extends StatelessWidget {
  final UserModel user;
  final VoidCallback onLogout;
  final VoidCallback onDeleteAccount;

  const MobileProfileLayout({
    super.key,
    required this.user,
    required this.onLogout,
    required this.onDeleteAccount,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        ProfileAppBar(user: user),
        SliverPadding(
          padding: ResponsiveUtils.getResponsivePadding(context),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(height: 24),
              AccountInfoCard(user: user),
              const SizedBox(height: 24),
              SettingsCard(
                onLogout: onLogout,
                onDeleteAccount: onDeleteAccount,
              ),
              const SizedBox(height: 32),
              Center(
                child: Text(
                  'DictionaryDox v1.0.0',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const SizedBox(height: 200),
            ]),
          ),
        ),
      ],
    );
  }
}

