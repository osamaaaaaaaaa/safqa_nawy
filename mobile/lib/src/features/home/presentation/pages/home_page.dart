import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/controllers/locale_controller.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../features/broker_contracts/data/repositories/broker_contracts_repository.dart';
import '../../../../features/broker_contracts/presentation/widgets/broker_contract_card.dart';
import '../../../../features/transfer/presentation/widgets/transfer_timeline.dart';
import '../../../../shared/widgets/primary_action_button.dart';
import '../../../../shared/widgets/safqa_bottom_navigation.dart';
import '../../../../shared/widgets/section_header.dart';
import '../widgets/path_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final contracts = const BrokerContractsRepository().activeContracts();

    return Scaffold(
      bottomNavigationBar: const SafqaBottomNavigation(),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 26),
              sliver: SliverList.list(
                children: [
                  const _Header(),
                  const SizedBox(height: AppSpacing.xl),
                  const _HeroPanel(),
                  const SizedBox(height: AppSpacing.xl),
                  SectionHeader(title: 'home.paths.title'.tr),
                  const SizedBox(height: AppSpacing.md),
                  PathCard(
                    icon: Icons.upload_file_rounded,
                    title: 'home.paths.seller.title'.tr,
                    body: 'home.paths.seller.body'.tr,
                    color: AppColors.clay,
                  ),
                  PathCard(
                    icon: Icons.fact_check_rounded,
                    title: 'home.paths.buyer.title'.tr,
                    body: 'home.paths.buyer.body'.tr,
                    color: AppColors.emerald,
                  ),
                  PathCard(
                    icon: Icons.handshake_rounded,
                    title: 'home.paths.broker.title'.tr,
                    body: 'home.paths.broker.body'.tr,
                    color: AppColors.gold,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  SectionHeader(
                    title: 'home.deals.title'.tr,
                    subtitle: 'home.deals.subtitle'.tr,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  SizedBox(
                    height: 264,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: contracts.length,
                      separatorBuilder: (_, _) =>
                          const SizedBox(width: AppSpacing.md),
                      itemBuilder: (context, index) {
                        return BrokerContractCard(contract: contracts[index]);
                      },
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  SectionHeader(
                    title: 'home.transfer.title'.tr,
                    subtitle: 'home.transfer.subtitle'.tr,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  const TransferTimeline(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final localeController = Get.find<LocaleController>();

    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.ink,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(Icons.layers_rounded, color: AppColors.paper),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'app.name'.tr,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                'app.tagline'.tr,
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        Obx(
          () => IconButton.filledTonal(
            onPressed: localeController.toggleLocale,
            tooltip: localeController.languageButtonLabel,
            icon: Text(
              localeController.languageButtonLabel,
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
        ),
      ],
    );
  }
}

class _HeroPanel extends StatelessWidget {
  const _HeroPanel();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.paper,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.ink.withValues(alpha: .07),
            blurRadius: 30,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.gold.withValues(alpha: .13),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              'app.tagline'.tr,
              style: theme.titleMedium?.copyWith(
                color: AppColors.navy,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text('home.hero.title'.tr, style: theme.displaySmall),
          const SizedBox(height: AppSpacing.md),
          Text('home.hero.body'.tr, style: theme.bodyMedium),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: PrimaryActionButton(
                  label: 'home.hero.primaryAction'.tr,
                  onPressed: () {},
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: PrimaryActionButton(
                  label: 'home.hero.secondaryAction'.tr,
                  onPressed: () {},
                  isOutlined: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          const _HeroStats(),
        ],
      ),
    );
  }
}

class _HeroStats extends StatelessWidget {
  const _HeroStats();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatItem(
            value: '120+',
            label: 'home.stats.verified'.tr,
          ),
        ),
        Expanded(
          child: _StatItem(
            value: '9d',
            label: 'home.stats.transfer'.tr,
          ),
        ),
        Expanded(
          child: _StatItem(
            value: 'EGP 1.8M',
            label: 'home.stats.brokers'.tr,
          ),
        ),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.value,
    required this.label,
  });

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.emerald,
              ),
        ),
        const SizedBox(height: 3),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 12),
        ),
      ],
    );
  }
}
