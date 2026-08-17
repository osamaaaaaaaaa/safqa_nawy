import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/controllers/locale_controller.dart';
import '../../../../core/controllers/navigation_controller.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/animated_tap.dart';
import '../../../../shared/widgets/broker_page.dart';
import '../../../../shared/widgets/fade_in_entrance.dart';
import '../../../transfer/presentation/pages/conversational_create_resale_page.dart';

class BrokerHomePage extends StatelessWidget {
  const BrokerHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final localeController = Get.find<LocaleController>();
    final navController = Get.find<NavigationController>();
    final isAr = Get.locale?.languageCode == 'ar';

    return BrokerPage(
      children: [
        // 1. Nawy-Style Top Navigation Bar (Logo, Map, Notification)
        FadeInEntrance(
          index: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    height: 36,
                    width: 36,
                    decoration: BoxDecoration(
                      color: AppColors.gold,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.real_estate_agent_rounded, color: Colors.white, size: 18),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'SAFQA',
                    style: TextStyle(
                      color: AppColors.ink,
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.map_outlined, color: AppColors.ink),
                    onPressed: () => navController.changeIndex(2), // Go to properties
                  ),
                  IconButton(
                    icon: const Icon(Icons.notifications_none_rounded, color: AppColors.ink),
                    onPressed: () {
                      Get.snackbar(
                        isAr ? 'التنبيهات' : 'Notifications',
                        isAr ? 'لا توجد تنبيهات جديدة حالياً.' : 'No new notifications.',
                      );
                    },
                  ),
                  IconButton(
                    icon: Text(
                      localeController.isArabic ? 'EN' : 'ع',
                      style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 11, color: AppColors.gold),
                    ),
                    onPressed: localeController.toggleLocale,
                  )
                ],
              )
            ],
          ),
        ),

        const SizedBox(height: 8),

        // 2. Welcome Title
        FadeInEntrance(
          index: 1,
          child: Text(
            isAr ? 'مرحباً بك!' : 'Hello There!',
            style: const TextStyle(
              color: AppColors.ink,
              fontWeight: FontWeight.w900,
              fontSize: 22,
              letterSpacing: -0.5,
            ),
          ),
        ),

        const SizedBox(height: 12),

        // 3. Rounded Search Bar
        FadeInEntrance(
          index: 2,
          child: TextField(
            readOnly: true,
            onTap: () => navController.changeIndex(2), // Switch to explore tab
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search_rounded, color: AppColors.muted),
              hintText: isAr ? 'المنطقة، المطور، الكمبوند' : 'Area, Developer, Compound',
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: AppColors.border, width: 1.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: AppColors.border, width: 1.0),
              ),
            ),
          ),
        ),

        const SizedBox(height: 16),

        // 4. 2x2 Grid of Luxury Service Cards (Matching Screenshot 1)
        FadeInEntrance(
          index: 3,
          child: GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.9,
            children: [
              _NawyGridCard(
                icon: Icons.apartment_rounded,
                iconColor: AppColors.gold,
                title: isAr ? 'عقارات صفقة' : 'Safqa Properties',
                desc: isAr ? 'استكشف مشاريع التنازل والريسيل الموثقة' : 'Explore developer & resale properties',
                onTap: () => navController.changeIndex(2), // Go to properties
              ),
              _NawyGridCard(
                icon: Icons.vpn_key_rounded,
                iconColor: Colors.orange,
                title: isAr ? 'صفقة الآن' : 'Safqa Now',
                desc: isAr ? 'احصل على عقار فوري وسدد حتى 7 سنوات' : 'Move Now, Pay up to 7 Years installments',
                onTap: () => navController.changeIndex(2),
              ),
              _NawyGridCard(
                icon: Icons.lock_open_rounded,
                iconColor: Colors.teal,
                title: isAr ? 'صفقة المفتوحة' : 'Safqa Unlocked',
                desc: isAr ? 'أدرج وحدتك وحوّلها لعقد كاش فوري' : 'Turn your idle unit into a steady income',
                onTap: () => Get.to(() => const ConversationalCreateResalePage()),
              ),
              _NawyGridCard(
                icon: Icons.pie_chart_rounded,
                iconColor: Colors.green,
                title: isAr ? 'أسهم صفقة' : 'Safqa Shares',
                desc: isAr ? 'استثمار عقاري مجزأ يبدأ من 5 آلاف شهرياً' : 'Fractional investment with as little as EGP 5k monthly',
                onTap: () => navController.changeIndex(1), // Go to shares
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // 5. Nawy-Style Campaign/Promo Banner (Bottom)
        FadeInEntrance(
          index: 4,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.gold.withValues(alpha: 0.8), AppColors.gold],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isAr ? 'عقارات صفقة المميزة' : 'SAFQA KEYS',
                        style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 10),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isAr ? 'ابحث عن منزل أحلامك للتنازل' : 'RENT YOUR DREAM HOME',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 14),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        isAr ? 'تصفح وقارن واغلق الصفقة في 9 أيام' : 'Explore, rent & move in right away!',
                        style: const TextStyle(color: Colors.white70, fontSize: 10),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Text(
                            isAr ? 'استكشف المزيد' : 'Explore More',
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 12),
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  height: 64,
                  width: 64,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.key_rounded, color: Colors.white, size: 30),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _NawyGridCard extends StatelessWidget {
  const _NawyGridCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.desc,
    required this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String desc;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedTap(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.paper,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: iconColor, size: 24),
                const Icon(Icons.arrow_forward_ios_rounded, color: AppColors.muted, size: 14),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.ink,
                    fontWeight: FontWeight.w900,
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  desc,
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontSize: 9,
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
