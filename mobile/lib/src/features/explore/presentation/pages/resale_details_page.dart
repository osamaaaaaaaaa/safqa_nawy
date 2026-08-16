import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/animated_tap.dart';
import '../../../../shared/widgets/status_pill.dart';
import '../../domain/entities/resale_unit.dart';

class ResaleDetailsPage extends StatefulWidget {
  const ResaleDetailsPage({super.key, required this.unit});

  final ResaleUnit unit;

  @override
  State<ResaleDetailsPage> createState() => _ResaleDetailsPageState();
}

class _ResaleDetailsPageState extends State<ResaleDetailsPage> {
  bool hideCommission = false;

  @override
  Widget build(BuildContext context) {
    final isAr = Get.locale?.languageCode == 'ar';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isAr ? 'تفاصيل الوحدة' : 'Unit Details',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(hideCommission ? Icons.visibility_off_rounded : Icons.visibility_rounded),
            tooltip: isAr ? 'إخفاء العمولات' : 'Hide Commissions',
            onPressed: () {
              setState(() {
                hideCommission = !hideCommission;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.share_rounded),
            onPressed: () {
              Get.snackbar(
                isAr ? 'تم نسخ الرابط' : 'Link Copied',
                isAr ? 'تم نسخ رابط تفاصيل الوحدة لمشاركته مع عميلك.' : 'Resale unit details link copied to share with client.',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: AppColors.ink,
                colorText: Colors.white,
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gallery
            _GallerySection(unit: widget.unit),
            const SizedBox(height: AppSpacing.md),

            // Header Info
            Row(
              children: [
                const StatusPill(label: 'مستندات موثقة', color: AppColors.emerald),
                const SizedBox(width: AppSpacing.sm),
                StatusPill(label: widget.unit.unitCode, color: AppColors.gold),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              widget.unit.title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Text(
              '${widget.unit.developer} • ${widget.unit.location}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.lg),

            // Broker Payout Card
            if (!hideCommission) ...[
              _BrokerCommissionCard(unit: widget.unit, isAr: isAr),
              const SizedBox(height: AppSpacing.md),
            ],

            // Financial Summary Card
            _FinancialSummaryCard(unit: widget.unit, isAr: isAr),
            const SizedBox(height: AppSpacing.md),

            // Specifications Grid
            _SpecsGridSection(unit: widget.unit, isAr: isAr),
            const SizedBox(height: AppSpacing.md),

            // Installment Ledger (Timeline)
            _InstallmentLedgerSection(unit: widget.unit, isAr: isAr),
            const SizedBox(height: 100), // Spacing for floating buttons
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.paper,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -4),
            )
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: AnimatedTap(
                  onTap: () {
                    Get.back();
                    Get.snackbar(
                      isAr ? 'تسجيل عميل جديد' : 'New Lead Registration',
                      isAr ? 'تم فتح قسم العملاء لتسجيل هذا المشتري وحماية عمولتك.' : 'CRM page opened to register this lead and lock your commission.',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  },
                  child: Container(
                    height: 52,
                    decoration: BoxDecoration(
                      color: AppColors.ink,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      isAr ? 'تسجيل مشترٍ مهتم' : 'Register Interested Buyer',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              AnimatedTap(
                onTap: () {
                  Get.snackbar(
                    isAr ? 'مشاركة الكتالوج' : 'Share Catalog',
                    isAr ? 'تم إنشاء كود عرض بدون عمولات لمشاركته مع العميل.' : 'Client-safe presentation created successfully.',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: AppColors.gold,
                    colorText: Colors.white,
                  );
                },
                child: Container(
                  height: 52,
                  width: 52,
                  decoration: BoxDecoration(
                    color: AppColors.gold.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.gold.withValues(alpha: 0.2)),
                  ),
                  child: const Icon(Icons.send_rounded, color: AppColors.gold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GallerySection extends StatelessWidget {
  const _GallerySection({required this.unit});

  final ResaleUnit unit;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.ink.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
      ),
      child: Stack(
        children: [
          // Simulated premium background pattern
          Positioned.fill(
            child: Opacity(
              opacity: 0.15,
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 10,
                ),
                itemBuilder: (context, index) => Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.ink.withValues(alpha: 0.1), width: 0.5),
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.home_work_rounded,
                  size: 64,
                  color: AppColors.gold,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  unit.projectName,
                  style: const TextStyle(
                    color: AppColors.ink,
                    fontWeight: FontWeight.w900,
                    fontSize: 20,
                  ),
                ),
                Text(
                  unit.unitType,
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 12,
            right: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(Icons.photo_library_rounded, color: Colors.white, size: 14),
                  SizedBox(width: 4),
                  Text(
                    '1/5',
                    style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _BrokerCommissionCard extends StatelessWidget {
  const _BrokerCommissionCard({required this.unit, required this.isAr});

  final ResaleUnit unit;
  final bool isAr;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.emerald.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.emerald.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: AppColors.emerald.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.currency_exchange_rounded, color: AppColors.emerald),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isAr ? 'عمولة التسويق والإغلاق لك' : 'Your Closing & Marketing Payout',
                  style: const TextStyle(
                    color: AppColors.emerald,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  unit.commission,
                  style: const TextStyle(
                    color: AppColors.ink,
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.emerald,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              isAr ? 'محمي' : 'Locked',
              style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }
}

class _FinancialSummaryCard extends StatelessWidget {
  const _FinancialSummaryCard({required this.unit, required this.isAr});

  final ResaleUnit unit;
  final bool isAr;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.paper,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isAr ? 'المعطيات المالية للمشتري' : 'Buyer Financial Ledger',
            style: const TextStyle(color: AppColors.muted, fontWeight: FontWeight.bold, fontSize: 12),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isAr ? 'المطلوب كاش الآن' : 'Cash Required Now',
                    style: const TextStyle(color: AppColors.muted, fontSize: 11),
                  ),
                  Text(
                    unit.cashRequired,
                    style: const TextStyle(
                      color: AppColors.gold,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
              Container(
                height: 40,
                width: 1,
                color: AppColors.border,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isAr ? 'إجمالي السعر' : 'Total Resale Price',
                    style: const TextStyle(color: AppColors.muted, fontSize: 11),
                  ),
                  Text(
                    unit.totalPrice,
                    style: const TextStyle(
                      color: AppColors.ink,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.gold.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.gold.withValues(alpha: 0.12)),
            ),
            child: Row(
              children: [
                const Icon(Icons.trending_up_rounded, color: AppColors.gold, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    isAr
                        ? 'مكسب المشتري الفوري عن سعر السوق: ${unit.marketSavings}'
                        : 'Instant buyer savings under market: ${unit.marketSavings}',
                    style: const TextStyle(
                      color: AppColors.gold,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _SpecsGridSection extends StatelessWidget {
  const _SpecsGridSection({required this.unit, required this.isAr});

  final ResaleUnit unit;
  final bool isAr;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.paper,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isAr ? 'مواصفات وتقسيم الوحدة' : 'Unit Specifications',
            style: const TextStyle(color: AppColors.muted, fontWeight: FontWeight.bold, fontSize: 12),
          ),
          const SizedBox(height: AppSpacing.md),
          GridView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 16,
              childAspectRatio: 1.15,
            ),
            children: [
              _SpecCell(
                icon: Icons.hotel_rounded,
                label: isAr ? 'الغرف' : 'Bedrooms',
                val: '${unit.bedrooms}',
              ),
              _SpecCell(
                icon: Icons.bathtub_rounded,
                label: isAr ? 'الحمامات' : 'Bathrooms',
                val: '${unit.bathrooms}',
              ),
              _SpecCell(
                icon: Icons.square_foot_rounded,
                label: isAr ? 'المساحة' : 'Area',
                val: '${unit.area.toInt()} م²',
              ),
              _SpecCell(
                icon: Icons.layers_rounded,
                label: isAr ? 'الدور' : 'Floor',
                val: unit.floor,
              ),
              _SpecCell(
                icon: Icons.brush_rounded,
                label: isAr ? 'التشطيب' : 'Finishing',
                val: isAr ? 'كامل' : 'Finished',
              ),
              _SpecCell(
                icon: Icons.home_work_rounded,
                label: isAr ? 'النوع' : 'Type',
                val: isAr ? 'تاون هاوس' : 'Townhouse',
              ),
            ],
          )
        ],
      ),
    );
  }
}

class _SpecCell extends StatelessWidget {
  const _SpecCell({required this.icon, required this.label, required this.val});

  final IconData icon;
  final String label;
  final String val;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: AppColors.gold, size: 20),
        const SizedBox(height: 4),
        Text(
          val,
          style: const TextStyle(
            color: AppColors.ink,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          textAlign: TextAlign.center,
        ),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.muted,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}

class _InstallmentLedgerSection extends StatelessWidget {
  const _InstallmentLedgerSection({required this.unit, required this.isAr});

  final ResaleUnit unit;
  final bool isAr;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.paper,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isAr ? 'دفتر الأقساط والمدفوعات المتبقية' : 'Installment Ledger & Remaining Dues',
            style: const TextStyle(color: AppColors.muted, fontWeight: FontWeight.bold, fontSize: 12),
          ),
          const SizedBox(height: AppSpacing.md),
          _LedgerRow(
            label: isAr ? 'الأقساط المتبقية للمطور' : 'Remaining Installments',
            value: unit.remainingInstallments,
            highlight: false,
          ),
          const Divider(height: 20),
          _LedgerRow(
            label: isAr ? 'القسط القادم' : 'Next Installment',
            value: unit.nextInstallment,
            highlight: true,
          ),
          const Divider(height: 20),
          _LedgerRow(
            label: isAr ? 'تاريخ الاستحقاق' : 'Next Installment Date',
            value: unit.nextInstallmentDate,
            highlight: false,
          ),
          const Divider(height: 20),
          _LedgerRow(
            label: isAr ? 'وديعة الصيانة' : 'Maintenance Deposit',
            value: isAr ? 'مدفوعة بالكامل' : 'Paid in Full',
            highlight: false,
          ),
        ],
      ),
    );
  }
}

class _LedgerRow extends StatelessWidget {
  const _LedgerRow({required this.label, required this.value, required this.highlight});

  final String label;
  final String value;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(color: AppColors.muted, fontSize: 12),
        ),
        Text(
          value,
          style: TextStyle(
            color: highlight ? AppColors.gold : AppColors.ink,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}
