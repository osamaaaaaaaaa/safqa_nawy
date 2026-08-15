import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/controllers/navigation_controller.dart';
import '../../core/theme/app_colors.dart';

class SafqaBottomNavigation extends StatelessWidget {
  const SafqaBottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    final navController = Get.find<NavigationController>();

    return Obx(
      () => NavigationBar(
        height: 74,
        backgroundColor: AppColors.paper,
        indicatorColor: AppColors.gold.withValues(alpha: .12),
        selectedIndex: navController.selectedIndex.value,
        onDestinationSelected: navController.changeIndex,
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_rounded),
            label: 'nav.home'.tr,
          ),
          NavigationDestination(
            icon: const Icon(Icons.travel_explore_rounded),
            label: 'nav.explore'.tr,
          ),
          NavigationDestination(
            icon: const Icon(Icons.people_alt_rounded),
            label: 'nav.leads'.tr,
          ),
          NavigationDestination(
            icon: const Icon(Icons.handshake_rounded),
            label: 'nav.deals'.tr,
          ),
          NavigationDestination(
            icon: const Icon(Icons.account_balance_wallet_rounded),
            label: 'nav.wallet'.tr,
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_rounded),
            label: 'nav.profile'.tr,
          ),
        ],
      ),
    );
  }
}
