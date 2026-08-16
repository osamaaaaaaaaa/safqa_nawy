import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math' as math;

import '../../../../core/controllers/locale_controller.dart';
import '../../../../core/controllers/settings_controller.dart';
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
  // Calculator States
  double contractPrice = 4.5; // In Millions EGP
  double premiumPaid = 0.5; // In Millions EGP

  @override
  Widget build(BuildContext context) {
    final localeController = Get.find<LocaleController>();
    final settingsController = Get.find<SettingsController>();
    final leads = const LeadsRepository().activeLeads();
    final deals = const DealsRepository().activeDeals();
    final wallet = const WalletRepository();
    final resaleUnits = const ResaleRepository().featuredResaleUnits();
    final isAr = Get.locale?.languageCode == 'ar';

    // Calculate dynamic values for the calculator console
    final calculatedCash = contractPrice * 0.4 + premiumPaid; // Assuming 40% paid to date + premium
    final marketPrice = contractPrice * 1.2; // Assuming current market is 20% higher than original contract
    final estimatedSavings = marketPrice - (contractPrice + premiumPaid);

    return BrokerPage(
      children: [
        // 1. Technical Navbar (No emojis)
        FadeInEntrance(
          index: 0,
          child: _LandingNavbar(localeController: localeController),
        ),
        const SizedBox(height: AppSpacing.sm),

        // 2. Command Hub Header: Custom Painted Gauge + Slogan (Outside the box UX)
        FadeInEntrance(
          index: 1,
          child: _CommandHubHero(isAr: isAr),
        ),
        const SizedBox(height: AppSpacing.md),

        // 3. Platform Stats Strip (Dynamic animated tickers)
        FadeInEntrance(
          index: 2,
          child: _PlatformStatsStrip(isAr: isAr),
        ),
        const SizedBox(height: AppSpacing.md),

        // 4. Immersive Escrow & savings Calculator Console (UX differentiator)
        FadeInEntrance(
          index: 3,
          child: _EscrowCalculatorConsole(
            contractPrice: contractPrice,
            premiumPaid: premiumPaid,
            calculatedCash: calculatedCash,
            estimatedSavings: estimatedSavings,
            onContractChanged: (val) => setState(() => contractPrice = val),
            onPremiumChanged: (val) => setState(() => premiumPaid = val),
            isAr: isAr,
          ),
        ),
        const SizedBox(height: AppSpacing.md),

        // 5. Want to Sell CTA card
        FadeInEntrance(
          index: 4,
          child: _SellWizardCTA(isAr: isAr),
        ),
        const SizedBox(height: AppSpacing.md),

        // 6. Featured Resale opportunities
        FadeInEntrance(
          index: 5,
          child: BrokerSectionHeader(
            title: isAr ? 'فرص التنازل العقاري الحالية' : 'Current Resale Portfolio',
          ),
        ),
        _ResaleCatalogGrid(resaleUnits: resaleUnits, isAr: isAr, settingsController: settingsController),
        const SizedBox(height: AppSpacing.md),

        // 7. Technical Comparison Rows (No emojis)
        FadeInEntrance(
          index: 6,
          child: BrokerSectionHeader(
            title: isAr ? 'لماذا منصة صفقة؟' : 'Why Safqa Resale?',
          ),
        ),
        FadeInEntrance(
          index: 7,
          child: _ComparisonPanel(isAr: isAr),
        ),
        const SizedBox(height: AppSpacing.md),

        // 8. Broker Workspace Overview Panel
        FadeInEntrance(
          index: 8,
          child: BrokerSectionHeader(
            title: isAr ? 'لوحة أعمالي كبروكر معتمد' : 'My Certified Workspace',
          ),
        ),
        FadeInEntrance(
          index: 9,
          child: _WorkspaceOverviewCard(
            leadsCount: leads.length,
            dealsCount: deals.length,
            balance: wallet.availableBalance,
            isAr: isAr,
            settingsController: settingsController,
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

class _CommandHubHero extends StatelessWidget {
  const _CommandHubHero({required this.isAr});

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
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StatusPill(
                  label: isAr ? 'توثيق رسمي' : 'Verified Escrow',
                  color: AppColors.emerald,
                ),
                const SizedBox(height: 12),
                Text(
                  isAr
                      ? 'بوابة التنازل والتسجيل العقاري الآمنة'
                      : 'Secure Resale & Title Escrow Gate',
                  style: const TextStyle(
                    color: AppColors.ink,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  isAr
                      ? 'مطابقة المشترين والتحقق من المستندات قانونياً وإغلاق الإجراءات في 9 أيام فقط.'
                      : 'Matching buyers, legal contract verification, and developer closing in 9 days.',
                  style: const TextStyle(color: AppColors.muted, fontSize: 11, height: 1.5),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Circular gauge painter representing Trust score
          Expanded(
            flex: 2,
            child: Column(
              children: [
                SizedBox(
                  height: 84,
                  width: 84,
                  child: CustomPaint(
                    painter: _GaugePainter(),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            '98%',
                            style: TextStyle(
                              color: AppColors.gold,
                              fontWeight: FontWeight.w900,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            isAr ? 'تقييم الأمان' : 'Trust Score',
                            style: const TextStyle(color: AppColors.muted, fontSize: 8),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GaugePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Background track circle
    final trackPaint = Paint()
      ..color = AppColors.border
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5.0;

    canvas.drawCircle(center, radius - 4, trackPaint);

    // Active arc represent 98%
    final activePaint = Paint()
      ..color = AppColors.gold
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 6.0;

    const startAngle = -math.pi / 2;
    const sweepAngle = 2 * math.pi * 0.98;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - 4),
      startAngle,
      sweepAngle,
      false,
      activePaint,
    );
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
              style: const TextStyle(color: AppColors.gold, fontWeight: FontWeight.w900, fontSize: 13),
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
              style: TextStyle(color: AppColors.gold, fontWeight: FontWeight.w900, fontSize: 13),
            ),
            label: isAr ? 'توثيق قانوني' : 'Legal Audited',
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _StatPillCard(
            valueWidget: const AnimatedTicker(
              targetValue: 0,
              suffix: '%',
              style: TextStyle(color: AppColors.gold, fontWeight: FontWeight.w900, fontSize: 13),
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

class _EscrowCalculatorConsole extends StatelessWidget {
  const _EscrowCalculatorConsole({
    required this.contractPrice,
    required this.premiumPaid,
    required this.calculatedCash,
    required this.estimatedSavings,
    required this.onContractChanged,
    required this.onPremiumChanged,
    required this.isAr,
  });

  final double contractPrice;
  final double premiumPaid;
  final double calculatedCash;
  final double estimatedSavings;
  final ValueChanged<double> onContractChanged;
  final ValueChanged<double> onPremiumChanged;
  final bool isAr;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.paper,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.calculate_rounded, color: AppColors.gold, size: 20),
              const SizedBox(width: 8),
              Text(
                isAr ? 'حاسبة التنازل والوفر المالي المباشر' : 'Escrow Yield & Savings Calculator',
                style: const TextStyle(color: AppColors.ink, fontWeight: FontWeight.w900, fontSize: 13),
              )
            ],
          ),
          const SizedBox(height: 16),

          // Slider 1: Contract price
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(isAr ? 'سعر العقد الأصلي' : 'Contract Price', style: const TextStyle(color: AppColors.muted, fontSize: 11)),
              Text('${contractPrice.toStringAsFixed(1)}M EGP', style: const TextStyle(color: AppColors.ink, fontWeight: FontWeight.bold, fontSize: 11)),
            ],
          ),
          Slider(
            min: 2.0,
            max: 10.0,
            divisions: 16,
            activeColor: AppColors.gold,
            value: contractPrice,
            onChanged: onContractChanged,
          ),

          // Slider 2: Premium paid
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(isAr ? 'قيمة الأوفر المطلوب' : 'Premium Requested', style: const TextStyle(color: AppColors.muted, fontSize: 11)),
              Text('${premiumPaid.toStringAsFixed(1)}M EGP', style: const TextStyle(color: AppColors.ink, fontWeight: FontWeight.bold, fontSize: 11)),
            ],
          ),
          Slider(
            min: 0.0,
            max: 3.0,
            divisions: 12,
            activeColor: AppColors.gold,
            value: premiumPaid,
            onChanged: onPremiumChanged,
          ),

          const Divider(height: 20),

          // Results Output Dashboard
          Row(
            children: [
              Expanded(
                child: _OutputCell(
                  label: isAr ? 'الكاش المطلوبة' : 'Cash Required',
                  value: '${calculatedCash.toStringAsFixed(2)}M EGP',
                  isGold: true,
                ),
              ),
              Expanded(
                child: _OutputCell(
                  label: isAr ? 'الوفر للمشتري' : 'Buyer Savings',
                  value: '${estimatedSavings.toStringAsFixed(2)}M EGP',
                  isGold: false,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OutputCell extends StatelessWidget {
  const _OutputCell({required this.label, required this.value, required this.isGold});

  final String label;
  final String value;
  final bool isGold;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: TextStyle(
            color: isGold ? AppColors.gold : AppColors.emerald,
            fontWeight: FontWeight.w900,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(color: AppColors.muted, fontSize: 10, fontWeight: FontWeight.bold),
        )
      ],
    );
  }
}

class _SellWizardCTA extends StatelessWidget {
  const _SellWizardCTA({required this.isAr});

  final bool isAr;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.ink,
        borderRadius: BorderRadius.circular(26),
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
                child: const Icon(Icons.add_home_work_rounded, color: AppColors.gold, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  isAr ? 'أدرج وحدة للتنازل والبيع العقاري' : 'List Resale Property Escrow',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 13),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            isAr
                ? 'أدخل بيانات عقارك وتواريخ الأقساط، وارفع نسخة من العقد للتحقق والتوثيق القانوني وعرضها للمشترين.'
                : 'Input compound details, remaining developer dues, and upload contract scans for title escrow verification.',
            style: const TextStyle(color: Colors.white70, fontSize: 11, height: 1.5),
          ),
          const SizedBox(height: 16),
          AnimatedTap(
            onTap: () => Get.to(() => const CreateResalePage()),
            child: Container(
              height: 44,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.gold,
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.rocket_launch_rounded, color: Colors.white, size: 14),
                  const SizedBox(width: 6),
                  Text(
                    isAr ? 'ابدأ إدراج وحدتك الآن' : 'Start Resale wizard',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _ResaleCatalogGrid extends StatelessWidget {
  const _ResaleCatalogGrid({
    required this.resaleUnits,
    required this.isAr,
    required this.settingsController,
  });

  final List<ResaleUnit> resaleUnits;
  final bool isAr;
  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.74,
        ),
        itemCount: resaleUnits.length,
        itemBuilder: (context, index) {
          final unit = resaleUnits[index];
          final hidePayout = settingsController.clientMode.value;

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

                            // Payout Badge (hidden dynamically)
                            if (!hidePayout)
                              Text(
                                unit.commission,
                                style: const TextStyle(color: AppColors.emerald, fontWeight: FontWeight.bold, fontSize: 10),
                              ),

                            const Divider(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(isAr ? 'الكاش' : 'Cash Req', style: const TextStyle(color: AppColors.muted, fontSize: 7)),
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
      ),
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
              safqa: isAr ? 'توثيق معتمد' : 'Legal Audited',
            ),
            const Divider(height: 16),
            _ComparisonRow(
              title: isAr ? 'سرعة التنازل' : 'Escrow Speed',
              trad: isAr ? 'أشهر طويلة' : 'Months',
              safqa: isAr ? '9 أيام فقط' : 'Only 9 Days',
            ),
            const Divider(height: 16),
            _ComparisonRow(
              title: isAr ? 'العمولات' : 'Commission',
              trad: isAr ? 'مزدوجة ومخفية' : 'Hidden / high',
              safqa: isAr ? 'منخفضة ومحددة' : 'Low & clear',
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
    required this.settingsController,
  });

  final int leadsCount;
  final int dealsCount;
  final String balance;
  final bool isAr;
  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
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
                  label: isAr ? 'العقود والصفقات' : 'Escrow Deals',
                  value: '$dealsCount',
                  onTap: () => Get.to(() => const DealsPage()),
                ),
                Container(height: 30, width: 1, color: AppColors.border),
                _OverviewItem(
                  label: isAr ? 'المحفظة والأرباح' : 'Wallet Balance',
                  value: settingsController.clientMode.value ? '***' : balance.split(' ').first,
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
                  isAr ? 'أنت وسيط معتمد ومرخص لدى منصة صفقة' : 'You are a certified Safqa escrow broker',
                  style: const TextStyle(color: AppColors.gold, fontSize: 10, fontWeight: FontWeight.bold),
                )
              ],
            )
          ],
        ),
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
