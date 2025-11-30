import 'package:flutter/material.dart';

class CustomAssetImage extends StatelessWidget {
  const CustomAssetImage({required this.path, this.width, this.height, this.color, super.key});

  final String path;
  final double? width, height;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Image.asset(path, width: width, height: height, color: color),
    );
  }
}
