import 'package:dictionarydox/src/core/utils/responsive_utils.dart';
import 'package:dictionarydox/src/data/models/user_model.dart';
import 'package:dictionarydox/src/presentation/pages/profile_page/mixin/profile_mixin.dart';
import 'package:dictionarydox/src/presentation/pages/profile_page/widgets/mobile_profile_layout.dart';
import 'package:dictionarydox/src/presentation/pages/profile_page/widgets/profile_skeleton_loader.dart';
import 'package:dictionarydox/src/presentation/pages/profile_page/widgets/web_profile_layout.dart';
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

    return StreamBuilder<UserModel?>(
      stream: userService.getUserStream(userId!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: ProfileSkeletonLoader(),
          );
        }

        final user = snapshot.data;
        if (user == null) {
          return const Scaffold(
            body: Center(child: Text('User not found')),
          );
        }

        final isMobile = ResponsiveUtils.isMobile(context);

        return Scaffold(
          appBar: isMobile ? null : AppBar(
            title: const Text('Profile'),
            elevation: 0,
          ),
          body: isMobile
              ? ResponsiveWrapper(
                  maxWidth: 600,
                  child: MobileProfileLayout(
                    user: user,
                    onLogout: () => handleLogout(context),
                    onDeleteAccount: () => handleDeleteAccount(context),
                  ),
                )
              : Scrollbar(
                  thumbVisibility: false,
                  child: SingleChildScrollView(
                    child: Center(
                      child: ResponsiveWrapper(
                        maxWidth: ResponsiveUtils.getMaxContentWidth(context),
                        child: WebProfileLayout(
                          user: user,
                          onLogout: () => handleLogout(context),
                          onDeleteAccount: () => handleDeleteAccount(context),
                        ),
                      ),
                    ),
                  ),
                ),
        );
      },
    );
  }
}
