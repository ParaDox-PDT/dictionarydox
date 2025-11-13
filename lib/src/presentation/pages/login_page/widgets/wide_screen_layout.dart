import 'package:dictionarydox/src/presentation/pages/login_page/widgets/sign_in_card.dart';
import 'package:dictionarydox/src/presentation/pages/login_page/widgets/welcome_section.dart';
import 'package:flutter/material.dart';

class WideScreenLayout extends StatelessWidget {
  final bool isLoading;

  const WideScreenLayout({
    super.key,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 1200),
      padding: const EdgeInsets.all(48),
      child: Row(
        children: [
          const Expanded(
            flex: 3,
            child: WelcomeSection(),
          ),
          const SizedBox(width: 80),
          Expanded(
            flex: 2,
            child: SignInCard(isLoading: isLoading),
          ),
        ],
      ),
    );
  }
}
