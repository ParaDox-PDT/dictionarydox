import 'package:dictionarydox/src/core/services/auth_service.dart';
import 'package:dictionarydox/src/domain/entities/unit.dart';
import 'package:dictionarydox/src/presentation/blocs/quiz/quiz_event.dart';
import 'package:dictionarydox/src/presentation/pages/home_page/pages/create_unit_page/create_unit_page.dart';
import 'package:dictionarydox/src/presentation/pages/login_page/login_page.dart';
import 'package:dictionarydox/src/presentation/pages/splash_screen/splash_screen.dart';
import 'package:dictionarydox/src/presentation/pages/unit_details_page/pages/add_word_page/add_word_page.dart';
import 'package:dictionarydox/src/presentation/pages/unit_details_page/pages/image_search_page/image_search_page.dart';
import 'package:dictionarydox/src/presentation/pages/unit_details_page/pages/quiz_page/quiz_page.dart';
import 'package:dictionarydox/src/presentation/pages/unit_details_page/pages/quiz_type_selector_page/quiz_type_selector_page.dart';
import 'package:dictionarydox/src/presentation/pages/unit_details_page/unit_details_page.dart';
import 'package:dictionarydox/src/presentation/widgets/bottom_nav_shell.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  initialLocation: '/splash',
  redirect: (context, state) {
    final authService = AuthService();
    final isSignedIn = authService.isSignedIn;
    final isGoingToLogin = state.matchedLocation == '/login';
    final isGoingToSplash = state.matchedLocation == '/splash';

    // Allow splash screen
    if (isGoingToSplash) {
      return null;
    }

    // If not signed in and not going to login, redirect to login
    if (!isSignedIn && !isGoingToLogin) {
      return '/login';
    }

    // If signed in and going to login, redirect to home
    if (isSignedIn && isGoingToLogin) {
      return '/';
    }

    return null;
  },
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),

    // Main route with Bottom Navigation
    GoRoute(
      path: '/',
      builder: (context, state) => const BottomNavShell(),
    ),

    // Routes without bottom navigation
    GoRoute(
      path: '/create-unit',
      builder: (context, state) => const CreateUnitPage(),
    ),
    GoRoute(
      path: '/unit/:unitId',
      builder: (context, state) {
        final unit = state.extra as Unit;
        return UnitDetailsPage(unit: unit);
      },
    ),
    GoRoute(
      path: '/unit/:unitId/add-word',
      builder: (context, state) {
        final unitId = state.pathParameters['unitId']!;
        return AddWordPage(unitId: unitId);
      },
    ),
    GoRoute(
      path: '/unit/:unitId/search-images',
      builder: (context, state) {
        // Try to get query from extra first (for mobile), then from query parameters (for web)
        String? query = state.extra as String?;
        
        // If extra is null, try to get from URL query parameters (for web)
        if (query == null || query.isEmpty) {
          try {
            // Try to get from state.uri (go_router 12+)
            if (state.uri.hasQuery) {
              query = state.uri.queryParameters['query'];
            }
            
            // Decode the query if it was encoded
            if (query != null) {
              query = Uri.decodeComponent(query);
            }
          } catch (e) {
            // If state.uri is not available, query will remain null
            query = null;
          }
        }
        
        if (query == null || query.isEmpty) {
          // If query is null or empty, show error
          return const Scaffold(
            body: Center(
              child: Text('Error: No search query provided'),
            ),
          );
        }
        return ImageSearchPage(query: query);
      },
    ),
    GoRoute(
      path: '/unit/:unitId/quiz-select',
      builder: (context, state) {
        final unitId = state.pathParameters['unitId']!;
        return QuizTypeSelectorPage(unitId: unitId);
      },
    ),
    GoRoute(
      path: '/unit/:unitId/quiz',
      builder: (context, state) {
        final unitId = state.pathParameters['unitId']!;
        final quizType = state.extra as QuizType;
        return QuizPage(unitId: unitId, quizType: quizType);
      },
    ),
  ],
);
