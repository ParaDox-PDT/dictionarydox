import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Authentication events
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Check authentication status
class CheckAuthStatusEvent extends AuthEvent {}

/// Sign in with Google
class SignInWithGoogleEvent extends AuthEvent {}

/// Sign out
class SignOutEvent extends AuthEvent {}

/// Auth state changed (from Firebase stream)
class AuthStateChangedEvent extends AuthEvent {
  final User? user;

  const AuthStateChangedEvent(this.user);

  @override
  List<Object?> get props => [user];
}
