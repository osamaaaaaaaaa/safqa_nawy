import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/controllers/settings_controller.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/animated_tap.dart';
import '../../../../shared/widgets/broker_page.dart';
import '../../../../shared/widgets/status_pill.dart';
import '../../data/repositories/projects_repository.dart';
import '../../data/repositories/resale_repository.dart';
import '../../domain/entities/resale_unit.dart';
import 'resale_details_page.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  String searchQuery = '';
  bool showMapToggle = false;

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

    // Circular developer logos mocks
    final developers = [
      {'name': 'SODIC', 'color': Colors.black},
      {'name': 'HYDE PARK', 'color': Colors.blueGrey},
      {'name': 'MOUNTAIN VIEW', 'color': Colors.blue},
      {'name': 'ORA', 'color': Colors.orange},
      {'name': 'MODON', 'color': Colors.indigo},
    ];

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Stack(
        children: [
          BrokerPage(
            children: [
              // 1. Search Bar at Top
              TextField(
                onChanged: (val) => setState(() => searchQuery = val),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search_rounded, color: AppColors.muted),
                  hintText: isAr ? 'المنطقة، المطور، الكمبوند' : 'Area, Developer, Compound',
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: AppColors.border, width: 1.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: AppColors.border, width: 1.0),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // 2. Horizontal Developer Logos Scroll Row (Matching Screenshot 2)
              SizedBox(
                height: 70,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: developers.length,
                  itemBuilder: (context, index) {
                    final dev = developers[index];
                    return Container(
                      width: 66,
                      height: 66,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.paper,
                        border: Border.all(color: AppColors.border, width: 1.0),
                      ),
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Text(
                          dev['name'] as String,
                          style: TextStyle(
                            color: dev['color'] as Color,
                            fontWeight: FontWeight.w900,
                            fontSize: 7.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),

              // 3. Launches & Offers Horizontal Scroll Row (Matching Screenshot 2)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isAr ? 'عروض وإطلاقات حصرية' : 'Launches & Offers',
                    style: const TextStyle(color: AppColors.ink, fontWeight: FontWeight.w900, fontSize: 14),
                  ),
                  Text(
                    isAr ? 'عرض الكل' : 'Show all',
                    style: const TextStyle(color: AppColors.gold, fontWeight: FontWeight.bold, fontSize: 11),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: projects.length,
                  itemBuilder: (context, index) {
                    final proj = projects[index];
                    return Container(
                      width: 220,
                      margin: const EdgeInsets.only(right: 16),
                      decoration: BoxDecoration(
                        color: AppColors.ink,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.border),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Container(
                              color: AppColors.ink,
                              child: Center(
                                child: Icon(Icons.beach_access_rounded, color: AppColors.gold.withValues(alpha: 0.1), size: 40),
                              ),
                            ),
                          ),
                          Positioned.fill(
                            child: Container(
                              color: Colors.black38,
                            ),
                          ),
                          Positioned(
                            bottom: 16,
                            left: 16,
                            right: 16,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                StatusPill(label: proj.badge, color: AppColors.gold),
                                const SizedBox(height: 4),
                                Text(
                                  proj.name,
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                                ),
                                Text(
                                  proj.location,
                                  style: const TextStyle(color: Colors.white70, fontSize: 9),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              // 4. Compounds in Egypt list header (Matching Screenshot 2)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isAr ? 'الوحدات العقارية المتاحة' : 'Compounds in Egypt',
                        style: const TextStyle(color: AppColors.ink, fontWeight: FontWeight.w900, fontSize: 14),
                      ),
                      Text(
                        '${filteredResale.length} ${isAr ? 'نتائج مطابقة' : 'Available Results'}',
                        style: const TextStyle(color: AppColors.muted, fontSize: 10),
                      ),
                    ],
                  ),
                  IconButton.outlined(
                    style: IconButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      side: BorderSide(color: AppColors.border),
                    ),
                    onPressed: () {
                      Get.snackbar(
                        isAr ? 'الفلترة' : 'Filters',
                        isAr ? 'لوحة الفلترة المتقدمة ستتوفر قريباً.' : 'Advanced filter panel coming soon.',
                      );
                    },
                    icon: const Icon(Icons.tune_rounded, color: AppColors.ink, size: 18),
                  )
                ],
              ),

              const SizedBox(height: 8),

              // 5. Pill Filter Buttons Horizontal Scroll (Matching Screenshot 2)
              SizedBox(
                height: 36,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _FilterPill(label: isAr ? 'نوع الوحدة' : 'Property Types'),
                    _FilterPill(label: isAr ? 'الغرف والحمامات' : 'Beds and Baths'),
                    _FilterPill(label: isAr ? 'السعر' : 'Price'),
                    _FilterPill(
                      label: isAr ? 'ترتيب حسب' : 'Sort By',
                      icon: Icons.swap_vert_rounded,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // 6. Large Property Cards List (Matching Screenshot 2 & 3)
              Obx(
                () {
                  final hidePayout = settingsController.clientMode.value;

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filteredResale.length,
                    itemBuilder: (context, index) {
                      final unit = filteredResale[index];
                      return _NawyBigPropertyCard(
                        unit: unit,
                        isAr: isAr,
                        hidePayout: hidePayout,
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 60),
            ],
          ),

          // 7. Floating Immersive Map/List toggle button (Matching Screenshot 2 bottom center)
          Positioned(
            left: 0,
            right: 0,
            bottom: 16,
            child: Center(
              child: AnimatedTap(
                onTap: () {
                  setState(() {
                    showMapToggle = !showMapToggle;
                  });
                  Get.snackbar(
                    isAr ? 'خريطة التنازل العقاري' : 'Properties Map View',
                    showMapToggle
                        ? (isAr ? 'تم فتح عرض الخرائط التفاعلي' : 'Switched to interactive Map View')
                        : (isAr ? 'تم فتح عرض القوائم' : 'Switched to list layout view'),
                    snackPosition: SnackPosition.BOTTOM,
                  );
                },
                child: Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: AppColors.ink,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(showMapToggle ? Icons.list_rounded : Icons.map_outlined, color: Colors.white, size: 16),
                      const SizedBox(width: 8),
                      Text(
                        showMapToggle
                            ? (isAr ? 'عرض القائمة' : 'Properties View')
                            : (isAr ? 'عرض الخريطة' : 'Map View'),
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _FilterPill extends StatelessWidget {
  const _FilterPill({required this.label, this.icon});

  final String label;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.paper,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(color: AppColors.ink, fontWeight: FontWeight.w600, fontSize: 10),
          ),
          if (icon != null) ...[
            const SizedBox(width: 4),
            Icon(icon, color: AppColors.ink, size: 12),
          ]
        ],
      ),
    );
  }
}

class _NawyBigPropertyCard extends StatelessWidget {
  const _NawyBigPropertyCard({
    required this.unit,
    required this.isAr,
    required this.hidePayout,
  });

  final ResaleUnit unit;
  final bool isAr;
  final bool hidePayout;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: AppColors.paper,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Big Hero Image with overlay tags (Screenshot 3)
          SizedBox(
            height: 180,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Center(
                      child: Icon(Icons.image_rounded, color: AppColors.gold.withValues(alpha: 0.1), size: 48),
                    ),
                  ),
                ),
                // Overlays
                Positioned(
                  top: 16,
                  left: 16,
                  child: StatusPill(label: unit.unitCode, color: AppColors.gold),
                ),
                Positioned(
                  top: 16,
                  right: 16,
                  child: Row(
                    children: [
                      _ImageCircleActionButton(icon: Icons.share_outlined),
                      const SizedBox(width: 8),
                      _ImageCircleActionButton(icon: Icons.favorite_border_rounded),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 16,
                  left: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.location_on_rounded, color: Colors.white, size: 10),
                        const SizedBox(width: 4),
                        Text(
                          unit.developer,
                          style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ),
                // Overlapping Developer Logo bottom right of the image
                Positioned(
                  bottom: -10,
                  right: 16,
                  child: Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                      color: AppColors.paper,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.border, width: 2.0),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      unit.projectName.split(' ').first,
                      style: const TextStyle(color: AppColors.ink, fontWeight: FontWeight.w900, fontSize: 8),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              ],
            ),
          ),

          // 2. Info details section (Screenshot 3)
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  unit.projectName,
                  style: const TextStyle(color: AppColors.ink, fontWeight: FontWeight.w900, fontSize: 16),
                ),
                const SizedBox(height: 4),
                // Typology row: Villa | Chalet | Twinhouse | Townhouse
                Text(
                  isAr
                      ? 'فيلا | شاليه | توين هاوس | تاون هاوس'
                      : 'Villa | Chalet | Twinhouse | Townhouse',
                  style: const TextStyle(color: AppColors.muted, fontSize: 10, fontWeight: FontWeight.w600),
                ),

                const SizedBox(height: 12),
                const Divider(height: 1),
                const SizedBox(height: 12),

                // Price grid row: Developer start price & Resale start price
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isAr ? 'الكاش المطلوبة للوساطة' : 'Developer start price',
                          style: const TextStyle(color: AppColors.muted, fontSize: 9),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          unit.cashRequired,
                          style: const TextStyle(color: AppColors.ink, fontWeight: FontWeight.w900, fontSize: 12),
                        )
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          isAr ? 'سعر التنازل النهائي' : 'Resale start price',
                          style: const TextStyle(color: AppColors.muted, fontSize: 9),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          unit.marketSavings,
                          style: const TextStyle(color: AppColors.emerald, fontWeight: FontWeight.w900, fontSize: 12),
                        )
                      ],
                    )
                  ],
                ),

                if (!hidePayout) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.monetization_on_rounded, color: AppColors.emerald, size: 14),
                      const SizedBox(width: 6),
                      Text(
                        unit.commission,
                        style: const TextStyle(color: AppColors.emerald, fontWeight: FontWeight.bold, fontSize: 11),
                      ),
                    ],
                  ),
                ],

                const SizedBox(height: 16),

                // 3. Two Call/Whatsapp Action Buttons (Screenshot 3)
                Row(
                  children: [
                    Expanded(
                      child: AnimatedTap(
                        onTap: () => Get.to(() => ResaleDetailsPage(unit: unit)),
                        child: Container(
                          height: 44,
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.border),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            isAr ? 'اتصل بنا' : 'Call Us',
                            style: const TextStyle(color: AppColors.ink, fontWeight: FontWeight.bold, fontSize: 11),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AnimatedTap(
                        onTap: () {
                          Get.snackbar(
                            isAr ? 'واتساب صفقة' : 'WhatsApp Contact',
                            isAr ? 'جاري فتح المحادثة الآمنة مع مسؤول التوثيق...' : 'Opening secure chat with closing admin...',
                          );
                        },
                        child: Container(
                          height: 44,
                          decoration: BoxDecoration(
                            color: const Color(0xFF25D366),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.chat_bubble_outline_rounded, color: Colors.white, size: 14),
                              const SizedBox(width: 6),
                              Text(
                                isAr ? 'واتساب' : 'Whatsapp',
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _ImageCircleActionButton extends StatelessWidget {
  const _ImageCircleActionButton({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
        color: Colors.black38,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white, size: 14),
    );
  }
}
