import 'package:dictionarydox/src/presentation/blocs/auth/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

mixin LoginMixin<T extends StatefulWidget> on State<T> {
  void handleAuthStateChange(BuildContext context, AuthState state) {
    if (state is Authenticated) {
      context.go('/');
    } else if (state is AuthError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  bool isWideScreen(BuildContext context) {
    return MediaQuery.of(context).size.width > 900;
  }
}
