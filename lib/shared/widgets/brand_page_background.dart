import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

class BrandPageBackground extends StatelessWidget {
  const BrandPageBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(color: AppColors.cream, child: child);
  }
}
