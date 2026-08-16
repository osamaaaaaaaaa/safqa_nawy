import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/controllers/locale_controller.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/animated_tap.dart';
import '../../../../shared/widgets/broker_page.dart';
import '../../../../shared/widgets/broker_section_header.dart';
import '../../../../shared/widgets/status_pill.dart';
import '../../../deals/data/repositories/deals_repository.dart';
import '../../../deals/presentation/pages/deals_page.dart';
import '../../../explore/data/repositories/resale_repository.dart';
import '../../../explore/domain/entities/resale_unit.dart';
import '../../../explore/presentation/pages/resale_details_page.dart';
import '../../../leads/data/repositories/leads_repository.dart';
import '../../../leads/presentation/pages/leads_page.dart';
import '../../../transfer/presentation/pages/create_resale_page.dart';
import '../../../wallet/data/repositories/wallet_repository.dart';
import '../../../wallet/presentation/pages/wallet_page.dart';

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
        // 1. Landing Page Navbar
        _LandingNavbar(localeController: localeController),
        const SizedBox(height: AppSpacing.sm),

        // 2. Main Hero Section (Landing Page Vibe)
        _HeroLandingSection(isAr: isAr),
        const SizedBox(height: AppSpacing.md),

        // 3. Platform Stats Strip (Landing Page Vibe)
        _PlatformStatsStrip(isAr: isAr),
        const SizedBox(height: AppSpacing.md),

        // 4. "عايز تبيع؟" Wizard Selling CTA Banner
        _SellWizardBanner(isAr: isAr),
        const SizedBox(height: AppSpacing.md),

        // 5. Featured Resale Opportunities Catalog
        BrokerSectionHeader(
          title: isAr ? 'فرص التنازل المتاحة حالياً 💎' : 'Available Resale Opportunities 💎',
        ),
        _ResaleCatalogGrid(resaleUnits: resaleUnits, isAr: isAr),
        const SizedBox(height: AppSpacing.md),

        // 6. Interactive Traditional vs Safqa Comparison Section
        BrokerSectionHeader(
          title: isAr ? 'لماذا منصة صفقة؟' : 'Why Safqa Resale?',
        ),
        _ComparisonPanel(isAr: isAr),
        const SizedBox(height: AppSpacing.md),

        // 7. Broker Workspace Quick Overview
        BrokerSectionHeader(
          title: isAr ? 'لوحة أعمالي كبروكر معتمد 💼' : 'My Certified Workspace 💼',
        ),
        _WorkspaceOverviewCard(
          leadsCount: leads.length,
          dealsCount: deals.length,
          balance: wallet.availableBalance,
          isAr: isAr,
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}

class _LandingNavbar extends StatelessWidget {
  const _LandingNavbar({required this.localeController});

  final LocaleController localeController;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: AppColors.ink,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.real_estate_agent_rounded, color: AppColors.gold, size: 20),
              ),
              const SizedBox(width: 8),
              const Text(
                'SAFQA',
                style: TextStyle(
                  color: AppColors.ink,
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
          IconButton.filledTonal(
            style: IconButton.styleFrom(
              backgroundColor: AppColors.gold.withValues(alpha: 0.1),
              foregroundColor: AppColors.gold,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: localeController.toggleLocale,
            icon: Text(
              localeController.isArabic ? 'EN' : 'ع',
              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroLandingSection extends StatelessWidget {
  const _HeroLandingSection({required this.isAr});

  final bool isAr;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.paper,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const StatusPill(label: 'عقود تنازل موثقة 🛡️', color: AppColors.emerald),
          const SizedBox(height: 12),
          Text(
            isAr
                ? 'بيع وتنازل عن وحدتك العقارية بأسرع وقت وأمان كامل'
                : 'Sell & Transfer Your Property Scans Safely & Instantly',
            style: const TextStyle(
              color: AppColors.ink,
              fontSize: 22,
              fontWeight: FontWeight.w900,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isAr
                ? 'نطابق البائع بالمشتري فوراً، ونتحقق من كافة المستندات والوصولات قانونياً، وننهي إجراءات المطور في 9 أيام فقط.'
                : 'We match buyers and sellers, verify documents legally, and close developer approvals in 9 days.',
            style: const TextStyle(color: AppColors.muted, fontSize: 12, height: 1.5),
          ),
        ],
      ),
    );
  }
}

class _PlatformStatsStrip extends StatelessWidget {
  const _PlatformStatsStrip({required this.isAr});

  final bool isAr;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatPillCard(
            value: isAr ? '9 أيام' : '9 Days',
            label: isAr ? 'متوسط الإغلاق' : 'Avg Close',
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _StatPillCard(
            value: '100%',
            label: isAr ? 'أوراق موثقة' : 'Verified Docs',
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _StatPillCard(
            value: '0%',
            label: isAr ? 'عمولة مشتري' : 'Buyer Fees',
          ),
        ),
      ],
    );
  }
}

class _StatPillCard extends StatelessWidget {
  const _StatPillCard({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.paper,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(color: AppColors.gold, fontWeight: FontWeight.w900, fontSize: 14),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(color: AppColors.muted, fontSize: 9, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _SellWizardBanner extends StatelessWidget {
  const _SellWizardBanner({required this.isAr});

  final bool isAr;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.ink, Color(0xFF1E293B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.gold.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.sell_rounded, color: AppColors.gold, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  isAr ? 'عايز تبيع وتتنازل عن وحدتك؟' : 'Want to Sell Your Unit?',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 14),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            isAr
                ? 'أدرج تفاصيل عقارك والمبالغ المدفوعة، وارفع صورة العقد للتوثيق القانوني فوراً لعرضها على المشترين المستعدين بالكاش.'
                : 'List your property specs, remaining installments, and upload contract scan for instant buyer matching.',
            style: const TextStyle(color: Colors.white70, fontSize: 11, height: 1.5),
          ),
          const SizedBox(height: 16),
          AnimatedTap(
            onTap: () => Get.to(() => const CreateResalePage()),
            child: Container(
              height: 46,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.gold,
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Text(
                isAr ? 'ابدأ إدراج وحدتك الآن 🚀' : 'Start Resale Listing 🚀',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _ResaleCatalogGrid extends StatelessWidget {
  const _ResaleCatalogGrid({required this.resaleUnits, required this.isAr});

  final List<ResaleUnit> resaleUnits;
  final bool isAr;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.76,
      ),
      itemCount: resaleUnits.length,
      itemBuilder: (context, index) {
        final unit = resaleUnits[index];
        return AnimatedTap(
          onTap: () => Get.to(() => ResaleDetailsPage(unit: unit)),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.paper,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 4,
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(colors: [AppColors.ink, Color(0xFF1E293B)]),
                      borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            StatusPill(label: unit.unitCode, color: AppColors.gold),
                            const Icon(Icons.verified_user_rounded, color: AppColors.emerald, size: 14),
                          ],
                        ),
                        Text(
                          unit.projectName,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          unit.title,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: AppColors.ink),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Row(
                          children: [
                            const Icon(Icons.hotel_rounded, color: AppColors.gold, size: 11),
                            const SizedBox(width: 3),
                            Text('${unit.bedrooms}', style: const TextStyle(fontSize: 9, color: AppColors.muted)),
                            const SizedBox(width: 6),
                            const Icon(Icons.square_foot_rounded, color: AppColors.gold, size: 11),
                            const SizedBox(width: 3),
                            Text('${unit.area.toInt()}m²', style: const TextStyle(fontSize: 9, color: AppColors.muted)),
                          ],
                        ),
                        const Divider(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(isAr ? 'المطلوب كاش' : 'Cash Required', style: const TextStyle(color: AppColors.muted, fontSize: 7)),
                                Text(unit.cashRequired.split(' ').first, style: const TextStyle(color: AppColors.gold, fontWeight: FontWeight.bold, fontSize: 10)),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(isAr ? 'الوفر' : 'Savings', style: const TextStyle(color: AppColors.muted, fontSize: 7)),
                                Text(unit.marketSavings.split(' ').first, style: const TextStyle(color: AppColors.emerald, fontWeight: FontWeight.bold, fontSize: 10)),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ComparisonPanel extends StatelessWidget {
  const _ComparisonPanel({required this.isAr});

  final bool isAr;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _ComparisonRow(
              title: isAr ? 'أمان المستندات' : 'Doc Verification',
              trad: isAr ? 'مخاطرة عالية' : 'Risky / slow',
              safqa: isAr ? 'مراجعة قانونية 🛡️' : 'Legally Audited 🛡️',
            ),
            const Divider(height: 16),
            _ComparisonRow(
              title: isAr ? 'سرعة التنازل' : 'Escrow Speed',
              trad: isAr ? 'أشهر طويلة' : 'Months',
              safqa: isAr ? '9 أيام فقط ⚡' : 'Only 9 Days ⚡',
            ),
            const Divider(height: 16),
            _ComparisonRow(
              title: isAr ? 'العمولات' : 'Commission',
              trad: isAr ? 'مزدوجة ومخفية' : 'Hidden / high',
              safqa: isAr ? 'منخفضة ومحددة 💸' : 'Low & clear 💸',
            ),
          ],
        ),
      ),
    );
  }
}

class _ComparisonRow extends StatelessWidget {
  const _ComparisonRow({required this.title, required this.trad, required this.safqa});

  final String title;
  final String trad;
  final String safqa;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: AppColors.ink)),
        ),
        Expanded(
          flex: 3,
          child: Text(trad, style: const TextStyle(color: AppColors.muted, fontSize: 10)),
        ),
        Expanded(
          flex: 4,
          child: Text(safqa, style: const TextStyle(color: AppColors.emerald, fontWeight: FontWeight.w900, fontSize: 11)),
        ),
      ],
    );
  }
}

class _WorkspaceOverviewCard extends StatelessWidget {
  const _WorkspaceOverviewCard({
    required this.leadsCount,
    required this.dealsCount,
    required this.balance,
    required this.isAr,
  });

  final int leadsCount;
  final int dealsCount;
  final String balance;
  final bool isAr;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.paper,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _OverviewItem(
                label: isAr ? 'العملاء النشطين' : 'Active Leads',
                value: '$leadsCount',
                onTap: () => Get.to(() => const LeadsPage()),
              ),
              Container(height: 30, width: 1, color: AppColors.border),
              _OverviewItem(
                label: isAr ? 'العقود والصفقات' : ' escrow Deals',
                value: '$dealsCount',
                onTap: () => Get.to(() => const DealsPage()),
              ),
              Container(height: 30, width: 1, color: AppColors.border),
              _OverviewItem(
                label: isAr ? 'المحفظة والأرباح' : 'Wallet Balance',
                value: balance.split(' ').first,
                onTap: () => Get.to(() => const WalletPage()),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.verified_user_rounded, color: AppColors.gold, size: 16),
              const SizedBox(width: 6),
              Text(
                isAr ? 'أنت وسيط معتمد ومرخص لدى منصة صفقة 🛡️' : 'You are a certified Safqa escrow broker 🛡️',
                style: const TextStyle(color: AppColors.gold, fontSize: 10, fontWeight: FontWeight.bold),
              )
            ],
          )
        ],
      ),
    );
  }
}

class _OverviewItem extends StatelessWidget {
  const _OverviewItem({required this.label, required this.value, required this.onTap});

  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(color: AppColors.ink, fontWeight: FontWeight.w900, fontSize: 16),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(color: AppColors.muted, fontSize: 9, fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}
