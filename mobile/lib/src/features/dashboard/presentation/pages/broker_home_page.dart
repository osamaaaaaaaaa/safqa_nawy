import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/controllers/locale_controller.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/animated_tap.dart';
import '../../../../shared/widgets/animated_ticker.dart';
import '../../../../shared/widgets/broker_page.dart';
import '../../../../shared/widgets/broker_section_header.dart';
import '../../../../shared/widgets/fade_in_entrance.dart';
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

class BrokerHomePage extends StatefulWidget {
  const BrokerHomePage({super.key});

  @override
  State<BrokerHomePage> createState() => _BrokerHomePageState();
}

class _BrokerHomePageState extends State<BrokerHomePage> {
  double maxCashFilter = 5.0; // In Millions EGP

  @override
  Widget build(BuildContext context) {
    final localeController = Get.find<LocaleController>();
    final leads = const LeadsRepository().activeLeads();
    final deals = const DealsRepository().activeDeals();
    final wallet = const WalletRepository();
    final resaleUnits = const ResaleRepository().featuredResaleUnits();
    final isAr = Get.locale?.languageCode == 'ar';

    // Filter units based on the interactive cash budget slider
    final filteredUnits = resaleUnits.where((unit) {
      // Parse numeric cash required from string (e.g. "EGP 2.4M" -> 2.4)
      final cleanVal = unit.cashRequired
          .replaceAll('EGP', '')
          .replaceAll('ج.م', '')
          .replaceAll('M', '')
          .replaceAll('مليون', '')
          .trim();
      final numericCash = double.tryParse(cleanVal) ?? 0.0;
      return numericCash <= maxCashFilter;
    }).toList();

    return BrokerPage(
      children: [
        // 1. Landing Page Navbar
        FadeInEntrance(
          index: 0,
          child: _LandingNavbar(localeController: localeController),
        ),
        const SizedBox(height: AppSpacing.sm),

        // 2. Blueprint Slogan Hero Panel with custom painted architectural guides
        FadeInEntrance(
          index: 1,
          child: _HeroBlueprintLandingSection(isAr: isAr),
        ),
        const SizedBox(height: AppSpacing.md),

        // 3. Platform Stats Strip with animated numbers counting up
        FadeInEntrance(
          index: 2,
          child: _PlatformStatsStrip(isAr: isAr),
        ),
        const SizedBox(height: AppSpacing.md),

        // 4. Interactive Cash Budget Slider Ruler (UX differentiator: Dynamic sliding filter)
        FadeInEntrance(
          index: 3,
          child: _InteractiveBudgetSlider(
            currentValue: maxCashFilter,
            onChanged: (val) {
              setState(() {
                maxCashFilter = val;
              });
            },
            isAr: isAr,
          ),
        ),
        const SizedBox(height: AppSpacing.md),

        // 5. "عايز تبيع؟" Wizard Selling CTA Banner
        FadeInEntrance(
          index: 4,
          child: _SellWizardBanner(isAr: isAr),
        ),
        const SizedBox(height: AppSpacing.md),

        // 6. Featured Resale Opportunities Catalog (Filtered dynamically with entrance transitions)
        FadeInEntrance(
          index: 5,
          child: BrokerSectionHeader(
            title: isAr
                ? 'فرص التنازل المتاحة حالياً (${filteredUnits.length}) 💎'
                : 'Available Resale Opportunities (${filteredUnits.length}) 💎',
          ),
        ),
        if (filteredUnits.isEmpty)
          FadeInEntrance(
            index: 6,
            child: _EmptyState(isAr: isAr),
          )
        else
          _ResaleCatalogGrid(resaleUnits: filteredUnits, isAr: isAr),
        const SizedBox(height: AppSpacing.md),

        // 7. Interactive Traditional vs Safqa Comparison Section
        FadeInEntrance(
          index: 7,
          child: BrokerSectionHeader(
            title: isAr ? 'لماذا منصة صفقة؟' : 'Why Safqa Resale?',
          ),
        ),
        FadeInEntrance(
          index: 8,
          child: _ComparisonPanel(isAr: isAr),
        ),
        const SizedBox(height: AppSpacing.md),

        // 8. Broker Workspace Quick Overview
        FadeInEntrance(
          index: 9,
          child: BrokerSectionHeader(
            title: isAr ? 'لوحة أعمالي كبروكر معتمد 💼' : 'My Certified Workspace 💼',
          ),
        ),
        FadeInEntrance(
          index: 10,
          child: _WorkspaceOverviewCard(
            leadsCount: leads.length,
            dealsCount: deals.length,
            balance: wallet.availableBalance,
            isAr: isAr,
          ),
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

class _HeroBlueprintLandingSection extends StatelessWidget {
  const _HeroBlueprintLandingSection({required this.isAr});

  final bool isAr;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.paper,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.border),
      ),
      child: CustomPaint(
        painter: _BlueprintPainter(),
        child: Padding(
          padding: const EdgeInsets.all(28.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const StatusPill(label: 'عقود تنازل موثقة 🛡️', color: AppColors.emerald),
              const SizedBox(height: 16),
              Text(
                isAr
                    ? 'بيع وتنازل عن وحدتك العقارية بأسرع وقت وأمان كامل'
                    : 'Sell & Transfer Your Property Scans Safely & Instantly',
                style: const TextStyle(
                  color: AppColors.ink,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                isAr
                    ? 'نطابق البائع بالمشتري فوراً، ونتحقق من كافة المستندات والوصولات قانونياً، وننهي إجراءات المطور في 9 أيام فقط.'
                    : 'We match buyers and sellers, verify documents legally, and close developer approvals in 9 days.',
                style: const TextStyle(color: AppColors.muted, fontSize: 12, height: 1.55),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Beautiful Custom Painter to draw technical architectural gridlines + corner crosshairs
class _BlueprintPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.gold.withValues(alpha: 0.04)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    // Draw vertical architectural lines
    const int linesCount = 8;
    final double stepX = size.width / linesCount;
    for (int i = 1; i < linesCount; i++) {
      canvas.drawLine(Offset(i * stepX, 0), Offset(i * stepX, size.height), paint);
    }

    // Draw corner technical crosshairs "+"
    final crossPaint = Paint()
      ..color = AppColors.gold.withValues(alpha: 0.15)
      ..strokeWidth = 1.2;

    const double crossSize = 12.0;

    void drawCross(Offset offset) {
      canvas.drawLine(Offset(offset.dx - crossSize, offset.dy), Offset(offset.dx + crossSize, offset.dy), crossPaint);
      canvas.drawLine(Offset(offset.dx, offset.dy - crossSize), Offset(offset.dx, offset.dy + crossSize), crossPaint);
    }

    drawCross(const Offset(16, 16));
    drawCross(Offset(size.width - 16, 16));
    drawCross(Offset(16, size.height - 16));
    drawCross(Offset(size.width - 16, size.height - 16));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
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
            valueWidget: AnimatedTicker(
              targetValue: 9,
              suffix: isAr ? ' أيام' : ' Days',
              style: const TextStyle(color: AppColors.gold, fontWeight: FontWeight.w900, fontSize: 14),
            ),
            label: isAr ? 'متوسط الإغلاق' : 'Avg Close',
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _StatPillCard(
            valueWidget: const AnimatedTicker(
              targetValue: 100,
              suffix: '%',
              style: TextStyle(color: AppColors.gold, fontWeight: FontWeight.w900, fontSize: 14),
            ),
            label: isAr ? 'أوراق موثقة' : 'Verified Docs',
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _StatPillCard(
            valueWidget: const AnimatedTicker(
              targetValue: 0,
              suffix: '%',
              style: TextStyle(color: AppColors.gold, fontWeight: FontWeight.w900, fontSize: 14),
            ),
            label: isAr ? 'عمولة مشتري' : 'Buyer Fees',
          ),
        ),
      ],
    );
  }
}

class _StatPillCard extends StatelessWidget {
  const _StatPillCard({required this.valueWidget, required this.label});

  final Widget valueWidget;
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
          valueWidget,
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

class _InteractiveBudgetSlider extends StatelessWidget {
  const _InteractiveBudgetSlider({
    required this.currentValue,
    required this.onChanged,
    required this.isAr,
  });

  final double currentValue;
  final ValueChanged<double> onChanged;
  final bool isAr;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.paper,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isAr ? 'تصفية الميزانية المطلوبة كاش' : 'Cash Required Budget Filter',
                style: const TextStyle(color: AppColors.ink, fontWeight: FontWeight.bold, fontSize: 12),
              ),
              Text(
                isAr
                    ? 'حد أقصى: ${currentValue.toStringAsFixed(1)} مليون ج.م'
                    : 'Max: ${currentValue.toStringAsFixed(1)}M EGP',
                style: const TextStyle(color: AppColors.gold, fontWeight: FontWeight.w900, fontSize: 11),
              ),
            ],
          ),
          const SizedBox(height: 6),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppColors.gold,
              inactiveTrackColor: AppColors.border,
              thumbColor: AppColors.gold,
              overlayColor: AppColors.gold.withValues(alpha: 0.1),
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
              trackHeight: 3,
            ),
            child: Slider(
              min: 1.0,
              max: 6.0,
              divisions: 10,
              value: currentValue,
              onChanged: onChanged,
            ),
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
        return FadeInEntrance(
          index: index,
          child: AnimatedTap(
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

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.isAr});

  final bool isAr;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      alignment: Alignment.center,
      child: Column(
        children: [
          const Icon(Icons.money_off_rounded, size: 36, color: AppColors.muted),
          const SizedBox(height: 8),
          Text(
            isAr ? 'لا توجد فرص في حدود هذه الميزانية' : 'No opportunities within this budget',
            style: const TextStyle(color: AppColors.muted, fontSize: 11, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
