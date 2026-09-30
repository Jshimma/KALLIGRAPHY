import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

class BookingScreen extends StatelessWidget {
  const BookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.cream,
      body: Center(child: Text('BOOK A SESSION')),
    );
  }
}
