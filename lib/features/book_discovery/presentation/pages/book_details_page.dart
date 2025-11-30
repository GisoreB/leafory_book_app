import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leafory/core/constants/strings.dart';
import 'package:leafory/core/extensions/number_formatter_extension.dart';
import 'package:leafory/core/extensions/theme_data_extension.dart';
import 'package:leafory/core/styles/border_radiuses.dart';
import 'package:leafory/core/styles/opacity_values.dart';
import 'package:leafory/features/book_discovery/domain/entities/book.dart';
import 'package:leafory/features/book_discovery/presentation/blocs/book_details/book_details_bloc.dart';
import 'package:leafory/features/liked_books/presentation/blocs/liked_books_bloc.dart';
import 'package:leafory/shared/widgets/full_image_view.dart';
import 'package:leafory/shared/widgets/info_placeholder.dart';
import 'package:leafory/shared/widgets/loading_indicator.dart';

class BookDetailsPage extends StatelessWidget {
  const BookDetailsPage({required this.id, super.key});

  final int id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(Strings.bookDetailsPageTitle)),
      body: SafeArea(
        child: BlocBuilder<BookDetailsBloc, BookDetailsState>(
          builder: (BuildContext context, BookDetailsState state) {
            if (state is BookDetailsLoading) {
              return const LoadingIndicator();
            }
            if (state is BookDetailsError) {
              return InfoPlaceholder(
                message: state.message,
                color: context.customColorTheme.error,
                icon: Icons.error_outline_rounded,
              );
            }
            if (state is BookDetailsLoaded) {
              final Book book = state.book;

              return ListView(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 96),
                children: <Widget>[
                  UnconstrainedBox(
                    child: Container(
                      width: 166,
                      height: 226,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: context.customColorTheme.white,
                        borderRadius: BorderRadius.circular(BorderRadiuses.semiMedium),
                      ),
                      child: book.imageUrl.isNotEmpty
                          ? GestureDetector(
                              onTap: () {
                                showGeneralDialog(
                                  context: context,
                                  barrierDismissible: true,
                                  barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
                                  pageBuilder:
                                      (
                                        BuildContext context,
                                        Animation<double> animation,
                                        Animation<double> secondaryAnimation,
                                      ) => FullImageView(imageUrl: book.imageUrl),
                                  transitionBuilder:
                                      (
                                        BuildContext context,
                                        Animation<double> animation,
                                        Animation<double> secondaryAnimation,
                                        Widget child,
                                      ) => FadeTransition(opacity: animation, child: child),
                                );
                              },
                              child: Hero(
                                tag: book.imageUrl,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(BorderRadiuses.small),
                                  child: RepaintBoundary(
                                    child: CachedNetworkImage(
                                      imageUrl: book.imageUrl,
                                      fit: BoxFit.cover,
                                      placeholder: (BuildContext context, String url) => const LoadingIndicator(),
                                      errorWidget: (BuildContext context, String url, Object error) => Container(
                                        decoration: BoxDecoration(
                                          color: context.customColorTheme.error.withValues(alpha: OpacityValues.low),
                                          borderRadius: BorderRadius.circular(BorderRadiuses.small),
                                        ),
                                        child: Icon(
                                          Icons.error_outline_rounded,
                                          size: 32,
                                          color: context.customColorTheme.error,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                color: context.customColorTheme.primary.withValues(alpha: OpacityValues.low),
                                borderRadius: BorderRadius.circular(BorderRadiuses.small),
                              ),
                              child: Icon(Icons.image, size: 32, color: context.customColorTheme.white),
                            ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 30),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: context.customColorTheme.white,
                      borderRadius: BorderRadius.circular(BorderRadiuses.regular),
                    ),
                    child: Column(
                      spacing: 12,
                      children: <Widget>[
                        Text(
                          book.title,
                          textAlign: TextAlign.center,
                          style: context.textTheme.titleLarge?.copyWith(
                            color: context.customColorTheme.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'by ${book.author}',
                          textAlign: TextAlign.center,
                          style: context.textTheme.titleMedium?.copyWith(
                            color: context.customColorTheme.textPrimary,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 24),
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      color: context.customColorTheme.white,
                      borderRadius: BorderRadius.circular(BorderRadiuses.regular),
                    ),
                    child: IntrinsicHeight(
                      child: Row(
                        spacing: 8,
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              spacing: 4,
                              children: <Widget>[
                                Text(
                                  'Copyright',
                                  textAlign: TextAlign.center,
                                  style: context.textTheme.labelMedium?.copyWith(
                                    color: context.customColorTheme.textSecondary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  switch (book.isCopyrighted) {
                                    null => 'Unknown',
                                    true => 'Protected',
                                    false => 'Open',
                                  },
                                  textAlign: TextAlign.center,
                                  style: context.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: context.customColorTheme.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          VerticalDivider(width: 1, thickness: 1, color: context.customColorTheme.textSecondary),
                          Expanded(
                            child: Column(
                              spacing: 4,
                              children: <Widget>[
                                Text(
                                  'Number of downloads',
                                  textAlign: TextAlign.center,
                                  style: context.textTheme.labelMedium?.copyWith(
                                    color: context.customColorTheme.textSecondary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  book.downloadCount.toDownloadCountString(),
                                  textAlign: TextAlign.center,
                                  style: context.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: context.customColorTheme.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          VerticalDivider(width: 1, thickness: 1, color: context.customColorTheme.textSecondary),
                          Expanded(
                            child: Column(
                              spacing: 4,
                              children: <Widget>[
                                Text(
                                  'Languages',
                                  textAlign: TextAlign.center,
                                  style: context.textTheme.labelMedium?.copyWith(
                                    color: context.customColorTheme.textSecondary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  book.languages.join(', ').toUpperCase(),
                                  textAlign: TextAlign.center,
                                  style: context.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: context.customColorTheme.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 24),
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      color: context.customColorTheme.white,
                      borderRadius: BorderRadius.circular(BorderRadiuses.regular),
                    ),
                    child: Column(
                      spacing: 10,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Summaries',
                          style: context.textTheme.titleMedium?.copyWith(
                            color: context.customColorTheme.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (book.summaries.isEmpty)
                          InfoPlaceholder(
                            message: 'This book does not have a summary.',
                            color: context.customColorTheme.textSecondary,
                          )
                        else
                          ...book.summaries.map(
                            (String summary) => Text(
                              summary,
                              style: context.textTheme.bodyMedium?.copyWith(
                                color: context.customColorTheme.textSecondary,
                                height: 1.67,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: BlocBuilder<BookDetailsBloc, BookDetailsState>(
          builder: (BuildContext context, BookDetailsState detailsState) {
            if (detailsState is BookDetailsLoaded) {
              final Book book = detailsState.book;

              return BlocBuilder<LikedBooksBloc, LikedBooksState>(
                builder: (BuildContext context, LikedBooksState likedState) {
                  final bool isLiked = likedState is LikedBooksLoaded
                      ? likedState.likedBookIds.contains(book.id)
                      : false;

                  return FloatingActionButton(
                    onPressed: () {
                      final LikedBooksBloc likedBooksBloc = context.read<LikedBooksBloc>();

                      if (isLiked) {
                        likedBooksBloc.add(UnlikeBook(book.id));
                      } else {
                        likedBooksBloc.add(LikeBook(book));
                      }
                    },
                    elevation: 0,
                    shape: const CircleBorder(),
                    backgroundColor: context.customColorTheme.primaryLight,
                    splashColor: context.customColorTheme.primaryLight,
                    child: Icon(
                      isLiked ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
                      color: context.customColorTheme.primary,
                      size: 32,
                    ),
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
