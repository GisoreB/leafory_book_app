import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:leafory/core/extensions/theme_data_extension.dart';
import 'package:leafory/core/routing/routes.dart';
import 'package:leafory/features/book_discovery/domain/entities/book.dart';
import 'package:leafory/features/book_discovery/presentation/blocs/book_search/book_search_bloc.dart';
import 'package:leafory/features/liked_books/presentation/blocs/liked_books_bloc.dart';
import 'package:leafory/shared/widgets/book_list_tile.dart';
import 'package:leafory/shared/widgets/info_placeholder.dart';
import 'package:leafory/shared/widgets/loading_indicator.dart';

class SearchResultsView extends StatelessWidget {
  const SearchResultsView({required this.scrollController, super.key});

  final ScrollController scrollController;

  static const PageStorageKey<Object> _storageKey = PageStorageKey<Object>('search-results-list');

  void _navigateToBookDetailsPage(BuildContext context, {required int bookId}) {
    context.push(Routes.bookDetails.replaceAll(':id', bookId.toString()));
  }

  void _clearQuery(BuildContext context) => context.read<BookSearchBloc>().add(const SearchBooks(''));

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (bool didPop, dynamic result) => _clearQuery(context),
      child: BlocBuilder<BookSearchBloc, BookSearchState>(
        builder: (BuildContext context, BookSearchState searchState) {
          if (searchState is BookSearchInitial) {
            return InfoPlaceholder(
              message: 'Search for books by title or author.',
              color: context.customColorTheme.textSecondary,
              icon: Icons.search_rounded,
            );
          }
          if (searchState is BookSearchLoading) {
            return const LoadingIndicator();
          }
          if (searchState is BookSearchError) {
            return InfoPlaceholder(
              message: searchState.message,
              color: context.customColorTheme.error,
              icon: Icons.error_outline_rounded,
            );
          }
          if (searchState is BookSearchLoaded) {
            final List<Book> books = searchState.books;

            if (books.isEmpty) {
              return InfoPlaceholder(
                message: 'No books found for your search.',
                color: context.customColorTheme.textSecondary,
                icon: Icons.search_off_rounded,
              );
            }

            return BlocBuilder<LikedBooksBloc, LikedBooksState>(
              builder: (BuildContext context, LikedBooksState likedState) {
                final Set<int> likedBookIds = likedState is LikedBooksLoaded ? likedState.likedBookIds : <int>{};

                return ListView.builder(
                  key: _storageKey,
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
                  itemCount: books.length + (searchState.hasReachedMax ? 0 : 1),
                  itemBuilder: (BuildContext context, int index) {
                    if (index >= books.length) {
                      return const LoadingIndicator.withPadding(padding: EdgeInsets.symmetric(vertical: 16));
                    }

                    final Book book = books[index];
                    final bool isLiked = likedBookIds.contains(book.id);

                    return BookListTile(
                      book: book,
                      isLiked: isLiked,
                      margin: const EdgeInsets.only(bottom: 16),
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
    );
  }
}
