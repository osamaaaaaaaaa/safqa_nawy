import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/controllers/locale_controller.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/animated_tap.dart';
import '../../../../shared/widgets/broker_page.dart';
import '../../../../shared/widgets/broker_section_header.dart';
import '../../../../shared/widgets/status_pill.dart';
import '../../../deals/data/repositories/deals_repository.dart';
import '../../../explore/data/repositories/projects_repository.dart';
import '../../../leads/data/repositories/leads_repository.dart';
import '../../../transfer/presentation/pages/create_resale_page.dart';
import '../../../profile/presentation/pages/safqa_comparison_page.dart';

class BrokerHomePage extends StatelessWidget {
  const BrokerHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final localeController = Get.find<LocaleController>();
    final projects = const ProjectsRepository().featuredProjects();
    final leads = const LeadsRepository().activeLeads();
    final deals = const DealsRepository().activeDeals();
    final isAr = Get.locale?.languageCode == 'ar';

    return BrokerPage(
      children: [
        _TopBar(localeController: localeController),
        const SizedBox(height: AppSpacing.xs),
        
        // Luxury Hero Panel with Amber Gradient Accent
        _HeroPanel(activeDeals: deals.length, activeLeads: leads.length, isAr: isAr),
        
        // Premium Metrics Grid
        Row(
          children: [
            Expanded(
              child: _PremiumMetricCard(
                label: 'home.metric.pending'.tr,
                value: 'EGP 254K',
                icon: Icons.hourglass_top_rounded,
                color: AppColors.gold,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: _PremiumMetricCard(
                label: 'home.metric.closed'.tr,
                value: '9',
                icon: Icons.verified_rounded,
                color: AppColors.emerald,
              ),
            ),
          ],
        ),

        // Quick Actions with architectural design
        Row(
          children: [
            Expanded(
              child: _QuickActionCard(
                label: isAr ? 'إدراج وحدة للبيع' : 'List Unit for Sale',
                subtitle: isAr ? 'أضف فرصة تنازل جديدة' : 'Add resale transfer',
                icon: Icons.add_circle_rounded,
                color: AppColors.gold,
                onTap: () => Get.to(() => const CreateResalePage()),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: _QuickActionCard(
                label: isAr ? 'مزايا ومقارنة صفقة' : 'Why Safqa?',
                subtitle: isAr ? 'دليل صفقة vs التقليدي' : 'Safqa vs Traditional',
                icon: Icons.bar_chart_rounded,
                color: AppColors.emerald,
                onTap: () => Get.to(() => const SafqaComparisonPage()),
              ),
            ),
          ],
        ),

        BrokerSectionHeader(
          title: 'home.featured'.tr,
          action: 'common.view_all'.tr,
        ),
        
        ...projects.take(2).map(
              (project) => _ProjectTile(
                title: project.name,
                subtitle: '${project.location} • ${project.developer}',
                trailing: project.commission,
                badge: project.badge,
              ),
            ),
            
        BrokerSectionHeader(
          title: 'home.pipeline'.tr,
          action: 'home.open_crm'.tr,
        ),
        
        _PipelinePreview(
          leadName: leads.first.name,
          dealName: deals.first.unit,
          isAr: isAr,
        ),
      ],
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.localeController});

  final LocaleController localeController;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Row(
        children: [
          Container(
            height: 52,
            width: 52,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.ink, Color(0xFF1E293B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppColors.ink.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ],
              border: Border.all(color: Colors.white.withValues(alpha: 0.1), width: 1.5),
            ),
            child: const Icon(
              Icons.real_estate_agent_rounded,
              color: AppColors.gold,
              size: 26,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'home.greeting'.tr,
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'home.broker_name'.tr,
                  style: const TextStyle(
                    color: AppColors.ink,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.3,
                  ),
                ),
              ],
            ),
          ),
          IconButton.filledTonal(
            style: IconButton.styleFrom(
              backgroundColor: AppColors.gold.withValues(alpha: 0.1),
              foregroundColor: AppColors.gold,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            onPressed: localeController.toggleLocale,
            icon: Text(
              localeController.isArabic ? 'EN' : 'ع',
              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroPanel extends StatelessWidget {
  const _HeroPanel({required this.activeDeals, required this.activeLeads, required this.isAr});

  final int activeDeals;
  final int activeLeads;
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
            color: AppColors.ink.withValues(alpha: .25),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
        border: Border.all(color: Colors.white.withValues(alpha: 0.08), width: 1.5),
      ),
      child: Stack(
        children: [
          // Background blueprint elements
          Positioned(
            right: isAr ? null : -20,
            left: isAr ? -20 : null,
            top: -20,
            child: Opacity(
              opacity: 0.03,
              child: Icon(Icons.architecture_rounded, size: 140, color: Colors.white),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.gold.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.gold.withValues(alpha: 0.3)),
                ),
                child: Text(
                  'home.hero.badge'.tr,
                  style: const TextStyle(
                    color: AppColors.gold,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'home.hero.title'.tr,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'home.hero.subtitle'.tr,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Row(
                children: [
                  Expanded(
                    child: _HeroMetric(
                      value: '$activeLeads',
                      label: 'home.hero.leads'.tr,
                      icon: Icons.people_outline_rounded,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: _HeroMetric(
                      value: '$activeDeals',
                      label: 'home.hero.deals'.tr,
                      icon: Icons.article_outlined,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroMetric extends StatelessWidget {
  const _HeroMetric({required this.value, required this.label, required this.icon});

  final String value;
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .04),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: .08)),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.gold, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  label,
                  style: const TextStyle(color: Colors.white60, fontSize: 10),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PremiumMetricCard extends StatelessWidget {
  const _PremiumMetricCard({
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
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.paper,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const Text(
                '•••',
                style: TextStyle(color: AppColors.muted, fontSize: 12),
              )
            ],
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.ink,
              fontSize: 18,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.muted,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  const _QuickActionCard({
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String label;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedTap(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.paper,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(height: 16),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.ink,
                fontWeight: FontWeight.w900,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                color: AppColors.muted,
                fontSize: 10,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _ProjectTile extends StatelessWidget {
  const _ProjectTile({
    required this.title,
    required this.subtitle,
    required this.trailing,
    required this.badge,
  });

  final String title;
  final String subtitle;
  final String trailing;
  final String badge;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.paper,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.01),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 56,
            width: 56,
            decoration: BoxDecoration(
              color: AppColors.gold.withValues(alpha: .08),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.gold.withValues(alpha: 0.15)),
            ),
            child: const Icon(Icons.apartment_rounded, color: AppColors.gold, size: 26),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.ink,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 8),
                StatusPill(label: badge, color: AppColors.gold),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                trailing,
                style: const TextStyle(
                  color: AppColors.emerald,
                  fontWeight: FontWeight.w900,
                  fontSize: 15,
                ),
              ),
              const Text(
                'عمولة',
                style: TextStyle(color: AppColors.muted, fontSize: 10, fontWeight: FontWeight.bold),
              )
            ],
          )
        ],
      ),
    );
  }
}

class _PipelinePreview extends StatelessWidget {
  const _PipelinePreview({required this.leadName, required this.dealName, required this.isAr});

  final String leadName;
  final String dealName;
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
          _PipelineRow(
            label: 'home.pipeline.lead'.tr,
            value: leadName,
            icon: Icons.shield_rounded,
            color: AppColors.gold,
            isAr: isAr,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1),
          ),
          _PipelineRow(
            label: 'home.pipeline.deal'.tr,
            value: dealName,
            icon: Icons.edit_document,
            color: AppColors.emerald,
            isAr: isAr,
          ),
        ],
      ),
    );
  }
}

class _PipelineRow extends StatelessWidget {
  const _PipelineRow({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.isAr,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final bool isAr;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(color: AppColors.muted, fontSize: 10, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  color: AppColors.ink,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Icon(
          isAr ? Icons.chevron_left_rounded : Icons.chevron_right_rounded,
          color: AppColors.muted,
          size: 16,
        )
      ],
    );
  }
}
