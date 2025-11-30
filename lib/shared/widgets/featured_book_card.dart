import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:leafory/core/extensions/theme_data_extension.dart';
import 'package:leafory/core/styles/border_radiuses.dart';
import 'package:leafory/core/styles/opacity_values.dart';
import 'package:leafory/features/book_discovery/domain/entities/book.dart';
import 'package:leafory/shared/extensions/widget_gap_extension.dart';
import 'package:leafory/shared/widgets/loading_indicator.dart';

class FeaturedBookCard extends StatelessWidget {
  const FeaturedBookCard({required this.book, required this.onTap, super.key});

  final Book book;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 140,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            book.imageUrl.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(BorderRadiuses.small),
                    child: RepaintBoundary(
                      child: CachedNetworkImage(
                        imageUrl: book.imageUrl,
                        height: 200,
                        fit: BoxFit.cover,
                        placeholder: (BuildContext context, String url) => const LoadingIndicator(),
                        errorWidget: (BuildContext context, String url, Object error) => Container(
                          height: 200,
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
                    height: 200,
                    decoration: BoxDecoration(
                      color: context.customColorTheme.primary.withValues(alpha: OpacityValues.low),
                      borderRadius: BorderRadius.circular(BorderRadiuses.small),
                    ),
                    child: Icon(Icons.image, size: 32, color: context.customColorTheme.white),
                  ),
            10.gapHeight,
            Text(
              book.title,
              style: context.textTheme.titleMedium?.copyWith(
                color: context.customColorTheme.textPrimary,
                fontWeight: FontWeight.w600,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            4.gapHeight,
            Text(
              book.author,
              style: context.textTheme.labelMedium?.copyWith(
                color: context.customColorTheme.textSecondary,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
