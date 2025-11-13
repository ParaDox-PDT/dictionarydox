import 'package:dictionarydox/src/core/utils/responsive_utils.dart';
import 'package:dictionarydox/src/data/models/user_model.dart';
import 'package:dictionarydox/src/presentation/pages/profile_page/mixin/profile_mixin.dart';
import 'package:dictionarydox/src/presentation/pages/profile_page/widgets/account_info_card.dart';
import 'package:dictionarydox/src/presentation/pages/profile_page/widgets/profile_actions.dart';
import 'package:dictionarydox/src/presentation/pages/profile_page/widgets/profile_app_bar.dart';
import 'package:dictionarydox/src/presentation/pages/profile_page/widgets/profile_skeleton_loader.dart';
import 'package:dictionarydox/src/presentation/pages/profile_page/widgets/settings_card.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with ProfileMixin {
  @override
  Widget build(BuildContext context) {
    if (userId == null) {
      return const Scaffold(
        body: Center(
          child: Text('Not signed in'),
        ),
      );
    }

    return Scaffold(
      body: StreamBuilder<UserModel?>(
        stream: userService.getUserStream(userId!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const ProfileSkeletonLoader();
          }

          final user = snapshot.data;
          if (user == null) {
            return const Center(child: Text('User not found'));
          }

          return ResponsiveWrapper(
            maxWidth: 600,
            child: CustomScrollView(
              slivers: [
                ProfileAppBar(user: user),
                SliverPadding(
                  padding: ResponsiveUtils.getResponsivePadding(context),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      const SizedBox(height: 24),
                      AccountInfoCard(user: user),
                      const SizedBox(height: 24),
                      const SettingsCard(),
                      const SizedBox(height: 24),
                      ProfileActions(
                        onLogout: () => handleLogout(context),
                        onDeleteAccount: () => handleDeleteAccount(context),
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
            ),
          );
        },
      ),
    );
  }
}
