import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/animated_tap.dart';
import '../../../../shared/widgets/broker_page.dart';
import '../../../../shared/widgets/broker_section_header.dart';
import '../../../../shared/widgets/status_pill.dart';
import '../../data/repositories/projects_repository.dart';
import '../../data/repositories/resale_repository.dart';
import '../../domain/entities/project.dart';
import '../../domain/entities/resale_unit.dart';
import 'resale_details_page.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  int activeTab = 0; // 0 for Resale Units, 1 for Developer Projects
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final isAr = Get.locale?.languageCode == 'ar';
    final projects = const ProjectsRepository().featuredProjects();
    final resaleUnits = const ResaleRepository().featuredResaleUnits();

    // Filter logic
    final filteredResale = resaleUnits.where((unit) {
      if (searchQuery.isEmpty) return true;
      final q = searchQuery.toLowerCase();
      return unit.title.toLowerCase().contains(q) ||
          unit.projectName.toLowerCase().contains(q) ||
          unit.location.toLowerCase().contains(q) ||
          unit.developer.toLowerCase().contains(q);
    }).toList();

    final filteredProjects = projects.where((project) {
      if (searchQuery.isEmpty) return true;
      final q = searchQuery.toLowerCase();
      return project.name.toLowerCase().contains(q) ||
          project.location.toLowerCase().contains(q) ||
          project.developer.toLowerCase().contains(q);
    }).toList();

    return BrokerPage(
      children: [
        _PageTitle(
          title: isAr ? 'استكشف السوق' : 'Marketplace Explore',
          subtitle: isAr
              ? 'تصفح الفرص الحصرية وعمولات إغلاق الصفقات'
              : 'Browse exclusive opportunities & closing payouts',
        ),

        // Search bar
        TextField(
          onChanged: (val) {
            setState(() {
              searchQuery = val;
            });
          },
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search_rounded, color: AppColors.gold),
            hintText: activeTab == 0
                ? (isAr ? 'ابحث بالكمبوند، المنطقة أو المطور...' : 'Search compound, area, developer...')
                : (isAr ? 'ابحث عن مشاريع مطورين...' : 'Search developer projects...'),
          ),
        ),

        // Tabs Selector Row
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: AppColors.ink.withValues(alpha: 0.04),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Expanded(
                child: _TabButton(
                  label: isAr ? 'فرص التنازل العقاري 💎' : 'Resale Transfers 💎',
                  isActive: activeTab == 0,
                  onTap: () => setState(() => activeTab = 0),
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: _TabButton(
                  label: isAr ? 'مشاريع المطورين 🏢' : 'Developer Launches 🏢',
                  isActive: activeTab == 1,
                  onTap: () => setState(() => activeTab = 1),
                ),
              ),
            ],
          ),
        ),

        BrokerSectionHeader(
          title: activeTab == 0
              ? (isAr ? 'الفرص المتاحة للتسويق (${filteredResale.length})' : 'Available Resales (${filteredResale.length})')
              : (isAr ? 'إطلاقات المطورين (${filteredProjects.length})' : 'Developer Projects (${filteredProjects.length})'),
        ),

        // Tab Content Display
        if (activeTab == 0) ...[
          if (filteredResale.isEmpty)
            _EmptyState(isAr: isAr)
          else
            ...filteredResale.map((unit) => _ResaleOpportunityCard(unit: unit, isAr: isAr)),
        ] else ...[
          if (filteredProjects.isEmpty)
            _EmptyState(isAr: isAr)
          else
            ...filteredProjects.map((project) => _ProjectCard(project: project)),
        ],
      ],
    );
  }
}

class _PageTitle extends StatelessWidget {
  const _PageTitle({required this.title, required this.subtitle});

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

class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedTap(
      onTap: onTap,
      child: Container(
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isActive ? AppColors.paper : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  )
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? AppColors.gold : AppColors.muted,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class _ResaleOpportunityCard extends StatelessWidget {
  const _ResaleOpportunityCard({required this.unit, required this.isAr});

  final ResaleUnit unit;
  final bool isAr;

  @override
  Widget build(BuildContext context) {
    return AnimatedTap(
      onTap: () {
        Get.to(() => ResaleDetailsPage(unit: unit));
      },
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.paper,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const StatusPill(label: 'مراجعة موثقة 🔒', color: AppColors.emerald),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        unit.title,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        '${unit.projectName} • ${unit.developer}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios_rounded, color: AppColors.gold, size: 16),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            // Financial specifications
            Row(
              children: [
                Expanded(
                  child: _Fact(
                    label: isAr ? 'المطلوب كاش' : 'Cash Req',
                    value: unit.cashRequired,
                    isGold: true,
                  ),
                ),
                Expanded(
                  child: _Fact(
                    label: isAr ? 'مكسب المشتري' : 'Savings',
                    value: unit.marketSavings,
                    isGold: false,
                  ),
                ),
                Expanded(
                  child: _Fact(
                    label: isAr ? 'عمولة البروكر' : 'Your Payout',
                    value: unit.commission.split(' ').first, // Show numeric value
                    isGold: false,
                    isEmerald: true,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ProjectCard extends StatelessWidget {
  const _ProjectCard({required this.project});

  final Project project;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.paper,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StatusPill(label: project.badge, color: AppColors.gold),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      project.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      '${project.developer} • ${project.location}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios_rounded, color: AppColors.muted, size: 16),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: _Fact(
                  label: 'explore.price'.tr,
                  value: project.startingPrice,
                ),
              ),
              Expanded(
                child: _Fact(
                  label: 'explore.down_payment'.tr,
                  value: project.downPayment,
                ),
              ),
              Expanded(
                child: _Fact(
                  label: 'explore.commission'.tr,
                  value: project.commission,
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

class _Fact extends StatelessWidget {
  const _Fact({
    required this.label,
    required this.value,
    this.isGold = false,
    this.isEmerald = false,
  });

  final String label;
  final String value;
  final bool isGold;
  final bool isEmerald;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: TextStyle(
            color: isGold
                ? AppColors.gold
                : isEmerald
                    ? AppColors.emerald
                    : AppColors.ink,
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

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.isAr});

  final bool isAr;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      alignment: Alignment.center,
      child: Column(
        children: [
          const Icon(Icons.search_off_rounded, size: 48, color: AppColors.muted),
          const SizedBox(height: 8),
          Text(
            isAr ? 'لا توجد نتائج مطابقة لبحثك' : 'No matching results found',
            style: const TextStyle(color: AppColors.muted, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
