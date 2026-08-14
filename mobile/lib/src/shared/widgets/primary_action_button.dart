import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class PrimaryActionButton extends StatelessWidget {
  const PrimaryActionButton({
    required this.label,
    required this.onPressed,
    this.isOutlined = false,
    super.key,
  });

  final String label;
  final VoidCallback onPressed;
  final bool isOutlined;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: isOutlined ? AppColors.paper : AppColors.ink,
        foregroundColor: isOutlined ? AppColors.ink : AppColors.paper,
        side: isOutlined ? const BorderSide(color: AppColors.border) : null,
        minimumSize: const Size(0, 52),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
      child: Text(label),
    );
  }
}
