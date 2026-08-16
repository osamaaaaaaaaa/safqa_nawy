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
        // Luxury welcome card & Ticket Stub referral code
        _ProfileHeader(localeController: localeController, isAr: isAr),
        
        BrokerSectionHeader(title: 'profile.tools'.tr),
        
        _PremiumToolTile(
          icon: Icons.bar_chart_rounded,
          title: isAr ? 'دليل صفقة vs ريسيل تقليدي' : 'Safqa vs Traditional Resale',
          subtitle: isAr ? 'مقارنة شاملة لعمولات وسرعة إغلاق الصفقات' : 'Detailed speed and commission comparison',
          color: AppColors.gold,
          onTap: () => Get.to(() => const SafqaComparisonPage()),
        ),
        _PremiumToolTile(
          icon: Icons.campaign_rounded,
          title: 'profile.marketing'.tr,
          subtitle: 'profile.marketing_copy'.tr,
          color: AppColors.gold,
          onTap: () {
            Get.snackbar(
              isAr ? 'مركز التسويق' : 'Marketing Center',
              isAr ? 'تم نسخ كود إحالة البروكر الخاص بك لتسويق المواد.' : 'Your broker marketing referral code copied.',
            );
          },
        ),
        _PremiumToolTile(
          icon: Icons.auto_awesome_rounded,
          title: 'profile.ai'.tr,
          subtitle: 'profile.ai_copy'.tr,
          color: AppColors.emerald,
          onTap: () {
            Get.snackbar(
              isAr ? 'مساعد صفقة الذكي' : 'Safqa AI Assistant',
              isAr ? 'اقتراحات إغلاق الصفقات والردود التلقائية قيد التحميل...' : 'AI suggestions loading...',
            );
          },
        ),
        _PremiumToolTile(
          icon: Icons.support_agent_rounded,
          title: 'profile.support'.tr,
          subtitle: 'profile.support_copy'.tr,
          color: AppColors.clay,
          onTap: () {
            Get.snackbar(
              isAr ? 'الدعم الفني والنزاعات' : 'Support Desk',
              isAr ? 'افتح تذكرة نزاع للتواصل المباشر مع لجنة الإغلاق.' : 'Ticket desk is open for direct closing committee support.',
            );
          },
        ),
        
        BrokerSectionHeader(title: 'profile.account'.tr),
        
        _PremiumToolTile(
          icon: Icons.verified_user_rounded,
          title: 'profile.kyc'.tr,
          subtitle: 'profile.kyc_copy'.tr,
          color: AppColors.emerald,
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
  const _ProfileHeader({required this.localeController, required this.isAr});

  final LocaleController localeController;
  final bool isAr;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.paper,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.01),
            blurRadius: 12,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 56,
                width: 56,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.ink, Color(0xFF1E293B)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.gold, width: 1.5),
                ),
                child: const Icon(Icons.person_rounded, color: AppColors.gold, size: 28),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'home.broker_name'.tr,
                      style: const TextStyle(
                        color: AppColors.ink,
                        fontWeight: FontWeight.w900,
                        fontSize: 15,
                      ),
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
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.gold.withValues(alpha: 0.1),
                  foregroundColor: AppColors.gold,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: localeController.toggleLocale,
                icon: Text(
                  localeController.isArabic ? 'EN' : 'ع',
                  style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Referral Ticket Stub visual representation
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.ink.withValues(alpha: 0.03),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'profile.referral'.tr,
                      style: const TextStyle(color: AppColors.muted, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'SAFQA-OSAMA-24',
                      style: TextStyle(
                        color: AppColors.ink,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.copy_rounded, color: AppColors.gold),
                  onPressed: () {
                    Get.snackbar(
                      isAr ? 'تم النسخ' : 'Copied',
                      isAr ? 'تم نسخ كود الإحالة لمشاركته مع وسطاء آخرين.' : 'Referral code copied successfully.',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PremiumToolTile extends StatelessWidget {
  const _PremiumToolTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 20),
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
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(color: AppColors.muted, fontSize: 11),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, color: AppColors.muted, size: 14),
          ],
        ),
      ),
    );
  }
}
