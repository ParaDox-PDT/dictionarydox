import 'package:dictionarydox/src/core/services/notification_service.dart';
import 'package:dictionarydox/src/core/services/user_service.dart';
import 'package:dictionarydox/src/data/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Authentication service using Firebase Auth and Google Sign-In
class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final UserService _userService = UserService();
  final NotificationService _notificationService = NotificationService();

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    // Don't specify clientId for web - let Firebase handle it
    scopes: ['email', 'profile'],
  );

  /// Get current user
  User? get currentUser => _firebaseAuth.currentUser;

  /// Check if user is signed in
  bool get isSignedIn => currentUser != null;

  /// Get auth state changes stream
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  /// Sign in with Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      if (kDebugMode) {
        print('Starting Google Sign-In...');
      }

      UserCredential? userCredential;

      if (kIsWeb) {
        // Web: Use Firebase Auth popup directly
        final GoogleAuthProvider googleProvider = GoogleAuthProvider();
        googleProvider.addScope('email');
        googleProvider.addScope('profile');

        try {
          userCredential = await _firebaseAuth.signInWithPopup(googleProvider);

          if (kDebugMode) {
            print('Signed in to Firebase: ${userCredential.user?.email}');
          }
        } on FirebaseAuthException catch (e) {
          // Handle popup closed by user
          if (e.code == 'popup-closed-by-user' || 
              e.code == 'cancelled-popup-request' ||
              e.message?.contains('popup') == true) {
            if (kDebugMode) {
              print('Sign-in popup closed by user');
            }
            return null;
          }
          // Re-throw other Firebase auth exceptions
          rethrow;
        }
      } else {
        // Mobile: Use google_sign_in package
        GoogleSignInAccount? googleUser;
        googleUser = await _googleSignIn.signIn();

        if (googleUser == null) {
          // User canceled the sign-in
          if (kDebugMode) {
            print('Google Sign-In canceled by user');
          }
          return null;
        }

        if (kDebugMode) {
          print('Google user: ${googleUser.email}');
        }

        // Obtain the auth details from the request
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        if (kDebugMode) {
          print('Got Google auth details');
        }

        // Create a new credential
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        // Sign in to Firebase with the Google credential
        userCredential = await _firebaseAuth.signInWithCredential(credential);

        if (kDebugMode) {
          print('Signed in to Firebase: ${userCredential.user?.email}');
        }
      }

      // Save user to Firestore
      if (userCredential.user != null) {
        final user = userCredential.user!;
        final userModel = UserModel.fromFirebaseUser(
          uid: user.uid,
          email: user.email ?? '',
          displayName: user.displayName,
          photoUrl: user.photoURL,
        );

        await _userService.createOrUpdateUser(userModel);

        // Get and save FCM token
        try {
          final fcmToken = _notificationService.fcmToken;
          if (fcmToken != null) {
            await _userService.updateFcmToken(user.uid, fcmToken);
            if (kDebugMode) {
              print('FCM token saved to Firestore');
            }
          } else {
            // Try to get token if not already initialized
            await _notificationService.initialize();
            final newFcmToken = _notificationService.fcmToken;
            if (newFcmToken != null) {
              await _userService.updateFcmToken(user.uid, newFcmToken);
              if (kDebugMode) {
                print('FCM token obtained and saved to Firestore');
              }
            }
          }
        } catch (e) {
          // Don't fail login if FCM token save fails
          if (kDebugMode) {
            print('Error saving FCM token: $e');
          }
        }

        if (kDebugMode) {
          print('User data saved to Firestore');
        }
      }

      return userCredential;
    } catch (e) {
      if (kDebugMode) {
        print('Error signing in with Google: $e');
      }
      rethrow;
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();

      // Only sign out from Google Sign-In on mobile
      if (!kIsWeb) {
        await _googleSignIn.signOut();
      }

      if (kDebugMode) {
        print('User signed out');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error signing out: $e');
      }
      rethrow;
    }
  }

  /// Delete account
  Future<void> deleteAccount() async {
    try {
      final user = currentUser;
      if (user != null) {
        // Delete user from Firestore first
        await _userService.deleteUser(user.uid);

        // Then delete Firebase Auth account
        await user.delete();

        // Only sign out from Google Sign-In on mobile
        if (!kIsWeb) {
          await _googleSignIn.signOut();
        }

        if (kDebugMode) {
          print('User account deleted');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting account: $e');
      }
      rethrow;
    }
  }

  /// Get user display name
  String? get displayName => currentUser?.displayName;

  /// Get user email
  String? get email => currentUser?.email;

  /// Get user photo URL
  String? get photoURL => currentUser?.photoURL;

  /// Get user ID
  String? get uid => currentUser?.uid;
}
