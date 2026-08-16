import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/controllers/navigation_controller.dart';
import '../../core/theme/app_colors.dart';
import 'animated_tap.dart';

class SafqaBottomNavigation extends StatelessWidget {
  const SafqaBottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    final navController = Get.find<NavigationController>();

    return Obx(
      () => Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: Container(
          height: 68,
          decoration: BoxDecoration(
            color: AppColors.paper.withValues(alpha: 0.92),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _NavBarItem(
                icon: Icons.grid_view_rounded,
                isActive: navController.selectedIndex.value == 0,
                onTap: () => navController.changeIndex(0),
              ),
              _NavBarItem(
                icon: Icons.explore_rounded,
                isActive: navController.selectedIndex.value == 1,
                onTap: () => navController.changeIndex(1),
              ),
              _NavBarItem(
                icon: Icons.fingerprint_rounded,
                isActive: navController.selectedIndex.value == 2,
                onTap: () => navController.changeIndex(2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  const _NavBarItem({
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedTap(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isActive ? AppColors.gold.withValues(alpha: 0.1) : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              icon,
              color: isActive ? AppColors.gold : AppColors.muted,
              size: 24,
            ),
          ),
          const SizedBox(height: 4),
          // Active dot indicator
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 4,
            width: isActive ? 12 : 0,
            decoration: BoxDecoration(
              color: AppColors.gold,
              borderRadius: BorderRadius.circular(2),
            ),
          )
        ],
      ),
    );
  }
}
