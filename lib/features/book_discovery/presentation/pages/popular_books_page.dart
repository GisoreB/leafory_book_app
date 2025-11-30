import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:leafory/core/constants/strings.dart';
import 'package:leafory/core/extensions/theme_data_extension.dart';
import 'package:leafory/core/routing/routes.dart';
import 'package:leafory/features/book_discovery/domain/entities/book.dart';
import 'package:leafory/features/book_discovery/presentation/blocs/popular_books/popular_books_bloc.dart';
import 'package:leafory/features/liked_books/presentation/blocs/liked_books_bloc.dart';
import 'package:leafory/shared/widgets/book_list_tile.dart';
import 'package:leafory/shared/widgets/info_placeholder.dart';
import 'package:leafory/shared/widgets/loading_indicator.dart';

class PopularBooksPage extends StatefulWidget {
  const PopularBooksPage({super.key});

  @override
  State<PopularBooksPage> createState() => _PopularBooksPageState();
}

class _PopularBooksPageState extends State<PopularBooksPage> {
  final ScrollController _scrollController = ScrollController();

  late final PopularBooksBloc _popularBooksBloc;
  late final LikedBooksBloc _likedBooksBloc;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    _popularBooksBloc = context.read<PopularBooksBloc>();
    _likedBooksBloc = context.read<LikedBooksBloc>();
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) {
      return false;
    }

    final double maxScroll = _scrollController.position.maxScrollExtent;
    final double currentScroll = _scrollController.position.pixels;

    return currentScroll >= (maxScroll * 0.9);
  }

  void _onScroll() {
    if (!_isBottom) {
      return;
    }

    final PopularBooksState currentState = _popularBooksBloc.state;
    if (currentState is PopularBooksLoaded && !currentState.hasReachedMax) {
      _popularBooksBloc.add(FetchPopularBooks());
    }
  }

  void _navigateToBookDetailsPage({required int bookId}) {
    context.push(Routes.bookDetails.replaceAll(':id', bookId.toString()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(Strings.popularBooksPageTitle)),
      body: SafeArea(
        child: BlocBuilder<PopularBooksBloc, PopularBooksState>(
          builder: (BuildContext context, PopularBooksState popularState) {
            if (popularState is PopularBooksLoading) {
              return const LoadingIndicator();
            }
            if (popularState is PopularBooksError) {
              return InfoPlaceholder(
                message: popularState.message,
                color: context.customColorTheme.error,
                icon: Icons.error_outline_rounded,
              );
            }
            if (popularState is PopularBooksLoaded) {
              final List<Book> books = popularState.books;

              if (books.isEmpty) {
                return InfoPlaceholder(
                  message: 'We couldn\'t find any popular books at the moment.\nPlease try again later.',
                  color: context.customColorTheme.textSecondary,
                  icon: Icons.library_books_outlined,
                );
              }

              return BlocBuilder<LikedBooksBloc, LikedBooksState>(
                builder: (BuildContext context, LikedBooksState likedState) {
                  final Set<int> likedBookIds = likedState is LikedBooksLoaded ? likedState.likedBookIds : <int>{};

                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
                    itemCount: books.length + (popularState.hasReachedMax ? 0 : 1),
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
                        onTap: () => _navigateToBookDetailsPage(bookId: book.id),
                        onLikePressed: () {
                          if (isLiked) {
                            _likedBooksBloc.add(UnlikeBook(book.id));
                          } else {
                            _likedBooksBloc.add(LikeBook(book));
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
      ),
    );
  }
}
