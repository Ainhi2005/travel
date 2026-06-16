import 'package:sesan_travel/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CircularBackButton extends StatelessWidget {
  final VoidCallback? onPressed;
  
  const CircularBackButton({
    super.key,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: AppColors.neutral,
      child: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColors.white),
        onPressed: onPressed ?? () => context.pop(),
      ),
    );
  }
}
