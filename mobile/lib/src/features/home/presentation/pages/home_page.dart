import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/controllers/navigation_controller.dart';
import '../../../../shared/widgets/safqa_bottom_navigation.dart';
import '../../../dashboard/presentation/pages/broker_home_page.dart';
import '../../../dashboard/presentation/pages/portfolio_page.dart';
import '../../../explore/presentation/pages/explore_page.dart';
import '../../../profile/presentation/pages/profile_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final navigationController = Get.find<NavigationController>();

    final pages = <Widget>[
      const ExplorePage(),
      const BrokerHomePage(),
      const PortfolioPage(),
      const ProfilePage(),
    ];

    return Scaffold(
      body: Obx(
        () => IndexedStack(
          index: navigationController.selectedIndex.value,
          children: pages,
        ),
      ),
      bottomNavigationBar: const SafqaBottomNavigation(),
    );
  }
}
