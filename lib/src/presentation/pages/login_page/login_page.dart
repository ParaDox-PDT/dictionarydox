import 'package:dictionarydox/src/core/providers/initialization_provider.dart';
import 'package:dictionarydox/src/injector_container.dart';
import 'package:dictionarydox/src/presentation/blocs/auth/auth_bloc.dart';
import 'package:dictionarydox/src/presentation/blocs/auth/auth_state.dart';
import 'package:dictionarydox/src/presentation/pages/login_page/mixin/login_mixin.dart';
import 'package:dictionarydox/src/presentation/pages/login_page/widgets/mobile_layout.dart';
import 'package:dictionarydox/src/presentation/pages/login_page/widgets/wide_screen_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: InitializationProvider.of(context).initialization,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 60,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Failed to initialize app',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Error: ${snapshot.error}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          );
        }

        return BlocProvider(
          create: (context) => sl<AuthBloc>(),
          child: const LoginView(),
        );
      },
    );
  }
}

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> with LoginMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: handleAuthStateChange,
        builder: (context, state) {
          final isLoading = state is AuthLoading;

          return Container(
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
              child: SingleChildScrollView(
                child: isWideScreen(context)
                    ? WideScreenLayout(isLoading: isLoading)
                    : MobileLayout(isLoading: isLoading),
              ),
            ),
          );
        },
      ),
    );
  }
}
