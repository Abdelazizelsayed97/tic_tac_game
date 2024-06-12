import 'package:flutter/material.dart';
import 'package:tic_toc_game/utils/helpers/app_daimentions.dart';

import '../colors/app_colors.dart';

class AppButton extends StatelessWidget {
  const AppButton(
      {super.key,
      required this.onTap,
      required this.child,
      required this.height, required this.color});

  final VoidCallback onTap;
  final Widget child;
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color,
          borderRadius: AppDimensions.radiusSmall(),
        ),
        padding: AppDimensions.large(),
        width: double.maxFinite,
        height: height,
        child: child,
      ),
    );
  }
}
