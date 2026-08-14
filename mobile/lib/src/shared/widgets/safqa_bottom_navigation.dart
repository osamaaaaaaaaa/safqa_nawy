import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/app_colors.dart';

class SafqaBottomNavigation extends StatelessWidget {
  const SafqaBottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      height: 70,
      backgroundColor: AppColors.paper,
      indicatorColor: AppColors.emerald.withValues(alpha: .12),
      selectedIndex: 0,
      destinations: [
        NavigationDestination(
          icon: const Icon(Icons.home_rounded),
          label: 'nav.home'.tr,
        ),
        NavigationDestination(
          icon: const Icon(Icons.apartment_rounded),
          label: 'nav.deals'.tr,
        ),
        NavigationDestination(
          icon: const Icon(Icons.add_circle_rounded),
          label: 'nav.add'.tr,
        ),
        NavigationDestination(
          icon: const Icon(Icons.person_rounded),
          label: 'nav.profile'.tr,
        ),
      ],
    );
  }
}
