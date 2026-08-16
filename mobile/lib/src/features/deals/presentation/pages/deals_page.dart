import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/broker_page.dart';
import '../../../../shared/widgets/broker_section_header.dart';
import '../../../../shared/widgets/status_pill.dart';
import '../../data/repositories/deals_repository.dart';
import '../../domain/entities/deal.dart';

class DealsPage extends StatelessWidget {
  const DealsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final deals = const DealsRepository().activeDeals();
    final isAr = Get.locale?.languageCode == 'ar';

    return BrokerPage(
      children: [
        _Header(title: 'deals.title'.tr, subtitle: 'deals.subtitle'.tr),
        
        // Premium add deal panel
        _NewDealPanel(isAr: isAr),
        
        BrokerSectionHeader(
          title: 'deals.active'.tr,
          action: 'common.view_all'.tr,
        ),
        
        ...deals.map((deal) => _DealCard(deal: deal, isAr: isAr)),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.w900,
                letterSpacing: -1,
              ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}

class _NewDealPanel extends StatelessWidget {
  const _NewDealPanel({required this.isAr});

  final bool isAr;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.gold.withValues(alpha: .06),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.22), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.gold.withValues(alpha: 0.01),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.gold.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.add_circle_rounded, color: AppColors.gold, size: 28),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'deals.new.title'.tr,
                  style: const TextStyle(
                    color: AppColors.ink,
                    fontWeight: FontWeight.w900,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'deals.new.copy'.tr,
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontSize: 11,
                    height: 1.4,
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

class _DealCard extends StatelessWidget {
  const _DealCard({required this.deal, required this.isAr});

  final Deal deal;
  final bool isAr;

  @override
  Widget build(BuildContext context) {
    final stage = switch (deal.stage) {
      DealStage.documents => ('deals.stage.documents'.tr, AppColors.gold, 1),
      DealStage.developerReview => ('deals.stage.review'.tr, AppColors.navy, 2),
      DealStage.transferSigning => ('deals.stage.signing'.tr, AppColors.gold, 3),
      DealStage.commissionReady => ('deals.stage.ready'.tr, AppColors.emerald, 4),
    };

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.paper,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.01),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                deal.unit,
                style: const TextStyle(
                  color: AppColors.ink,
                  fontWeight: FontWeight.w900,
                  fontSize: 15,
                ),
              ),
              StatusPill(label: stage.$1, color: stage.$2),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.person_outline_rounded, color: AppColors.muted, size: 16),
              const SizedBox(width: 6),
              Text(
                '${'deals.buyer'.tr}: ${deal.buyer}',
                style: const TextStyle(color: AppColors.muted, fontSize: 12),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1),
          ),

          // Visual Pipeline Timeline tracker
          _DealTimelineTracker(currentStep: stage.$3, isAr: isAr),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: _Fact(label: 'deals.value'.tr, value: deal.value),
              ),
              Expanded(
                child: _Fact(
                  label: 'deals.commission'.tr,
                  value: deal.commission,
                  isEmerald: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DealTimelineTracker extends StatelessWidget {
  const _DealTimelineTracker({required this.currentStep, required this.isAr});

  final int currentStep;
  final bool isAr;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.ink.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _buildNode(1, Icons.folder_open_rounded),
          _buildConnector(1),
          _buildNode(2, Icons.rate_review_rounded),
          _buildConnector(2),
          _buildNode(3, Icons.draw_rounded),
          _buildConnector(3),
          _buildNode(4, Icons.payments_rounded),
        ],
      ),
    );
  }

  Widget _buildNode(int step, IconData icon) {
    final isDone = step <= currentStep;
    final isCurrent = step == currentStep;

    return Container(
      height: 28,
      width: 28,
      decoration: BoxDecoration(
        color: isCurrent
            ? AppColors.gold
            : isDone
                ? AppColors.emerald.withValues(alpha: 0.15)
                : Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: isCurrent
              ? AppColors.gold
              : isDone
                  ? AppColors.emerald
                  : AppColors.border,
          width: 1.5,
        ),
      ),
      child: Icon(
        icon,
        size: 14,
        color: isCurrent
            ? Colors.white
            : isDone
                ? AppColors.emerald
                : AppColors.muted,
      ),
    );
  }

  Widget _buildConnector(int step) {
    final isDone = step < currentStep;
    return Expanded(
      child: Container(
        height: 2,
        color: isDone ? AppColors.emerald : AppColors.border,
      ),
    );
  }
}

class _Fact extends StatelessWidget {
  const _Fact({required this.label, required this.value, this.isEmerald = false});

  final String label;
  final String value;
  final bool isEmerald;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: TextStyle(
            color: isEmerald ? AppColors.emerald : AppColors.ink,
            fontWeight: FontWeight.w900,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          label,
          style: const TextStyle(color: AppColors.muted, fontSize: 11),
        ),
      ],
    );
  }
}
