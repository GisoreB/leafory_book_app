import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:leafory/core/extensions/theme_data_extension.dart';
import 'package:leafory/core/styles/border_radiuses.dart';
import 'package:leafory/shared/widgets/main_tab_button.dart';

class MainShell extends StatelessWidget {
  const MainShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  void _onPressed({required int index}) {
    navigationShell.goBranch(index, initialLocation: index == navigationShell.currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            navigationShell,
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: 216,
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: context.customColorTheme.white,
                  borderRadius: BorderRadius.circular(BorderRadiuses.extraLarge),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    MainTabButton(
                      onPressed: () => _onPressed(index: 0),
                      isSelected: navigationShell.currentIndex == 0,
                      label: 'Home',
                      icon: Icons.home_rounded,
                    ),
                    MainTabButton(
                      onPressed: () => _onPressed(index: 1),
                      isSelected: navigationShell.currentIndex == 1,
                      label: 'Favorites',
                      icon: Icons.favorite_rounded,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
