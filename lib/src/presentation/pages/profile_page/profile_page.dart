import 'package:dictionarydox/src/core/services/auth_service.dart';
import 'package:dictionarydox/src/core/services/user_service.dart';
import 'package:dictionarydox/src/core/utils/responsive_utils.dart';
import 'package:dictionarydox/src/data/models/user_model.dart';
import 'package:dictionarydox/src/injector_container.dart';
import 'package:dictionarydox/src/presentation/pages/profile_page/widgets/account_info_card.dart';
import 'package:dictionarydox/src/presentation/pages/profile_page/widgets/profile_actions.dart';
import 'package:dictionarydox/src/presentation/pages/profile_page/widgets/profile_app_bar.dart';
import 'package:dictionarydox/src/presentation/pages/profile_page/widgets/profile_skeleton_loader.dart';
import 'package:dictionarydox/src/presentation/pages/profile_page/widgets/settings_card.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = sl<AuthService>();
    final userService = sl<UserService>();
    final userId = authService.uid;

    if (userId == null) {
      return const Scaffold(
        body: Center(
          child: Text('Not signed in'),
        ),
      );
    }

    return Scaffold(
      body: StreamBuilder<UserModel?>(
        stream: userService.getUserStream(userId),
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
                      const ProfileActions(),
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
