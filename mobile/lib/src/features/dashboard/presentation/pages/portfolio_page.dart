import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/controllers/settings_controller.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/animated_tap.dart';
import '../../../../shared/widgets/broker_page.dart';
import '../../../../shared/widgets/broker_section_header.dart';
import '../../../../shared/widgets/status_pill.dart';
import '../../../deals/data/repositories/deals_repository.dart';
import '../../../deals/presentation/pages/deals_page.dart';
import '../../../leads/data/repositories/leads_repository.dart';
import '../../../leads/presentation/pages/leads_page.dart';
import '../../../wallet/data/repositories/wallet_repository.dart';
import '../../../wallet/presentation/pages/wallet_page.dart';

class PortfolioPage extends StatelessWidget {
  const PortfolioPage({super.key});

  @override
  Widget build(BuildContext context) {
    final leads = const LeadsRepository().activeLeads();
    final deals = const DealsRepository().activeDeals();
    final wallet = const WalletRepository();
    final settingsController = Get.find<SettingsController>();
    final isAr = Get.locale?.languageCode == 'ar';

    return BrokerPage(
      children: [
        // Title
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isAr ? 'محفظة أعمالي كبروكر' : 'My Escrow Portfolio',
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w900,
                    letterSpacing: -1,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              isAr
                  ? 'متابعة المحفظة المالية والصفقات الجارية والعملاء'
                  : 'Track your wallet balance, escrow deals, and active leads',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),

        const SizedBox(height: AppSpacing.sm),

        // Wallet Card
        Obx(
          () => Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.ink,
              borderRadius: BorderRadius.circular(28),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isAr ? 'المحفظة والأرباح' : 'Available Payouts',
                      style: const TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                    const Icon(Icons.account_balance_wallet_rounded, color: AppColors.gold, size: 20),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  settingsController.clientMode.value ? '***' : wallet.availableBalance,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 24),
                ),
                const SizedBox(height: 16),
                AnimatedTap(
                  onTap: () => Get.to(() => const WalletPage()),
                  child: Container(
                    height: 44,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.gold,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      isAr ? 'تفاصيل السحب والعمليات المالية' : 'Withdraw & Transaction History',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),

        const SizedBox(height: AppSpacing.md),

        // Active Leads Row Header
        BrokerSectionHeader(
          title: isAr ? 'العملاء النشطين' : 'Active CRM Leads',
          action: isAr ? 'عرض الكل' : 'View All',
        ),
        
        ...leads.take(2).map((lead) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.paper,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.gold.withValues(alpha: 0.08),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.person_rounded, color: AppColors.gold, size: 18),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          lead.name,
                          style: const TextStyle(color: AppColors.ink, fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                        Text(
                          lead.project,
                          style: const TextStyle(color: AppColors.muted, fontSize: 11),
                        ),
                      ],
                    ),
                  ],
                ),
                StatusPill(
                  label: lead.status.name,
                  color: AppColors.emerald,
                )
              ],
            ),
          );
        }),

        AnimatedTap(
          onTap: () => Get.to(() => const LeadsPage()),
          child: Container(
            height: 46,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(16),
            ),
            alignment: Alignment.center,
            child: Text(
              isAr ? 'فتح قائمة العملاء كاملة' : 'Open Full CRM Leads List',
              style: const TextStyle(color: AppColors.ink, fontWeight: FontWeight.bold, fontSize: 11),
            ),
          ),
        ),

        const SizedBox(height: AppSpacing.md),

        // Escrow Deals Row Header
        BrokerSectionHeader(
          title: isAr ? 'عقود التنازل والصفقات الجارية' : 'Escrow Deal Pipelines',
        ),

        ...deals.take(2).map((deal) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.paper,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.emerald.withValues(alpha: 0.08),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.swap_horiz_rounded, color: AppColors.emerald, size: 18),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          deal.unit,
                          style: const TextStyle(color: AppColors.ink, fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                        Text(
                          deal.buyer,
                          style: const TextStyle(color: AppColors.muted, fontSize: 11),
                        ),
                      ],
                    ),
                  ],
                ),
                StatusPill(
                  label: deal.stage.name,
                  color: AppColors.gold,
                )
              ],
            ),
          );
        }),

        AnimatedTap(
          onTap: () => Get.to(() => const DealsPage()),
          child: Container(
            height: 46,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(16),
            ),
            alignment: Alignment.center,
            child: Text(
              isAr ? 'فتح لوحة متابعة الصفقات' : 'Open Deal Pipelines Tracking',
              style: const TextStyle(color: AppColors.ink, fontWeight: FontWeight.bold, fontSize: 11),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
