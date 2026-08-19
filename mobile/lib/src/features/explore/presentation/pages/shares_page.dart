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
        'image': 'https://images.unsplash.com/photo-1629909613654-28e377c37b09?w=600&auto=format&fit=crop&q=80',
      },
      {
        'title': isAr ? 'مكتب إداري - قطاع التسعين التجمع الخامس' : 'Administrative Office - Sector 90',
        'developer': 'Ora Developers',
        'minShare': 'EGP 8,000 / month',
        'minShareAr': '8,000 ج.م / شهر',
        'roi': '18.2% ROI',
        'progress': 0.42,
        'image': 'https://images.unsplash.com/photo-1497366216548-37526070297c?w=600&auto=format&fit=crop&q=80',
      },
      {
        'title': isAr ? 'شاليه فندقي - سول الساحل الشمالي' : 'Hotel Chalet - Soul North Coast',
        'developer': 'Emaar',
        'minShare': 'EGP 12,000 / month',
        'minShareAr': '12,000 ج.م / شهر',
        'roi': '14.8% ROI',
        'progress': 0.88,
        'image': 'https://images.unsplash.com/photo-1571896349842-33c89424de2d?w=600&auto=format&fit=crop&q=80',
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
                    fontFamily: 'Cairo',
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
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: AppColors.paper,
              borderRadius: BorderRadius.circular(26),
              border: Border.all(color: AppColors.border),
              boxShadow: [
                BoxShadow(
                  color: AppColors.ink.withValues(alpha: 0.01),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Network image representing the shares
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: SizedBox(
                    height: 130,
                    width: double.infinity,
                    child: Image.network(
                      offer['image'] as String,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.gold,
                            strokeWidth: 2,
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: AppColors.ink,
                          alignment: Alignment.center,
                          child: const Icon(Icons.image_rounded, color: Colors.white24, size: 36),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    StatusPill(
                      label: offer['developer'] as String,
                      color: AppColors.gold,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.orange.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        offer['roi'] as String,
                        style: const TextStyle(
                          color: AppColors.orange,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  offer['title'] as String,
                  style: const TextStyle(
                    color: AppColors.ink,
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                    fontFamily: 'Cairo',
                  ),
                ),
                const SizedBox(height: 16),

                // Self-drawing progress bar
                TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0.0, end: progress),
                  duration: const Duration(seconds: 1, milliseconds: 500),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, child) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              isAr ? 'نسبة الاكتمال' : 'Funding Progress',
                              style: const TextStyle(color: AppColors.muted, fontSize: 11),
                            ),
                            Text(
                              '${(value * 100).toInt()}%',
                              style: const TextStyle(
                                color: AppColors.ink,
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: value,
                            backgroundColor: AppColors.border,
                            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.gold),
                            minHeight: 6,
                          ),
                        ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 18),
                const Divider(height: 1),
                const SizedBox(height: 18),

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
                            fontSize: 13,
                          ),
                        )
                      ],
                    ),
                    AnimatedTap(
                      onTap: () {
                        Get.snackbar(
                          isAr ? 'استثمار الأسهم' : 'Shares Investment',
                          isAr ? 'تم تسجيل طلب الاهتمام بالأسهم للمراجعة بنجاح.' : 'Share investment request sent for review.',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: AppColors.paper.withValues(alpha: 0.9),
                          colorText: AppColors.ink,
                          boxShadows: [
                            BoxShadow(
                              color: AppColors.ink.withValues(alpha: 0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppColors.gold, Color(0xFFF59E0B)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.gold.withValues(alpha: 0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Text(
                          isAr ? 'استثمر الآن' : 'Invest Now',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
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

