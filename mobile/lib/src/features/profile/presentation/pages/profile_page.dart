import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/controllers/locale_controller.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/broker_page.dart';
import '../../../../shared/widgets/broker_section_header.dart';
import '../../../../shared/widgets/status_pill.dart';
import 'safqa_comparison_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final localeController = Get.find<LocaleController>();
    final isAr = localeController.isArabic;

    return BrokerPage(
      children: [
        _ProfileHeader(localeController: localeController),
        BrokerSectionHeader(title: 'profile.tools'.tr),
        _ToolTile(
          icon: Icons.bar_chart_rounded,
          title: isAr ? 'دليل صفقة vs ريسيل تقليدي' : 'Safqa vs Traditional Resale',
          subtitle: isAr ? 'مقارنة شاملة لعمولات وسرعة إغلاق الصفقات' : 'Detailed speed and commission comparison',
          onTap: () => Get.to(() => const SafqaComparisonPage()),
        ),
        _ToolTile(
          icon: Icons.campaign_rounded,
          title: 'profile.marketing'.tr,
          subtitle: 'profile.marketing_copy'.tr,
          onTap: () {
            Get.snackbar(
              isAr ? 'مركز التسويق' : 'Marketing Center',
              isAr ? 'تم نسخ كود إحالة البروكر الخاص بك لتسويق المواد.' : 'Your broker marketing referral code copied.',
            );
          },
        ),
        _ToolTile(
          icon: Icons.auto_awesome_rounded,
          title: 'profile.ai'.tr,
          subtitle: 'profile.ai_copy'.tr,
          onTap: () {
            Get.snackbar(
              isAr ? 'مساعد صفقة الذكي' : 'Safqa AI Assistant',
              isAr ? 'اقتراحات إغلاق الصفقات والردود التلقائية قيد التحميل...' : 'AI suggestions loading...',
            );
          },
        ),
        _ToolTile(
          icon: Icons.support_agent_rounded,
          title: 'profile.support'.tr,
          subtitle: 'profile.support_copy'.tr,
          onTap: () {
            Get.snackbar(
              isAr ? 'الدعم الفني والنزاعات' : 'Support Desk',
              isAr ? 'افتح تذكرة نزاع للتواصل المباشر مع لجنة الإغلاق.' : 'Ticket desk is open for direct closing committee support.',
            );
          },
        ),
        BrokerSectionHeader(title: 'profile.account'.tr),
        _ToolTile(
          icon: Icons.verified_user_rounded,
          title: 'profile.kyc'.tr,
          subtitle: 'profile.kyc_copy'.tr,
          onTap: () {
            Get.snackbar(
              isAr ? 'حالة التحقق والمستندات' : 'Verification Status',
              isAr ? 'مستندات البروكر المعتمد صحيحة وموثقة بالكامل.' : 'Your certified broker documents are verified.',
            );
          },
        ),
      ],
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.localeController});

  final LocaleController localeController;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.paper,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 28,
                backgroundColor: AppColors.ink,
                child: Icon(Icons.person_rounded, color: AppColors.gold),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'home.broker_name'.tr,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    StatusPill(
                      label: 'profile.verified'.tr,
                      color: AppColors.emerald,
                    ),
                  ],
                ),
              ),
              IconButton.filledTonal(
                onPressed: localeController.toggleLocale,
                icon: Text(
                  localeController.isArabic ? 'EN' : 'ع',
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'profile.referral'.tr,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'SAFQA-OSAMA-24',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ],
      ),
    );
  }
}

class _ToolTile extends StatelessWidget {
  const _ToolTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.paper,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.gold),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleMedium),
                  Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: AppColors.muted),
          ],
        ),
      ),
    );
  }
}
