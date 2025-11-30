import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_view/photo_view.dart';
import 'package:leafory/core/extensions/theme_data_extension.dart';
import 'package:leafory/shared/widgets/loading_indicator.dart';

class FullImageView extends StatelessWidget {
  const FullImageView({required this.imageUrl, super.key});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Hero(
              tag: imageUrl,
              child: RepaintBoundary(
                child: PhotoView(
                  minScale: PhotoViewComputedScale.contained,
                  maxScale: PhotoViewComputedScale.contained * 4,
                  imageProvider: CachedNetworkImageProvider(imageUrl),
                  loadingBuilder: (BuildContext context, ImageChunkEvent? event) => const LoadingIndicator(),
                ),
              ),
            ),
            Positioned(
              top: 16,
              right: 8,
              child: IconButton(
                onPressed: () => context.pop(),
                tooltip: 'Close',
                icon: Icon(Icons.close_rounded, size: 32, color: context.customColorTheme.primaryLight),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
