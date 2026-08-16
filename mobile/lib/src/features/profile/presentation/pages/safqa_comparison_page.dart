import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/status_pill.dart';

class SafqaComparisonPage extends StatelessWidget {
  const SafqaComparisonPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isAr = Get.locale?.languageCode == 'ar';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isAr ? 'لماذا منصة صفقة؟' : 'Why Safqa Resale?',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Visual Card
            _ComparisonHero(isAr: isAr),
            const SizedBox(height: AppSpacing.md),

            // Main comparison Table
            _ComparisonTable(isAr: isAr),
            const SizedBox(height: AppSpacing.md),

            // Pitch guidelines cards
            Text(
              isAr ? 'كيف تقنع عميلك بالخروج عبر صفقة؟' : 'How to pitch Safqa to your client?',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AppSpacing.sm),
            _PitchCard(
              index: '01',
              title: isAr ? 'أمان قانوني كامل' : '100% Legal Safety',
              desc: isAr
                  ? 'العقود والوصولات المرفوعة يتم مراجعتها وتدقيقها بالكامل من قبل الإدارة القانونية لصفقة قبل قبول العرض.'
                  : 'All contracts and payment receipts are audited by Safqa legal desk before the resale offer is listed.',
            ),
            const SizedBox(height: AppSpacing.sm),
            _PitchCard(
              index: '02',
              title: isAr ? 'سرعة فائقة (متوسط 9 أيام)' : 'Speed (9 Days Average)',
              desc: isAr
                  ? 'نوفر قاعدة مشترين فوريين جاهزين بالكاش مع مطابقة سريعة للمطور العقاري دون ضياع أشهر في البحث التقليدي.'
                  : 'We match buyers with ready cash instantly and fast-track developer approvals without wasting months.',
            ),
            const SizedBox(height: AppSpacing.sm),
            _PitchCard(
              index: '03',
              title: isAr ? 'عمولة منخفضة وواضحة' : 'Lowest Transparent Commission',
              desc: isAr
                  ? 'عمولة إغلاق صفقات التنازل منخفضة جداً وواضحة للطرفين وبدون أي مصاريف خفية.'
                  : 'Low closing commission rates, clear splits, and no hidden expenses for both buyer and seller.',
            ),
            const SizedBox(height: 120),
          ],
        ),
      ),
    );
  }
}

class _ComparisonHero extends StatelessWidget {
  const _ComparisonHero({required this.isAr});

  final bool isAr;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.ink,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const StatusPill(label: 'معيار المقارنة العقارية', color: AppColors.gold),
          const SizedBox(height: AppSpacing.md),
          Text(
            isAr
                ? 'الفرق الحقيقي بين التنازل التقليدي وعبر صفقة'
                : 'The Real Difference in Resale & Transfer Transactions',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white, fontSize: 18),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            isAr
                ? 'صفقة ليست مجرد مكتب تسويق، بل منصة إغلاق صفقات متكاملة تضمن حماية حقوق البروكر وعميله المشتري والبائع.'
                : 'Safqa is not just a marketing listing, but a transaction desk securing the rights of the broker, buyer, and seller.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}

class _ComparisonTable extends StatelessWidget {
  const _ComparisonTable({required this.isAr});

  final bool isAr;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            _TableHeader(isAr: isAr),
            const Divider(height: 24),
            _TableRowItem(
              feature: isAr ? 'مراجعة المستندات' : 'Doc Verification',
              traditional: isAr ? 'لا يوجد / بطيء' : 'Risky / slow',
              safqa: isAr ? 'توثيق قانوني فوري' : 'Instant Audit',
              isPositive: true,
            ),
            const Divider(height: 24),
            _TableRowItem(
              feature: isAr ? 'سرعة التنفيذ' : 'Closing Speed',
              traditional: isAr ? 'شهور متعددة' : 'Months',
              safqa: isAr ? 'خلال 9 أيام فقط' : 'Avg 9 days',
              isPositive: true,
            ),
            const Divider(height: 24),
            _TableRowItem(
              feature: isAr ? 'عمولة الإغلاق' : 'Closing Payout',
              traditional: isAr ? 'غير واضحة / مزدوجة' : 'Hidden / high',
              safqa: isAr ? 'محددة وواضحة جداً' : 'Low & clear',
              isPositive: true,
            ),
            const Divider(height: 24),
            _TableRowItem(
              feature: isAr ? 'ضمان الملكية' : 'Title Escrow',
              traditional: isAr ? 'على مسؤولية العميل' : 'Broker risk',
              safqa: isAr ? 'إشراف كامل من صفقة' : 'Safqa managed',
              isPositive: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _TableHeader extends StatelessWidget {
  const _TableHeader({required this.isAr});

  final bool isAr;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            isAr ? 'الميزة' : 'Feature',
            style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.muted),
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            isAr ? 'ريسيل تقليدي' : 'Traditional',
            style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.muted),
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            isAr ? 'منصة صفقة' : 'Safqa Platform',
            style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.gold),
          ),
        ),
      ],
    );
  }
}

class _TableRowItem extends StatelessWidget {
  const _TableRowItem({
    required this.feature,
    required this.traditional,
    required this.safqa,
    required this.isPositive,
  });

  final String feature;
  final String traditional;
  final String safqa;
  final bool isPositive;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            feature,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            traditional,
            style: const TextStyle(color: AppColors.muted, fontSize: 11),
          ),
        ),
        Expanded(
          flex: 2,
          child: Row(
            children: [
              Icon(
                isPositive ? Icons.check_circle_rounded : Icons.cancel_rounded,
                color: isPositive ? AppColors.emerald : AppColors.clay,
                size: 16,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  safqa,
                  style: const TextStyle(color: AppColors.emerald, fontWeight: FontWeight.bold, fontSize: 11),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PitchCard extends StatelessWidget {
  const _PitchCard({required this.index, required this.title, required this.desc});

  final String index;
  final String title;
  final String desc;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.paper,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.gold.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              index,
              style: const TextStyle(color: AppColors.gold, fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.ink),
                ),
                const SizedBox(height: 4),
                Text(
                  desc,
                  style: const TextStyle(color: AppColors.muted, fontSize: 12, height: 1.4),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
