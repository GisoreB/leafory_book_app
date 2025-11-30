import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:leafory/core/constants/assets.dart';
import 'package:leafory/core/constants/strings.dart';
import 'package:leafory/core/extensions/theme_data_extension.dart';
import 'package:leafory/core/routing/routes.dart';
import 'package:leafory/shared/extensions/widget_gap_extension.dart';
import 'package:leafory/shared/widgets/custom_asset_image.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _navigateToHomePage();
  }

  void _navigateToHomePage() {
    Timer(const Duration(seconds: 2), () => context.pushReplacement(Routes.home));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.customColorTheme.primaryVariant,
      body: SafeArea(
        child: Center(
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              const CustomAssetImage(path: Assets.logoPathApp, width: 168, height: 168),
              8.gapHeight,
              Text(
                Strings.appName,
                textAlign: TextAlign.center,
                style: context.textTheme.displaySmall?.copyWith(
                  color: context.customColorTheme.lightBackground,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
