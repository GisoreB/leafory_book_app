import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:leafory/core/extensions/theme_data_extension.dart';
import 'package:leafory/core/routing/routes.dart';
import 'package:leafory/core/styles/border_radiuses.dart';
import 'package:leafory/features/book_discovery/domain/entities/book.dart';
import 'package:leafory/features/book_discovery/presentation/blocs/book_search/book_search_bloc.dart';
import 'package:leafory/features/book_discovery/presentation/blocs/popular_books/popular_books_bloc.dart';
import 'package:leafory/features/book_discovery/presentation/blocs/random_books/random_books_bloc.dart';
import 'package:leafory/features/book_discovery/presentation/widgets/book_search_delegate.dart';
import 'package:leafory/features/liked_books/presentation/blocs/liked_books_bloc.dart';
import 'package:leafory/shared/extensions/widget_gap_extension.dart';
import 'package:leafory/shared/widgets/book_list_tile.dart';
import 'package:leafory/shared/widgets/featured_book_card.dart';
import 'package:leafory/shared/widgets/info_placeholder.dart';
import 'package:leafory/shared/widgets/loading_indicator.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _openSearchDelegate(BuildContext context) => showSearch(
    context: context,
    useRootNavigator: true,
    delegate: BookSearchDelegate(bookSearchBloc: context.read<BookSearchBloc>()),
  );

  void _navigateToPopularBooksPage(BuildContext context) => context.push(Routes.popularBooks);

  void _navigateToBookDetailsPage(BuildContext context, {required int bookId}) {
    context.push(Routes.bookDetails.replaceAll(':id', bookId.toString()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 24, top: 24),
              child: Text(
                'Find your\ndream books',
                style: context.textTheme.headlineMedium?.copyWith(
                  color: context.customColorTheme.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            GestureDetector(
              onTap: () => _openSearchDelegate(context),
              child: Container(
                height: 56,
                margin: const EdgeInsets.only(left: 24, top: 30, right: 24),
                padding: const EdgeInsets.fromLTRB(20, 8, 8, 8),
                decoration: BoxDecoration(
                  color: context.customColorTheme.white,
                  borderRadius: BorderRadius.circular(BorderRadiuses.large),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Search your favorite book',
                      style: context.textTheme.bodyMedium?.copyWith(color: context.customColorTheme.textSecondary),
                    ),
                    CircleAvatar(
                      backgroundColor: context.customColorTheme.primary,
                      child: Icon(Icons.search_rounded, color: context.customColorTheme.white),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 30, 24, 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Popular Books',
                    style: context.textTheme.titleMedium?.copyWith(
                      color: context.customColorTheme.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _navigateToPopularBooksPage(context),
                    child: Text(
                      'View all',
                      style: context.textTheme.labelMedium?.copyWith(
                        color: context.customColorTheme.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            BlocBuilder<PopularBooksBloc, PopularBooksState>(
              builder: (BuildContext context, PopularBooksState state) {
                if (state is PopularBooksLoading) {
                  return const LoadingIndicator.withPadding(padding: EdgeInsets.symmetric(vertical: 40));
                }
                if (state is PopularBooksError) {
                  return InfoPlaceholder(
                    message: state.message,
                    color: context.customColorTheme.error,
                    icon: Icons.error_outline_rounded,
                  );
                }
                if (state is PopularBooksLoaded) {
                  final List<Book> books = state.books.take(8).toList();

                  if (books.isEmpty) {
                    return InfoPlaceholder(
                      message: 'We couldn\'t find any popular books at the moment.\nPlease try again later.',
                      color: context.customColorTheme.textSecondary,
                      icon: Icons.library_books_outlined,
                    );
                  }

                  return SizedBox(
                    height: 262,
                    child: ListView.separated(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      itemCount: books.length,
                      separatorBuilder: (BuildContext context, int index) => 16.gapWidth,
                      itemBuilder: (BuildContext context, int index) {
                        final Book book = books[index];

                        return FeaturedBookCard(
                          book: book,
                          onTap: () => _navigateToBookDetailsPage(context, bookId: book.id),
                        );
                      },
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 30, 24, 20),
              child: Text(
                'Our Recommendations',
                style: context.textTheme.titleMedium?.copyWith(
                  color: context.customColorTheme.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            BlocBuilder<RandomBooksBloc, RandomBooksState>(
              builder: (BuildContext context, RandomBooksState randomState) {
                if (randomState is RandomBooksLoading) {
                  return const LoadingIndicator.withPadding(padding: EdgeInsets.symmetric(vertical: 40));
                }
                if (randomState is RandomBooksError) {
                  return InfoPlaceholder(
                    message: randomState.message,
                    color: context.customColorTheme.error,
                    icon: Icons.error_outline_rounded,
                  );
                }
                if (randomState is RandomBooksLoaded) {
                  final List<Book> books = randomState.books;

                  if (books.isEmpty) {
                    return InfoPlaceholder(
                      message: 'We couldn\'t find any recommended books at the moment.\nPlease try again later.',
                      color: context.customColorTheme.textSecondary,
                      icon: Icons.library_books_outlined,
                    );
                  }

                  return BlocBuilder<LikedBooksBloc, LikedBooksState>(
                    builder: (BuildContext context, LikedBooksState likedState) {
                      final Set<int> likedBookIds = likedState is LikedBooksLoaded ? likedState.likedBookIds : <int>{};

                      return ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.only(left: 24, right: 24, bottom: 112),
                        itemCount: books.length,
                        separatorBuilder: (BuildContext context, int index) => 16.gapHeight,
                        itemBuilder: (BuildContext context, int index) {
                          final Book book = books[index];
                          final bool isLiked = likedBookIds.contains(book.id);

                          return BookListTile(
                            book: book,
                            isLiked: isLiked,
                            onTap: () => _navigateToBookDetailsPage(context, bookId: book.id),
                            onLikePressed: () {
                              final LikedBooksBloc likedBooksBloc = context.read<LikedBooksBloc>();

                              if (isLiked) {
                                likedBooksBloc.add(UnlikeBook(book.id));
                              } else {
                                likedBooksBloc.add(LikeBook(book));
                              }
                            },
                          );
                        },
                      );
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}
