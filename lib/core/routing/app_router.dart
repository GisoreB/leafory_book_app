import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:leafory/core/dependency_injection/service_locator.dart';
import 'package:leafory/core/routing/routes.dart';
import 'package:leafory/features/app_startup/presentation/pages/splash_page.dart';
import 'package:leafory/features/book_discovery/presentation/blocs/book_details/book_details_bloc.dart';
import 'package:leafory/features/book_discovery/presentation/pages/book_details_page.dart';
import 'package:leafory/features/book_discovery/presentation/pages/home_page.dart';
import 'package:leafory/features/book_discovery/presentation/pages/popular_books_page.dart';
import 'package:leafory/features/liked_books/presentation/pages/favorites_page.dart';
import 'package:leafory/shared/widgets/main_shell.dart';

final class AppRouter {
  AppRouter._();

  static final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> _shellNavigatorHomeKey = GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> _shellNavigatorFavoritesKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    initialLocation: Routes.splash,
    navigatorKey: _rootNavigatorKey,
    routes: <RouteBase>[
      GoRoute(
        path: Routes.splash,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (BuildContext context, GoRouterState state) => const SplashPage(),
      ),

      StatefulShellRoute.indexedStack(
        builder: (BuildContext context, GoRouterState state, StatefulNavigationShell navigationShell) {
          return MainShell(navigationShell: navigationShell);
        },
        branches: <StatefulShellBranch>[
          StatefulShellBranch(
            navigatorKey: _shellNavigatorHomeKey,
            routes: <RouteBase>[
              GoRoute(path: Routes.home, builder: (BuildContext context, GoRouterState state) => const HomePage()),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorFavoritesKey,
            routes: <RouteBase>[
              GoRoute(
                path: Routes.favorites,
                builder: (BuildContext context, GoRouterState state) => const FavoritesPage(),
              ),
            ],
          ),
        ],
      ),

      GoRoute(
        path: Routes.popularBooks,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (BuildContext context, GoRouterState state) => const PopularBooksPage(),
      ),

      GoRoute(
        path: Routes.bookDetails,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (BuildContext context, GoRouterState state) {
          final int bookId = int.parse(state.pathParameters['id']!);

          return BlocProvider<BookDetailsBloc>(
            create: (BuildContext context) =>
                BookDetailsBloc(bookRepository: ServiceLocator.instance.bookRepository)..add(FetchBookDetails(bookId)),
            child: BookDetailsPage(id: bookId),
          );
        },
      ),
    ],
  );
}
