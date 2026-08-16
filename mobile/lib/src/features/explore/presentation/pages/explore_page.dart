import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/controllers/settings_controller.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/animated_tap.dart';
import '../../../../shared/widgets/broker_page.dart';
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
  int activeTab = 0; // 0 for Resale, 1 for Projects
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final isAr = Get.locale?.languageCode == 'ar';
    final projects = const ProjectsRepository().featuredProjects();
    final resaleUnits = const ResaleRepository().featuredResaleUnits();
    final settingsController = Get.find<SettingsController>();

    final filteredResale = resaleUnits.where((unit) {
      if (searchQuery.isEmpty) return true;
      final q = searchQuery.toLowerCase();
      return unit.title.toLowerCase().contains(q) ||
          unit.projectName.toLowerCase().contains(q) ||
          unit.developer.toLowerCase().contains(q);
    }).toList();

    final filteredProjects = projects.where((p) {
      if (searchQuery.isEmpty) return true;
      final q = searchQuery.toLowerCase();
      return p.name.toLowerCase().contains(q) || p.developer.toLowerCase().contains(q);
    }).toList();

    return BrokerPage(
      children: [
        _HeaderSection(isAr: isAr),

        // Custom Search Bar
        TextField(
          onChanged: (val) => setState(() => searchQuery = val),
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search_rounded, color: AppColors.gold),
            hintText: isAr ? 'ابحث بالمنطقة، الكمبوند أو المطور...' : 'Search area, compound, developer...',
          ),
        ),

        // Tabs Selector Row (Capsule Navigation)
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: AppColors.ink.withValues(alpha: 0.04),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Expanded(
                child: _TabCapsule(
                  label: isAr ? 'فرص التنازل' : 'Resale Opportunities',
                  isActive: activeTab == 0,
                  onTap: () => setState(() => activeTab = 0),
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: _TabCapsule(
                  label: isAr ? 'إطلاقات المطورين' : 'Developer Launches',
                  isActive: activeTab == 1,
                  onTap: () => setState(() => activeTab = 1),
                ),
              ),
            ],
          ),
        ),

        // Dual-Column Financial Grid (Obx bound for hiding commissions dynamically)
        Obx(
          () {
            final hidePayout = settingsController.clientMode.value;

            if (activeTab == 0) {
              if (filteredResale.isEmpty) {
                return _EmptyState(isAr: isAr);
              }
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.74,
                ),
                itemCount: filteredResale.length,
                itemBuilder: (context, index) {
                  return _ResaleGridCard(
                    unit: filteredResale[index],
                    isAr: isAr,
                    hidePayout: hidePayout,
                  );
                },
              );
            } else {
              if (filteredProjects.isEmpty) {
                return _EmptyState(isAr: isAr);
              }
              return Column(
                children: filteredProjects.map((p) => _ProjectRowCard(
                  project: p,
                  isAr: isAr,
                  hidePayout: hidePayout,
                )).toList(),
              );
            }
          },
        ),
      ],
    );
  }
}

class _HeaderSection extends StatelessWidget {
  const _HeaderSection({required this.isAr});

  final bool isAr;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isAr ? 'كتالوج العقود والفرص' : 'Opportunities Directory',
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.w900,
                letterSpacing: -1,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          isAr ? 'تصفح وقارن صفقات التنازل العقاري الحصرية للعملاء' : 'Browse and match exclusive property resale transfers',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}

class _TabCapsule extends StatelessWidget {
  const _TabCapsule({required this.label, required this.isActive, required this.onTap});

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
          color: isActive ? AppColors.gold : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : AppColors.muted,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}

class _ResaleGridCard extends StatelessWidget {
  const _ResaleGridCard({
    required this.unit,
    required this.isAr,
    required this.hidePayout,
  });

  final ResaleUnit unit;
  final bool isAr;
  final bool hidePayout;

  @override
  Widget build(BuildContext context) {
    return AnimatedTap(
      onTap: () => Get.to(() => ResaleDetailsPage(unit: unit)),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.paper,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 4,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.ink, Color(0xFF1E293B)],
                  ),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        StatusPill(label: unit.unitCode, color: AppColors.gold),
                        const Icon(Icons.verified_rounded, color: AppColors.emerald, size: 16),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          unit.projectName,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          unit.developer,
                          style: const TextStyle(color: Colors.white70, fontSize: 10),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      unit.title,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: AppColors.ink),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      children: [
                        const Icon(Icons.hotel_rounded, color: AppColors.gold, size: 12),
                        const SizedBox(width: 3),
                        Text('${unit.bedrooms}', style: const TextStyle(fontSize: 10, color: AppColors.muted)),
                        const SizedBox(width: 8),
                        const Icon(Icons.square_foot_rounded, color: AppColors.gold, size: 12),
                        const SizedBox(width: 3),
                        Text('${unit.area.toInt()}m²', style: const TextStyle(fontSize: 10, color: AppColors.muted)),
                      ],
                    ),

                    if (!hidePayout)
                      Text(
                        unit.commission,
                        style: const TextStyle(color: AppColors.emerald, fontWeight: FontWeight.bold, fontSize: 10),
                      ),

                    const Divider(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(isAr ? 'الكاش المطلوبة' : 'Cash Required', style: const TextStyle(color: AppColors.muted, fontSize: 8)),
                            Text(
                              unit.cashRequired.split(' ').first,
                              style: const TextStyle(color: AppColors.gold, fontWeight: FontWeight.bold, fontSize: 11),
                            )
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(isAr ? 'الوفر الفوري' : 'Savings', style: const TextStyle(color: AppColors.muted, fontSize: 8)),
                            Text(
                              unit.marketSavings.split(' ').first,
                              style: const TextStyle(color: AppColors.emerald, fontWeight: FontWeight.bold, fontSize: 11),
                            )
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProjectRowCard extends StatelessWidget {
  const _ProjectRowCard({
    required this.project,
    required this.isAr,
    required this.hidePayout,
  });

  final Project project;
  final bool isAr;
  final bool hidePayout;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.paper,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            height: 52,
            width: 52,
            decoration: BoxDecoration(
              color: AppColors.gold.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.apartment_rounded, color: AppColors.gold, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StatusPill(label: project.badge, color: AppColors.gold),
                const SizedBox(height: 4),
                Text(
                  project.name,
                  style: const TextStyle(color: AppColors.ink, fontWeight: FontWeight.bold, fontSize: 13),
                ),
                Text(
                  '${project.developer} • ${project.location}',
                  style: const TextStyle(color: AppColors.muted, fontSize: 11),
                ),
              ],
            ),
          ),
          if (!hidePayout)
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  project.commission,
                  style: const TextStyle(color: AppColors.emerald, fontWeight: FontWeight.bold, fontSize: 14),
                ),
                Text(
                  isAr ? 'عمولة التوزيع' : 'Commission',
                  style: const TextStyle(color: AppColors.muted, fontSize: 9),
                ),
              ],
            )
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.isAr});

  final bool isAr;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40),
      alignment: Alignment.center,
      child: Column(
        children: [
          const Icon(Icons.search_off_rounded, size: 40, color: AppColors.muted),
          const SizedBox(height: 8),
          Text(
            isAr ? 'لا توجد فرص مطابقة لبحثك' : 'No matching opportunities found',
            style: const TextStyle(color: AppColors.muted, fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
