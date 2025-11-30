import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:leafory/core/extensions/theme_data_extension.dart';
import 'package:leafory/core/styles/border_radiuses.dart';
import 'package:leafory/core/styles/opacity_values.dart';
import 'package:leafory/features/book_discovery/domain/entities/book.dart';
import 'package:leafory/shared/extensions/widget_gap_extension.dart';
import 'package:leafory/shared/widgets/loading_indicator.dart';

class BookListTile extends StatelessWidget {
  const BookListTile({
    required this.book,
    required this.isLiked,
    required this.onTap,
    required this.onLikePressed,
    super.key,
    this.margin,
  });

  final Book book;
  final bool isLiked;
  final VoidCallback onTap, onLikePressed;
  final EdgeInsets? margin;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 162,
        margin: margin,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.customColorTheme.white,
          borderRadius: BorderRadius.circular(BorderRadiuses.semiLarge),
        ),
        child: Row(
          spacing: 16,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            book.imageUrl.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(BorderRadiuses.small),
                    child: RepaintBoundary(
                      child: CachedNetworkImage(
                        imageUrl: book.imageUrl,
                        width: 100,
                        fit: BoxFit.cover,
                        placeholder: (BuildContext context, String url) => const LoadingIndicator(),
                        errorWidget: (BuildContext context, String url, Object error) => Container(
                          width: 100,
                          decoration: BoxDecoration(
                            color: context.customColorTheme.error.withValues(alpha: OpacityValues.low),
                            borderRadius: BorderRadius.circular(BorderRadiuses.small),
                          ),
                          child: Icon(Icons.error_outline_rounded, size: 32, color: context.customColorTheme.error),
                        ),
                      ),
                    ),
                  )
                : Container(
                    width: 100,
                    decoration: BoxDecoration(
                      color: context.customColorTheme.primary.withValues(alpha: OpacityValues.low),
                      borderRadius: BorderRadius.circular(BorderRadiuses.small),
                    ),
                    child: Icon(Icons.image, size: 32, color: context.customColorTheme.white),
                  ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  10.gapHeight,
                  Text(
                    book.title,
                    style: context.textTheme.titleMedium?.copyWith(
                      color: context.customColorTheme.textPrimary,
                      fontWeight: FontWeight.w600,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  14.gapHeight,
                  Text(
                    book.author,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: context.customColorTheme.textSecondary,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  8.gapHeight,
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: IconButton(
                        onPressed: onLikePressed,
                        alignment: Alignment.center,
                        style: IconButton.styleFrom(backgroundColor: context.customColorTheme.primaryLight),
                        icon: Icon(
                          isLiked ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
                          color: context.customColorTheme.primary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
