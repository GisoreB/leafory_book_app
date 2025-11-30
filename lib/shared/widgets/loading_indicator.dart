import 'package:flutter/material.dart';
import 'package:leafory/core/extensions/theme_data_extension.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key}) : useSliver = false, padding = null;

  const LoadingIndicator.withPadding({required this.padding, super.key}) : useSliver = false;

  const LoadingIndicator.sliver({super.key}) : useSliver = true, padding = null;

  const LoadingIndicator.sliverWithPadding({required this.padding, super.key}) : useSliver = true;

  final bool useSliver;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    final EdgeInsets? padding = this.padding;

    final Widget loadingIndicator = Center(
      child: RepaintBoundary(
        child: CircularProgressIndicator(color: context.customColorTheme.primary, padding: padding ?? EdgeInsets.zero),
      ),
    );

    return switch (useSliver) {
      false => loadingIndicator,
      true => SliverFillRemaining(hasScrollBody: false, child: loadingIndicator),
    };
  }
}
