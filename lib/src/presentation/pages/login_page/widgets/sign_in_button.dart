import 'package:dictionarydox/src/presentation/blocs/auth/auth_bloc.dart';
import 'package:dictionarydox/src/presentation/blocs/auth/auth_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInButton extends StatelessWidget {
  final bool isLoading;

  const SignInButton({
    super.key,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: isLoading
          ? null
          : () {
              context.read<AuthBloc>().add(SignInWithGoogleEvent());
            },
      icon: isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Color(0xFF2196F3),
                ),
              ),
            )
          : const Icon(
              Icons.login,
              size: 24,
            ),
      label: Text(
        isLoading ? 'Signing in...' : 'Sign in with Google',
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF2196F3),
        padding: const EdgeInsets.symmetric(
          horizontal: 32,
          vertical: 16,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 4,
      ),
    );
  }
}
