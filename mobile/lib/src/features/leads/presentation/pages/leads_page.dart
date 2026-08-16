import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/broker_page.dart';
import '../../../../shared/widgets/broker_section_header.dart';
import '../../../../shared/widgets/status_pill.dart';
import '../../data/repositories/leads_repository.dart';
import '../../domain/entities/lead.dart';

class LeadsPage extends StatelessWidget {
  const LeadsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final leads = const LeadsRepository().activeLeads();
    final isAr = Get.locale?.languageCode == 'ar';

    return BrokerPage(
      children: [
        _Header(title: 'leads.title'.tr, subtitle: 'leads.subtitle'.tr),
        
        // Protection alert panel in dark slate luxury styling
        _ProtectionCard(isAr: isAr),
        
        BrokerSectionHeader(
          title: 'leads.active'.tr,
          action: 'common.add'.tr,
        ),
        
        ...leads.map((lead) => _LeadCard(lead: lead, isAr: isAr)),
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

class _ProtectionCard extends StatelessWidget {
  const _ProtectionCard({required this.isAr});

  final bool isAr;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.ink, Color(0xFF1E293B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.ink.withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: AppColors.gold.withValues(alpha: .15),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.gold.withValues(alpha: 0.3)),
            ),
            child: const Icon(Icons.shield_rounded, color: AppColors.gold, size: 26),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'leads.protection.title'.tr,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'leads.protection.copy'.tr,
                  style: const TextStyle(
                    color: Colors.white70,
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

class _LeadCard extends StatelessWidget {
  const _LeadCard({required this.lead, required this.isAr});

  final Lead lead;
  final bool isAr;

  @override
  Widget build(BuildContext context) {
    final status = switch (lead.status) {
      LeadStatus.protected => ('leads.status.protected'.tr, AppColors.emerald),
      LeadStatus.followUp => ('leads.status.follow_up'.tr, AppColors.gold),
      LeadStatus.siteVisit => ('leads.status.site_visit'.tr, AppColors.navy),
      LeadStatus.expired => ('leads.status.expired'.tr, AppColors.clay),
    };

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.paper,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.01),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Stack(
        children: [
          // Visual status indicator line on the side (RTL vs LTR)
          Positioned(
            top: 0,
            bottom: 0,
            left: isAr ? null : 0,
            right: isAr ? 0 : null,
            child: Container(
              width: 5,
              color: status.$2,
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              isAr ? 16 : 24,
              20,
              isAr ? 24 : 16,
              20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      lead.name,
                      style: const TextStyle(
                        color: AppColors.ink,
                        fontWeight: FontWeight.w900,
                        fontSize: 15,
                      ),
                    ),
                    StatusPill(label: status.$1, color: status.$2),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.apartment_rounded, color: AppColors.muted, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      lead.project,
                      style: const TextStyle(color: AppColors.muted, fontSize: 12),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Divider(height: 1),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'leads.budget'.tr,
                            style: const TextStyle(color: AppColors.muted, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            lead.budget,
                            style: const TextStyle(
                              color: AppColors.ink,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'leads.ends'.tr,
                          style: const TextStyle(color: AppColors.muted, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          lead.protectionEndsIn,
                          style: const TextStyle(
                            color: AppColors.gold,
                            fontWeight: FontWeight.w900,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
