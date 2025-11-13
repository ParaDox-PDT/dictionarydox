import 'package:dictionarydox/src/core/services/auth_service.dart';
import 'package:dictionarydox/src/domain/entities/unit.dart';
import 'package:dictionarydox/src/presentation/blocs/quiz/quiz_event.dart';
import 'package:dictionarydox/src/presentation/pages/home_page/pages/create_unit_page/create_unit_page.dart';
import 'package:dictionarydox/src/presentation/pages/login_page.dart';
import 'package:dictionarydox/src/presentation/pages/splash_screen.dart';
import 'package:dictionarydox/src/presentation/pages/unit_details_page/pages/add_word_page/add_word_page.dart';
import 'package:dictionarydox/src/presentation/pages/unit_details_page/pages/image_search_page/image_search_page.dart';
import 'package:dictionarydox/src/presentation/pages/unit_details_page/pages/quiz_page/quiz_page.dart';
import 'package:dictionarydox/src/presentation/pages/unit_details_page/pages/quiz_type_selector_page/quiz_type_selector_page.dart';
import 'package:dictionarydox/src/presentation/pages/unit_details_page/unit_details_page.dart';
import 'package:dictionarydox/src/presentation/widgets/bottom_nav_shell.dart';
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
        final query = state.extra as String;
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
