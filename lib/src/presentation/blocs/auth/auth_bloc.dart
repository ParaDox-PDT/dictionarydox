import 'dart:async';

import 'package:dictionarydox/src/core/services/auth_service.dart';
import 'package:dictionarydox/src/presentation/blocs/auth/auth_event.dart';
import 'package:dictionarydox/src/presentation/blocs/auth/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Authentication BLoC
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService _authService;
  StreamSubscription? _authStateSubscription;

  AuthBloc(this._authService) : super(AuthInitial()) {
    // Listen to auth state changes from Firebase
    _authStateSubscription = _authService.authStateChanges.listen((user) {
      add(AuthStateChangedEvent(user));
    });

    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
    on<SignInWithGoogleEvent>(_onSignInWithGoogle);
    on<SignOutEvent>(_onSignOut);
    on<AuthStateChangedEvent>(_onAuthStateChanged);
  }

  /// Check current authentication status
  Future<void> _onCheckAuthStatus(
    CheckAuthStatusEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final user = _authService.currentUser;
    if (user != null) {
      emit(Authenticated(user));
    } else {
      emit(Unauthenticated());
    }
  }

  /// Sign in with Google
  Future<void> _onSignInWithGoogle(
    SignInWithGoogleEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoading());

      final userCredential = await _authService.signInWithGoogle();

      if (userCredential == null || userCredential.user == null) {
        // User canceled sign-in
        emit(Unauthenticated());
        return;
      }

      emit(Authenticated(userCredential.user!));
    } catch (e) {
      emit(AuthError('Sign in failed: ${e.toString()}'));
      emit(Unauthenticated());
    }
  }

  /// Sign out
  Future<void> _onSignOut(
    SignOutEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoading());
      await _authService.signOut();
      emit(Unauthenticated());
    } catch (e) {
      emit(AuthError('Sign out failed: ${e.toString()}'));
    }
  }

  /// Handle auth state changes from Firebase
  void _onAuthStateChanged(
    AuthStateChangedEvent event,
    Emitter<AuthState> emit,
  ) {
    if (event.user != null) {
      emit(Authenticated(event.user!));
    } else {
      emit(Unauthenticated());
    }
  }

  @override
  Future<void> close() {
    _authStateSubscription?.cancel();
    return super.close();
  }
}
