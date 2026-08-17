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
      () => Container(
        height: 70,
        decoration: BoxDecoration(
          color: AppColors.paper,
          border: Border(
            top: BorderSide(color: AppColors.border, width: 0.8),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _NavBarItem(
              icon: Icons.home_outlined,
              activeIcon: Icons.home_rounded,
              label: isAr ? 'الرئيسية' : 'Home',
              isActive: navController.selectedIndex.value == 0,
              onTap: () => navController.changeIndex(0),
            ),
            _NavBarItem(
              icon: Icons.pie_chart_outline_rounded,
              activeIcon: Icons.pie_chart_rounded,
              label: isAr ? 'الأسهم' : 'Shares',
              isActive: navController.selectedIndex.value == 1,
              onTap: () => navController.changeIndex(1),
            ),
            _NavBarItem(
              icon: Icons.apartment_outlined,
              activeIcon: Icons.apartment_rounded,
              label: isAr ? 'العقارات' : 'Properties',
              isActive: navController.selectedIndex.value == 2,
              onTap: () => navController.changeIndex(2),
            ),
            _NavBarItem(
              icon: Icons.business_center_outlined,
              activeIcon: Icons.business_center_rounded,
              label: isAr ? 'المحفظة' : 'Portfolio',
              isActive: navController.selectedIndex.value == 3,
              onTap: () => navController.changeIndex(3),
            ),
            _NavBarItem(
              icon: Icons.more_horiz_outlined,
              activeIcon: Icons.more_horiz_rounded,
              label: isAr ? 'المزيد' : 'More',
              isActive: navController.selectedIndex.value == 4,
              onTap: () => navController.changeIndex(4),
            ),
          ],
        ),
      ),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isActive ? activeIcon : icon,
              color: isActive ? AppColors.gold : AppColors.muted,
              size: 22,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isActive ? AppColors.gold : AppColors.muted,
                fontSize: 9,
                fontWeight: isActive ? FontWeight.w800 : FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
