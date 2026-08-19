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
    final isAr = Get.locale?.languageCode == 'ar';

    return Obx(
      () {
        final selectedIndex = navController.selectedIndex.value;
        return SafeArea(
          bottom: true,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 18),
            child: Container(
              height: 62,
              decoration: BoxDecoration(
                color: AppColors.ink,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.16),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                children: [
                  _NavBarItem(
                    icon: Icons.explore_rounded,
                    activeIcon: Icons.explore_rounded,
                    label: isAr ? 'استكشف' : 'Explore',
                    isActive: selectedIndex == 0,
                    onTap: () => navController.changeIndex(0),
                  ),
                  _NavBarItem(
                    icon: Icons.home_rounded,
                    activeIcon: Icons.home_rounded,
                    label: isAr ? 'الرئيسية' : 'Home',
                    isActive: selectedIndex == 1,
                    onTap: () => navController.changeIndex(1),
                  ),
                  _NavBarItem(
                    icon: Icons.handshake_rounded,
                    activeIcon: Icons.handshake_rounded,
                    label: isAr ? 'صفقاتي' : 'My Deals',
                    isActive: selectedIndex == 2,
                    onTap: () => navController.changeIndex(2),
                  ),
                  _NavBarItem(
                    icon: Icons.settings_rounded,
                    activeIcon: Icons.settings_rounded,
                    label: isAr ? 'الإعدادات' : 'Settings',
                    isActive: selectedIndex == 3,
                    onTap: () => navController.changeIndex(3),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _NavBarItem extends StatelessWidget {
  const _NavBarItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AnimatedTap(
        onTap: onTap,
        scaleDownTo: 0.92,
        child: Container(
          color: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon with smooth scale-up & backdrop indicator if active
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isActive ? Colors.white.withValues(alpha: 0.12) : Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isActive ? activeIcon : icon,
                  color: isActive ? Colors.white : Colors.white38,
                  size: 22,
                ),
              ),
              const SizedBox(height: 2),
              // Animated line indicator under active icon
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 3,
                width: isActive ? 16 : 0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
