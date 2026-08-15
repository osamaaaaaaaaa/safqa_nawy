import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';

class WalletPage extends StatelessWidget {
  const WalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: Text(
          'wallet.title'.tr,
          style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Premium Wallet Asset Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.paper, Color(0xFF1B2A4A)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.border, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.gold.withValues(alpha: .05),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'wallet.total_balance'.tr,
                          style: TextStyle(
                            color: AppColors.muted,
                            fontSize: 13,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.gold.withValues(alpha: .15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.military_tech_rounded,
                                color: AppColors.gold,
                                size: 16,
                              ),
                              SizedBox(width: 4),
                              Text(
                                'Broker Pro',
                                style: TextStyle(
                                  color: AppColors.gold,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'EGP 664,000',
                      style: TextStyle(
                        color: AppColors.gold,
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -1,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: _WalletStat(
                            label: 'wallet.stat.cleared'.tr,
                            value: 'EGP 360K',
                            color: AppColors.emerald,
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 35,
                          color: AppColors.border,
                        ),
                        Expanded(
                          child: _WalletStat(
                            label: 'wallet.stat.pending'.tr,
                            value: 'EGP 304K',
                            color: AppColors.gold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Earnings History Chart
              Text('wallet.chart.title'.tr, style: textTheme.titleMedium),
              const SizedBox(height: AppSpacing.md),
              Container(
                height: 180,
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.paper,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          _BarChartColumn(
                            heightRatio: 0.2,
                            label: 'wallet.chart.month.mar'.tr,
                          ),
                          _BarChartColumn(
                            heightRatio: 0.45,
                            label: 'wallet.chart.month.apr'.tr,
                          ),
                          _BarChartColumn(
                            heightRatio: 0.35,
                            label: 'wallet.chart.month.may'.tr,
                          ),
                          _BarChartColumn(
                            heightRatio: 0.7,
                            label: 'wallet.chart.month.jun'.tr,
                          ),
                          _BarChartColumn(
                            heightRatio: 0.9,
                            label: 'wallet.chart.month.jul'.tr,
                            isHighlighted: true,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Recent Transactions list
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'wallet.transactions.title'.tr,
                    style: textTheme.titleMedium,
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'wallet.transactions.all'.tr,
                      style: const TextStyle(color: AppColors.gold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),

              _TransactionRow(
                title: 'New Capital Heights Deal C-09',
                date: '12 Aug 2026',
                amount: '+EGP 360,000',
                status: 'wallet.tx.cleared'.tr,
                isPositive: true,
              ),
              const SizedBox(height: AppSpacing.md),
              _TransactionRow(
                title: 'East Residence Deal A-1407',
                date: '05 Aug 2026',
                amount: '+EGP 116,000',
                status: 'wallet.tx.pending'.tr,
                isPositive: false,
              ),
              const SizedBox(height: AppSpacing.md),
              _TransactionRow(
                title: 'West Park Deal T-22',
                date: '28 Jul 2026',
                amount: '+EGP 188,000',
                status: 'wallet.tx.pending'.tr,
                isPositive: false,
              ),
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }
}

class _WalletStat extends StatelessWidget {
  const _WalletStat({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: AppColors.muted),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            color: color,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

class _BarChartColumn extends StatelessWidget {
  const _BarChartColumn({
    required this.heightRatio,
    required this.label,
    this.isHighlighted = false,
  });

  final double heightRatio;
  final String label;
  final bool isHighlighted;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final barHeight = constraints.maxHeight * heightRatio;
              return Container(
                width: 32,
                height: barHeight,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isHighlighted
                        ? [AppColors.gold, const Color(0xFFFFE082)]
                        : [
                            AppColors.emerald.withValues(alpha: .4),
                            AppColors.emerald,
                          ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(6),
                  ),
                  boxShadow: isHighlighted
                      ? [
                          BoxShadow(
                            color: AppColors.gold.withValues(alpha: .3),
                            blurRadius: 8,
                            offset: const Offset(0, -2),
                          ),
                        ]
                      : null,
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: AppColors.muted),
        ),
      ],
    );
  }
}

class _TransactionRow extends StatelessWidget {
  const _TransactionRow({
    required this.title,
    required this.date,
    required this.amount,
    required this.status,
    required this.isPositive,
  });

  final String title;
  final String date;
  final String amount;
  final String status;
  final bool isPositive;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.paper,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: AppColors.ink,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      date,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.muted,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 1.5,
                      ),
                      decoration: BoxDecoration(
                        color: (isPositive ? AppColors.emerald : AppColors.gold)
                            .withValues(alpha: .15),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          color: isPositive
                              ? AppColors.emerald
                              : AppColors.gold,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            amount,
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 14,
              color: isPositive ? AppColors.emerald : AppColors.gold,
            ),
          ),
        ],
      ),
    );
  }
}
