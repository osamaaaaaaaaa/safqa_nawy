import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/controllers/locale_controller.dart';
import '../../../../core/controllers/navigation_controller.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/animated_tap.dart';
import '../../../../shared/widgets/broker_page.dart';
import '../../../../shared/widgets/broker_section_header.dart';
import '../../../../shared/widgets/status_pill.dart';
import '../../../deals/data/repositories/deals_repository.dart';
import '../../../deals/presentation/pages/deals_page.dart';
import '../../../explore/data/repositories/projects_repository.dart';
import '../../../explore/data/repositories/resale_repository.dart';
import '../../../explore/domain/entities/resale_unit.dart';
import '../../../explore/presentation/pages/resale_details_page.dart';
import '../../../leads/data/repositories/leads_repository.dart';
import '../../../leads/presentation/pages/leads_page.dart';
import '../../../transfer/presentation/pages/create_resale_page.dart';
import '../../../wallet/data/repositories/wallet_repository.dart';
import '../../../wallet/presentation/pages/wallet_page.dart';
import '../../../profile/presentation/pages/safqa_comparison_page.dart';

class BrokerHomePage extends StatelessWidget {
  const BrokerHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final localeController = Get.find<LocaleController>();
    final leads = const LeadsRepository().activeLeads();
    final deals = const DealsRepository().activeDeals();
    final wallet = const WalletRepository();
    final resaleUnits = const ResaleRepository().featuredResaleUnits();
    final isAr = Get.locale?.languageCode == 'ar';

    return BrokerPage(
      children: [
        // 1. Custom Greetings Header
        _TopBar(localeController: localeController),
        const SizedBox(height: AppSpacing.xs),

        // 2. Visa Wallet Card Hero (UX change: Wallet is integrated into the dashboard)
        _WalletHeroPanel(wallet: wallet, isAr: isAr),

        // 3. Horizontal Swiper for CRM & Pipelines (UX change: Horizontal swiper for modules instead of list stack)
        BrokerSectionHeader(title: isAr ? 'لوحة التحكم والعمليات' : 'Workspace Hub'),
        _HorizontalModuleSwiper(
          leadsCount: leads.length,
          dealsCount: deals.length,
          isAr: isAr,
        ),

        // 4. Quick Actions Grid
        Row(
          children: [
            Expanded(
              child: _QuickActionCard(
                label: isAr ? 'إدراج وحدة للبيع' : 'List Unit for Sale',
                subtitle: isAr ? 'أضف فرصة تنازل جديدة' : 'Add resale transfer',
                icon: Icons.add_circle_rounded,
                color: AppColors.gold,
                onTap: () => Get.to(() => const CreateResalePage()),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: _QuickActionCard(
                label: isAr ? 'مزايا ومقارنة صفقة' : 'Why Safqa?',
                subtitle: isAr ? 'دليل صفقة vs التقليدي' : 'Safqa vs Traditional',
                icon: Icons.bar_chart_rounded,
                color: AppColors.emerald,
                onTap: () => Get.to(() => const SafqaComparisonPage()),
              ),
            ),
          ],
        ),

        // 5. Horizontal Featured Resale catalog (UX change: Horizontal list cards for properties)
        AnimatedTap(
          onTap: () {
            final navController = Get.find<NavigationController>();
            navController.changeIndex(1); // Switch to marketplace explore page
          },
          child: BrokerSectionHeader(
            title: isAr ? 'أحدث فرص التنازل الساخنة 💎' : 'Hot Resale Deals 💎',
            action: isAr ? 'عرض الكل' : 'View All',
          ),
        ),
        _HorizontalFeaturedResales(resaleUnits: resaleUnits, isAr: isAr),
        const SizedBox(height: 20),
      ],
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.localeController});

  final LocaleController localeController;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Row(
        children: [
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.ink, Color(0xFF1E293B)],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withValues(alpha: 0.1), width: 1.5),
            ),
            child: const Icon(
              Icons.real_estate_agent_rounded,
              color: AppColors.gold,
              size: 24,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'home.greeting'.tr,
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'home.broker_name'.tr,
                  style: const TextStyle(
                    color: AppColors.ink,
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
          IconButton.filledTonal(
            style: IconButton.styleFrom(
              backgroundColor: AppColors.gold.withValues(alpha: 0.1),
              foregroundColor: AppColors.gold,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: localeController.toggleLocale,
            icon: Text(
              localeController.isArabic ? 'EN' : 'ع',
              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

class _WalletHeroPanel extends StatelessWidget {
  const _WalletHeroPanel({required this.wallet, required this.isAr});

  final WalletRepository wallet;
  final bool isAr;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.ink, Color(0xFF1E293B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.ink.withValues(alpha: .2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isAr ? 'الرصيد المتاح للسحب' : 'Available Payout Balance',
                  style: const TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text(
                  wallet.availableBalance,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
          AnimatedTap(
            onTap: () => Get.to(() => const WalletPage()),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.gold,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Text(
                    isAr ? 'المحفظة' : 'Wallet',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  const SizedBox(width: 6),
                  const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 14),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _HorizontalModuleSwiper extends StatelessWidget {
  const _HorizontalModuleSwiper({
    required this.leadsCount,
    required this.dealsCount,
    required this.isAr,
  });

  final int leadsCount;
  final int dealsCount;
  final bool isAr;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 125,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _ModuleCard(
            title: isAr ? 'العملاء النشطين 👥' : 'Active Leads 👥',
            desc: isAr ? 'تتبع حماية العملاء وتواريخ انتهاء الصلاحية' : 'Manage protected lead registries',
            count: '$leadsCount',
            color: AppColors.gold,
            onTap: () => Get.to(() => const LeadsPage()),
          ),
          const SizedBox(width: 12),
          _ModuleCard(
            title: isAr ? 'عقود الإغلاق الجارية 🤝' : 'Closing Pipeline 🤝',
            desc: isAr ? 'تتبع مراحل الصفقات وموافقة المطورين' : 'Track ongoing transfer escrow stages',
            count: '$dealsCount',
            color: AppColors.emerald,
            onTap: () => Get.to(() => const DealsPage()),
          ),
        ],
      ),
    );
  }
}

class _ModuleCard extends StatelessWidget {
  const _ModuleCard({
    required this.title,
    required this.desc,
    required this.count,
    required this.color,
    required this.onTap,
  });

  final String title;
  final String desc;
  final String count;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedTap(
      onTap: onTap,
      child: Container(
        width: 250,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.paper,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 8,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: AppColors.ink),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    desc,
                    style: const TextStyle(color: AppColors.muted, fontSize: 10, height: 1.3),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  )
                ],
              ),
            ),
            const SizedBox(width: 10),
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                count,
                style: TextStyle(color: color, fontWeight: FontWeight.w900, fontSize: 16),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  const _QuickActionCard({
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String label;
  final String subtitle;
  final IconData icon;
  final Color color;
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
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      color: AppColors.ink,
                      fontWeight: FontWeight.w900,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(color: AppColors.muted, fontSize: 9),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HorizontalFeaturedResales extends StatelessWidget {
  const _HorizontalFeaturedResales({required this.resaleUnits, required this.isAr});

  final List<ResaleUnit> resaleUnits;
  final bool isAr;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 170,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: resaleUnits.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final unit = resaleUnits[index];
          return AnimatedTap(
            onTap: () => Get.to(() => ResaleDetailsPage(unit: unit)),
            child: Container(
              width: 280,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.paper,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      StatusPill(label: unit.unitCode, color: AppColors.gold),
                      Text(
                        unit.commission,
                        style: const TextStyle(color: AppColors.emerald, fontWeight: FontWeight.bold, fontSize: 11),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    unit.title,
                    style: const TextStyle(color: AppColors.ink, fontWeight: FontWeight.w900, fontSize: 13),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '${unit.projectName} • ${unit.developer}',
                    style: const TextStyle(color: AppColors.muted, fontSize: 11),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Divider(height: 1),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isAr ? 'المطلوب كاش' : 'Cash Required',
                            style: const TextStyle(color: AppColors.muted, fontSize: 9),
                          ),
                          Text(
                            unit.cashRequired,
                            style: const TextStyle(color: AppColors.gold, fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            isAr ? 'الوفر الفوري' : 'Savings',
                            style: const TextStyle(color: AppColors.muted, fontSize: 9),
                          ),
                          Text(
                            unit.marketSavings,
                            style: const TextStyle(color: AppColors.emerald, fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
