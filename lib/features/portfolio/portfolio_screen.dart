import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

class PortfolioScreen extends StatelessWidget {
  const PortfolioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.cream,
      body: Center(child: Text('PORTFOLIO')),
    );
  }
}
