import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/broker_contract.dart';

class BrokerContractCard extends StatelessWidget {
  const BrokerContractCard({
    required this.contract,
    super.key,
  });

  final BrokerContract contract;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return Container(
      width: 292,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.paper,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.ink.withValues(alpha: .06),
            blurRadius: 24,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: AppColors.emerald.withValues(alpha: .12),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(
                  Icons.description_rounded,
                  color: AppColors.emerald,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(contract.projectName, style: theme.titleMedium),
                    const SizedBox(height: 4),
                    Text(contract.unitCode, style: theme.bodyMedium),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          _ContractNumber(
            label: 'contract.client'.tr,
            value: contract.clientName,
          ),
          _ContractNumber(
            label: 'contract.value'.tr,
            value: contract.contractValue,
          ),
          _ContractNumber(
            label: 'contract.commission'.tr,
            value: contract.commission,
            valueColor: AppColors.emerald,
          ),
          const SizedBox(height: AppSpacing.sm),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.gold.withValues(alpha: .13),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              '${'contract.status'.tr}: ${contract.status}',
              style: theme.titleMedium?.copyWith(
                color: AppColors.navy,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ContractNumber extends StatelessWidget {
  const _ContractNumber({
    required this.label,
    required this.value,
    this.valueColor,
  });

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: valueColor ?? AppColors.ink,
                  fontSize: 14,
                ),
          ),
        ],
      ),
    );
  }
}
