import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leafory/core/constants/strings.dart';
import 'package:leafory/core/database/database_service.dart';
import 'package:leafory/core/dependency_injection/service_locator.dart';
import 'package:leafory/core/routing/app_router.dart';
import 'package:leafory/core/theme/app_theme.dart';
import 'package:leafory/features/book_discovery/presentation/blocs/book_search/book_search_bloc.dart';
import 'package:leafory/features/book_discovery/presentation/blocs/popular_books/popular_books_bloc.dart';
import 'package:leafory/features/book_discovery/presentation/blocs/random_books/random_books_bloc.dart';
import 'package:leafory/features/liked_books/presentation/blocs/liked_books_bloc.dart';
import 'package:provider/single_child_widget.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseService.instance.init();
  ServiceLocator.instance.init();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: <SingleChildWidget>[
        BlocProvider<PopularBooksBloc>(
          create: (BuildContext context) =>
              PopularBooksBloc(bookRepository: ServiceLocator.instance.bookRepository)..add(FetchPopularBooks()),
        ),
        BlocProvider<RandomBooksBloc>(
          create: (BuildContext context) =>
              RandomBooksBloc(bookRepository: ServiceLocator.instance.bookRepository)..add(FetchRandomBooks()),
        ),
        BlocProvider<BookSearchBloc>(
          create: (BuildContext context) => BookSearchBloc(bookRepository: ServiceLocator.instance.bookRepository),
        ),
        BlocProvider<LikedBooksBloc>(
          create: (BuildContext context) =>
              LikedBooksBloc(bookRepository: ServiceLocator.instance.bookRepository)..add(LoadLikedBooks()),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: Strings.appName,
        theme: AppTheme.lightTheme,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
