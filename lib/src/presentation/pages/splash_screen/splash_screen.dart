import 'package:dictionarydox/src/presentation/pages/splash_screen/mixin/splash_mixin.dart';
import 'package:dictionarydox/src/presentation/pages/splash_screen/widgets/splash_content.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin, SplashMixin {
  @override
  void initState() {
    super.initState();
    initializeAnimations();
    checkAuthAndNavigate(context);
  }

  @override
  void dispose() {
    disposeAnimations();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColor.withOpacity(0.7),
            ],
          ),
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: controller,
            builder: (context, child) {
              return SplashContent(
                fadeAnimation: fadeAnimation,
                scaleAnimation: scaleAnimation,
              );
            },
          ),
        ),
      ),
    );
  }
}
