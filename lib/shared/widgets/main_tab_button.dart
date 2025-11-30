import 'package:flutter/material.dart';
import 'package:leafory/core/extensions/theme_data_extension.dart';
import 'package:leafory/core/styles/border_radiuses.dart';

class MainTabButton extends StatelessWidget {
  const MainTabButton({
    required this.onPressed,
    required this.isSelected,
    required this.label,
    required this.icon,
    super.key,
  });

  final VoidCallback onPressed;
  final bool isSelected;
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return isSelected
        ? SizedBox(
            height: 40,
            child: ElevatedButton.icon(
              onPressed: onPressed,
              icon: Icon(icon, size: 24, color: context.customColorTheme.white),
              label: Text(
                label,
                style: context.textTheme.labelLarge?.copyWith(
                  color: context.customColorTheme.white,
                  fontWeight: FontWeight.w900,
                ),
              ),
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: context.customColorTheme.primary,
                shadowColor: context.customColorTheme.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(BorderRadiuses.medium)),
              ),
            ),
          )
        : IconButton(
            onPressed: onPressed,
            icon: Icon(icon, size: 24, color: context.customColorTheme.neutralInactive),
          );
  }
}
