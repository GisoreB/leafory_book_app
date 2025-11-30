import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:leafory/core/constants/strings.dart';
import 'package:leafory/core/extensions/theme_data_extension.dart';
import 'package:leafory/core/routing/routes.dart';
import 'package:leafory/features/book_discovery/domain/entities/book.dart';
import 'package:leafory/features/liked_books/presentation/blocs/liked_books_bloc.dart';
import 'package:leafory/shared/extensions/widget_gap_extension.dart';
import 'package:leafory/shared/widgets/book_list_tile.dart';
import 'package:leafory/shared/widgets/info_placeholder.dart';
import 'package:leafory/shared/widgets/loading_indicator.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  void _navigateToBookDetailsPage(BuildContext context, {required int bookId}) {
    context.push(Routes.bookDetails.replaceAll(':id', bookId.toString()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(Strings.favoritesPageTitle)),
      body: SafeArea(
        child: BlocBuilder<LikedBooksBloc, LikedBooksState>(
          builder: (BuildContext context, LikedBooksState state) {
            if (state is LikedBooksLoading) {
              return const LoadingIndicator();
            }
            if (state is LikedBooksError) {
              return InfoPlaceholder(
                message: state.message,
                color: context.customColorTheme.error,
                icon: Icons.error_outline_rounded,
              );
            }
            if (state is LikedBooksLoaded) {
              final List<Book> books = state.books;

              if (books.isEmpty) {
                return InfoPlaceholder(
                  message: 'You don\'t have any favorite books at the moment.',
                  color: context.customColorTheme.textSecondary,
                  icon: Icons.favorite_border_rounded,
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 112),
                itemCount: books.length,
                separatorBuilder: (BuildContext context, int index) => 16.gapHeight,
                itemBuilder: (BuildContext context, int index) {
                  final Book book = books[index];
                  final bool isLiked = state.likedBookIds.contains(book.id);

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
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
