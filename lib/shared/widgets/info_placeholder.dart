import 'package:flutter/material.dart';
import 'package:leafory/core/extensions/theme_data_extension.dart';
import 'package:leafory/shared/extensions/widget_gap_extension.dart';

class InfoPlaceholder extends StatelessWidget {
  const InfoPlaceholder({required this.message, required this.color, super.key, this.icon});

  final String message;
  final Color color;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (icon != null) Icon(icon, size: 40, color: color),
            if (icon != null) 16.gapHeight,
            Text(
              message,
              textAlign: TextAlign.center,
              style: context.textTheme.titleMedium?.copyWith(color: color, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
