import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/animated_tap.dart';
import '../../../../shared/widgets/broker_page.dart';
import '../../../../shared/widgets/status_pill.dart';

class SharesPage extends StatelessWidget {
  const SharesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isAr = Get.locale?.languageCode == 'ar';

    final shareOffers = [
      {
        'title': isAr ? 'عيادة طبية - إيستاون القاهرة الجديدة' : 'Medical Clinic - Eastown New Cairo',
        'developer': 'Sodic',
        'minShare': 'EGP 5,000 / month',
        'minShareAr': '5,000 ج.م / شهر',
        'roi': '16.5% ROI',
        'progress': 0.74,
        'funded': '74%',
      },
      {
        'title': isAr ? 'مكتب إداري - قطاع التسعين التجمع الخامس' : 'Administrative Office - Sector 90',
        'developer': 'Ora Developers',
        'minShare': 'EGP 8,000 / month',
        'minShareAr': '8,000 ج.م / شهر',
        'roi': '18.2% ROI',
        'progress': 0.42,
        'funded': '42%',
      },
      {
        'title': isAr ? 'شاليه فندقي - سول الساحل الشمالي' : 'Hotel Chalet - Soul North Coast',
        'developer': 'Emaar',
        'minShare': 'EGP 12,000 / month',
        'minShareAr': '12,000 ج.م / شهر',
        'roi': '14.8% ROI',
        'progress': 0.88,
        'funded': '88%',
      }
    ];

    return BrokerPage(
      children: [
        // Header
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isAr ? 'أسهم صفقة العقارية' : 'Safqa Shares',
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w900,
                    letterSpacing: -1,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              isAr
                  ? 'استثمار عقاري مجزأ بحد أدنى يبدأ من 5 آلاف جنيه شهرياً'
                  : 'Fractional property investment with as little as EGP 5k monthly',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),

        const SizedBox(height: AppSpacing.sm),

        // Shares catalog
        ...shareOffers.map((offer) {
          final progress = offer['progress'] as double;
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.paper,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    StatusPill(
                      label: offer['developer'] as String,
                      color: AppColors.gold,
                    ),
                    Text(
                      offer['roi'] as String,
                      style: const TextStyle(
                        color: AppColors.emerald,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  offer['title'] as String,
                  style: const TextStyle(
                    color: AppColors.ink,
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 16),

                // Progress Bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isAr ? 'نسبة الاكتمال' : 'Funding Progress',
                      style: const TextStyle(color: AppColors.muted, fontSize: 10),
                    ),
                    Text(
                      offer['funded'] as String,
                      style: const TextStyle(color: AppColors.ink, fontWeight: FontWeight.bold, fontSize: 10),
                    )
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: AppColors.border,
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.gold),
                    minHeight: 6,
                  ),
                ),

                const SizedBox(height: 16),
                const Divider(height: 1),
                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isAr ? 'الحد الأدنى للمشاركة' : 'Minimum Share',
                          style: const TextStyle(color: AppColors.muted, fontSize: 10),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          isAr ? (offer['minShareAr'] as String) : (offer['minShare'] as String),
                          style: const TextStyle(
                            color: AppColors.ink,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        )
                      ],
                    ),
                    AnimatedTap(
                      onTap: () {
                        Get.snackbar(
                          isAr ? 'استثمار الأسهم' : 'Shares Investment',
                          isAr ? 'تم إرسال طلب الاهتمام بالأسهم للمراجعة.' : 'Share investment request sent for review.',
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: AppColors.gold,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          isAr ? 'استثمر الآن' : 'Invest Now',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          );
        }),
      ],
    );
  }
}
