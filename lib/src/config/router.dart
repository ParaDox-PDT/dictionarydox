import 'package:dictionarydox/src/domain/entities/unit.dart';
import 'package:dictionarydox/src/presentation/blocs/quiz/quiz_event.dart';
import 'package:dictionarydox/src/presentation/pages/add_word_page.dart';
import 'package:dictionarydox/src/presentation/pages/create_unit_page.dart';
import 'package:dictionarydox/src/presentation/pages/home_page.dart';
import 'package:dictionarydox/src/presentation/pages/image_search_page.dart';
import 'package:dictionarydox/src/presentation/pages/quiz_page.dart';
import 'package:dictionarydox/src/presentation/pages/quiz_type_selector_page.dart';
import 'package:dictionarydox/src/presentation/pages/splash_screen.dart';
import 'package:dictionarydox/src/presentation/pages/unit_details_page.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
    ),
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
