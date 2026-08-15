import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/broker_page.dart';
import '../../../../shared/widgets/broker_section_header.dart';
import '../../../../shared/widgets/metric_card.dart';
import '../../data/repositories/wallet_repository.dart';
import '../../domain/entities/wallet_transaction.dart';

class WalletPage extends StatelessWidget {
  const WalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    final wallet = const WalletRepository();

    return BrokerPage(
      children: [
        _WalletHero(wallet: wallet),
        Row(
          children: [
            Expanded(
              child: MetricCard(
                label: 'wallet.pending'.tr,
                value: wallet.pendingBalance,
                icon: Icons.pending_actions_rounded,
                color: AppColors.gold,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: MetricCard(
                label: 'wallet.paid_month'.tr,
                value: wallet.paidThisMonth,
                icon: Icons.payments_rounded,
                color: AppColors.emerald,
              ),
            ),
          ],
        ),
        BrokerSectionHeader(title: 'wallet.transactions'.tr),
        ...wallet.transactions().map(
          (transaction) => _TransactionTile(transaction: transaction),
        ),
      ],
    );
  }
}

class _WalletHero extends StatelessWidget {
  const _WalletHero({required this.wallet});

  final WalletRepository wallet;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.ink,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'wallet.title'.tr,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            wallet.availableBalance,
            style: Theme.of(
              context,
            ).textTheme.displaySmall?.copyWith(color: Colors.white),
          ),
          const SizedBox(height: AppSpacing.lg),
          FilledButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.call_made_rounded),
            label: Text('wallet.withdraw'.tr),
          ),
        ],
      ),
    );
  }
}

class _TransactionTile extends StatelessWidget {
  const _TransactionTile({required this.transaction});

  final WalletTransaction transaction;

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
        children: [
          Icon(
            transaction.isCredit
                ? Icons.south_west_rounded
                : Icons.north_east_rounded,
            color: transaction.isCredit ? AppColors.emerald : AppColors.clay,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  transaction.subtitle,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          Text(
            transaction.amount,
            style: TextStyle(
              color: transaction.isCredit ? AppColors.emerald : AppColors.clay,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}
