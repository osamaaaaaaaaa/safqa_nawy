import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/broker_page.dart';
import '../../../../shared/widgets/broker_section_header.dart';
import '../../data/repositories/wallet_repository.dart';
import '../../domain/entities/wallet_transaction.dart';

class WalletPage extends StatelessWidget {
  const WalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    final wallet = const WalletRepository();
    final isAr = Get.locale?.languageCode == 'ar';

    return BrokerPage(
      children: [
        // Luxury credit-card style available balance hero
        _WalletCardHero(wallet: wallet, isAr: isAr),
        
        Row(
          children: [
            Expanded(
              child: _PremiumWalletMetricCard(
                label: 'wallet.pending'.tr,
                value: wallet.pendingBalance,
                icon: Icons.pending_actions_rounded,
                color: AppColors.gold,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: _PremiumWalletMetricCard(
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
          (transaction) => _TransactionTile(transaction: transaction, isAr: isAr),
        ),
      ],
    );
  }
}

class _WalletCardHero extends StatelessWidget {
  const _WalletCardHero({required this.wallet, required this.isAr});

  final WalletRepository wallet;
  final bool isAr;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.ink, Color(0xFF1E293B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppColors.ink.withValues(alpha: 0.25),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
        border: Border.all(color: Colors.white.withValues(alpha: 0.08), width: 1.5),
      ),
      child: Stack(
        children: [
          // Visa / Chip watermark
          Positioned(
            right: isAr ? null : 16,
            left: isAr ? 16 : null,
            top: 16,
            child: Opacity(
              opacity: 0.08,
              child: Icon(Icons.credit_card_rounded, size: 80, color: Colors.white),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'wallet.title'.tr,
                    style: const TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    'SAFQA PAY',
                    style: TextStyle(
                      color: AppColors.gold,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  )
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                wallet.availableBalance,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.gold,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: () {
                  Get.snackbar(
                    isAr ? 'طلب سحب رصيد' : 'Withdrawal Request',
                    isAr ? 'تم استلام طلب السحب وسيقوم البنك بالمعالجة الفورية.' : 'Request received. Bank processing initiated.',
                    backgroundColor: AppColors.ink,
                    colorText: Colors.white,
                  );
                },
                icon: const Icon(Icons.call_made_rounded, size: 16),
                label: Text(
                  'wallet.withdraw'.tr,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PremiumWalletMetricCard extends StatelessWidget {
  const _PremiumWalletMetricCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;

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
            children: [
              Icon(icon, color: color, size: 18),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(color: AppColors.muted, fontSize: 10, fontWeight: FontWeight.bold),
              )
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.ink,
              fontSize: 15,
              fontWeight: FontWeight.w900,
            ),
          )
        ],
      ),
    );
  }
}

class _TransactionTile extends StatelessWidget {
  const _TransactionTile({required this.transaction, required this.isAr});

  final WalletTransaction transaction;
  final bool isAr;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.paper,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.005),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: transaction.isCredit
                  ? AppColors.emerald.withValues(alpha: 0.08)
                  : AppColors.clay.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              transaction.isCredit
                  ? Icons.south_west_rounded
                  : Icons.north_east_rounded,
              color: transaction.isCredit ? AppColors.emerald : AppColors.clay,
              size: 18,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.title,
                  style: const TextStyle(
                    color: AppColors.ink,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  transaction.subtitle,
                  style: const TextStyle(color: AppColors.muted, fontSize: 11),
                ),
              ],
            ),
          ),
          Text(
            transaction.amount,
            style: TextStyle(
              color: transaction.isCredit ? AppColors.emerald : AppColors.clay,
              fontWeight: FontWeight.w900,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
