import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../../core/controllers/locale_controller.dart';
import '../../../../core/controllers/navigation_controller.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/animated_tap.dart';
import '../../../transfer/presentation/pages/create_resale_page.dart';
import 'commission_dashboard_page.dart';
import '../../../explore/domain/entities/project.dart';
import '../../../explore/data/repositories/projects_repository.dart';

class BrokerHomePage extends StatelessWidget {
  const BrokerHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final localeController = Get.find<LocaleController>();
    final navController = Get.find<NavigationController>();
    final isAr = Get.locale?.languageCode == 'ar';

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // 1. Ultra-Premium Minimalist SliverAppBar
          SliverAppBar(
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: AppColors.surface,
            automaticallyImplyLeading: false,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.8,
                    ),
                    children: [
                      TextSpan(text: 'SAFQA', style: TextStyle(color: AppColors.ink)),
                      TextSpan(text: '.', style: TextStyle(color: AppColors.orange)),
                    ],
                  ),
                ),
                Row(
                  children: [
                    _PulsingNotificationBell(
                      onTap: () {
                        Get.snackbar(
                          isAr ? 'التنبيهات' : 'Notifications',
                          isAr ? 'لديك 3 تنبيهات جديدة حول مشاريعك.' : 'You have 3 new updates on your projects.',
                          snackPosition: SnackPosition.TOP,
                          backgroundColor: Colors.white.withValues(alpha: 0.95),
                          colorText: AppColors.ink,
                        );
                      },
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: localeController.toggleLocale,
                      child: Container(
                        height: 34,
                        width: 34,
                        decoration: BoxDecoration(
                          color: AppColors.paper,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.border, width: 1.0),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          localeController.isArabic ? 'EN' : 'ع',
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 11,
                            color: AppColors.gold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // 2. Interactive Scrollable Body
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isAr ? 'مرحباً بك، أسامة 👋' : 'Hello, Osama 👋',
                      style: const TextStyle(
                        color: AppColors.ink,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'Cairo',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isAr ? 'ابحث عن منزل أحلامك للتنازل أو الاستثمار' : 'Find your dream home for resale or investment',
                      style: const TextStyle(
                        color: AppColors.muted,
                        fontSize: 12,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ],
                ),
              ),

              // Search Bar Trigger
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.ink.withValues(alpha: 0.04),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: TextField(
                    readOnly: true,
                    onTap: () => navController.changeIndex(0),
                    decoration: InputDecoration(
                      fillColor: AppColors.paper,
                      filled: true,
                      prefixIcon: const Icon(Icons.search_rounded, color: AppColors.gold, size: 22),
                      hintText: isAr ? 'ابحث بالمنطقة، المطور، الكمبوند...' : 'Search by Area, Developer, Compound...',
                      hintStyle: const TextStyle(color: AppColors.muted, fontSize: 13),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide(color: AppColors.border, width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide(color: AppColors.border, width: 1.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: const BorderSide(color: AppColors.gold, width: 1.2),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 22),

              // Categories Grid
              const _ServiceCategoryList(),

              const SizedBox(height: 24),

              // Developers Circle list
              const _DeveloperLogosList(),

              const SizedBox(height: 24),

              // Popular Destinations / Districts
              const _DestinationsList(),

              const SizedBox(height: 24),

              // Featured Launches & Offers Carousel
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: _LaunchesOffersCarousel(),
              ),

              const SizedBox(height: 24),

              // Campaign Promo Banner (Safqa Keys)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  height: 165,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(
                        color: AppColors.border,
                        width: 1.0,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.ink.withValues(alpha: 0.05),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Stack(
                      children: [
                        // Background image showing a luxury estate garden entrance
                        Positioned.fill(
                          child: Image.network(
                            'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?w=600&auto=format&fit=crop&q=80',
                            fit: BoxFit.cover,
                          ),
                        ),
                        // Gradient overlay to ensure text readability
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  const Color(0xFF0F172A).withValues(alpha: 0.85),
                                  const Color(0xFF1E293B).withValues(alpha: 0.4),
                                ],
                                begin: isAr ? Alignment.centerRight : Alignment.centerLeft,
                                end: isAr ? Alignment.centerLeft : Alignment.centerRight,
                              ),
                            ),
                          ),
                        ),
                        // Promo details
                        Padding(
                          padding: const EdgeInsets.all(22),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.gold,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  isAr ? 'مفاتيح صفقة' : 'SAFQA KEYS',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 9,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                isAr ? 'استأجر منزل أحلامك\nمن صفقة العقارية' : 'Rent your dream home\nfrom Safqa Properties',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 18,
                                  height: 1.25,
                                  fontFamily: 'Cairo',
                                ),
                              ),
                              const SizedBox(height: 10),
                              AnimatedTap(
                                onTap: () {
                                  Get.snackbar(
                                    isAr ? 'استكشف الإيجارات' : 'Explore Rentals',
                                    isAr ? 'قريباً: تصفح الفلل والشقق المتاحة للإيجار الحصري.' : 'Coming soon: Browse premium villas and Chalets for rent.',
                                  );
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      isAr ? 'تصفح الآن' : 'Browse Now',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                        fontFamily: 'Cairo',
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    const Icon(
                                      Icons.arrow_forward_rounded,
                                      color: Colors.white,
                                      size: 14,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                  ),
                ),
              ),

              const SizedBox(height: 100), // Padding to prevent bottom bar overlapping
            ]),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// Custom Sub-components for BrokerHomePage
// ==========================================

class _PulsingNotificationBell extends StatefulWidget {
  const _PulsingNotificationBell({required this.onTap});
  final VoidCallback onTap;

  @override
  State<_PulsingNotificationBell> createState() => _PulsingNotificationBellState();
}

class _PulsingNotificationBellState extends State<_PulsingNotificationBell> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _glowAnimation = Tween<double>(begin: 0.0, end: 6.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: 34,
              width: 34,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.gold.withValues(alpha: 0.15),
                    blurRadius: _glowAnimation.value,
                    spreadRadius: _glowAnimation.value / 2,
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: widget.onTap,
              child: Container(
                height: 34,
                width: 34,
                decoration: BoxDecoration(
                  color: AppColors.paper,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.border, width: 1.0),
                ),
                alignment: Alignment.center,
                child: const Icon(Icons.notifications_none_rounded, color: AppColors.ink, size: 20),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ServiceCategoryList extends StatelessWidget {
  const _ServiceCategoryList();

  @override
  Widget build(BuildContext context) {
    final isAr = Get.locale?.languageCode == 'ar';
    final navController = Get.find<NavigationController>();

    final services = [
      {
        'title': isAr ? 'وحدات متاحة' : 'Available Units',
        'icon': Icons.apartment_rounded,
        'color': const Color(0xFF3B82F6), // Sky Blue
        'onTap': () => navController.changeIndex(0),
      },
      {
        'title': isAr ? 'بيع وحدتك' : 'Sell Your Unit',
        'icon': Icons.add_home_work_rounded,
        'color': AppColors.emerald, // Emerald
        'onTap': () => Get.to(() => const CreateResalePage()),
      },
      {
        'title': isAr ? 'بيع بالعمولة' : 'Sell on Commission',
        'icon': Icons.handshake_rounded,
        'color': AppColors.gold, // Gold
        'onTap': () => Get.to(() => const CommissionDashboardPage()),
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            isAr ? 'خدمات صفقة الحصرية' : 'Exclusive Safqa Services',
            style: const TextStyle(
              color: AppColors.ink,
              fontWeight: FontWeight.w900,
              fontSize: 15,
              fontFamily: 'Cairo',
            ),
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: services.map((srv) {
              return Expanded(
                child: AnimatedTap(
                  onTap: srv['onTap'] as VoidCallback,
                  scaleDownTo: 0.92,
                  child: Column(
                    children: [
                      // Rounded circular icon container
                      Container(
                        height: 54,
                        width: 54,
                        decoration: BoxDecoration(
                          color: (srv['color'] as Color).withValues(alpha: 0.08),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: (srv['color'] as Color).withValues(alpha: 0.15),
                            width: 1.2,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Icon(
                          srv['icon'] as IconData,
                          color: srv['color'] as Color,
                          size: 24,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Text label
                      Text(
                        srv['title'] as String,
                        style: const TextStyle(
                          color: AppColors.ink,
                          fontWeight: FontWeight.bold,
                          fontSize: 10.5,
                          fontFamily: 'Cairo',
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _DestinationsList extends StatelessWidget {
  const _DestinationsList();

  @override
  Widget build(BuildContext context) {
    final isAr = Get.locale?.languageCode == 'ar';
    final destinations = [
      {
        'name': isAr ? 'التجمع الخامس' : 'New Cairo',
        'tag': isAr ? '١,٢٠٠+ عقار' : '1,200+ properties',
        'image': 'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?w=400&auto=format&fit=crop&q=80',
      },
      {
        'name': isAr ? 'الشيخ زايد' : 'Sheikh Zayed',
        'tag': isAr ? '٨٥٠+ عقار' : '850+ properties',
        'image': 'https://images.unsplash.com/photo-1582268611958-ebfd161ef9cf?w=400&auto=format&fit=crop&q=80',
      },
      {
        'name': isAr ? 'الساحل الشمالي' : 'North Coast',
        'tag': isAr ? '٤٥٠+ عقار' : '450+ properties',
        'image': 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=400&auto=format&fit=crop&q=80',
      },
      {
        'name': isAr ? 'العاصمة الإدارية' : 'New Capital',
        'tag': isAr ? '٦٠٠+ عقار' : '600+ properties',
        'image': 'https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?w=400&auto=format&fit=crop&q=80',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            isAr ? 'أبرز الوجهات والمناطق' : 'Popular Destinations',
            style: const TextStyle(
              color: AppColors.ink,
              fontWeight: FontWeight.w900,
              fontSize: 16,
              fontFamily: 'Cairo',
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 130,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: destinations.length,
            itemBuilder: (context, index) {
              final dest = destinations[index];
              return AnimatedTap(
                onTap: () {
                  Get.snackbar(
                    dest['name'] as String,
                    isAr 
                        ? 'تصفية النتائج حسب منطقة ${dest['name']}...' 
                        : 'Filtering properties in ${dest['name']}...',
                  );
                },
                child: Container(
                  width: 130,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.border, width: 1.0),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Image.network(
                          dest['image'] as String,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned.fill(
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.black54, Colors.black12],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 12,
                        left: 12,
                        right: 12,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              dest['name'] as String,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12.5,
                                fontFamily: 'Cairo',
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              dest['tag'] as String,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 9,
                                fontFamily: 'Cairo',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _DeveloperLogosList extends StatelessWidget {
  const _DeveloperLogosList();

  @override
  Widget build(BuildContext context) {
    final isAr = Get.locale?.languageCode == 'ar';
    final developers = [
      {'name': 'SODIC', 'logoText': 'SODIC', 'color': Colors.black},
      {'name': 'Hyde Park', 'logoText': 'HYDE PARK', 'color': const Color(0xFF1E3A8A)},
      {'name': 'Mountain View', 'logoText': 'MV', 'color': const Color(0xFF0F172A)},
      {'name': 'ORA', 'logoText': 'ORA', 'color': Colors.orange.shade700},
      {'name': 'MUDON', 'logoText': 'MUDON', 'color': Colors.red.shade900},
      {'name': 'Emaar', 'logoText': 'EMAAR', 'color': const Color(0xFF0B132B)},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            isAr ? 'أهم المطورين العقاريين' : 'Top Developers',
            style: const TextStyle(
              color: AppColors.ink,
              fontWeight: FontWeight.w900,
              fontSize: 16,
              fontFamily: 'Cairo',
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 66,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: developers.length,
            itemBuilder: (context, index) {
              final dev = developers[index];
              return AnimatedTap(
                onTap: () {
                  Get.snackbar(
                    dev['name'] as String,
                    isAr 
                        ? 'تصفح مشاريع ${dev['name']} المتوفرة في المعرض.' 
                        : 'Explore all available projects by ${dev['name']}.',
                  );
                },
                child: Container(
                  width: 66,
                  height: 66,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: AppColors.paper,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.border, width: 1.2),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.ink.withValues(alpha: 0.02),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      color: dev['color'] as Color,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        dev['logoText'] as String,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8.5,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _LaunchPropertyCard extends StatelessWidget {
  const _LaunchPropertyCard({required this.project, required this.isAr, required this.imageUrl});
  final Project project;
  final bool isAr;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 16, bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.paper,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border, width: 1.0),
        boxShadow: [
          BoxShadow(
            color: AppColors.ink.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cover Image with tags
          SizedBox(
            height: 130,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
                // Gradient overlay
                Positioned.fill(
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.black54, Colors.transparent],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                  ),
                ),
                // Top overlays
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.orange,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      project.badge,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 9,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.favorite_rounded, color: AppColors.clay, size: 14),
                  ),
                ),
                // Bottom title on image
                Positioned(
                  bottom: 12,
                  left: 14,
                  right: 14,
                  child: Text(
                    project.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      shadows: [
                        Shadow(color: Colors.black45, blurRadius: 4, offset: Offset(0, 1)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      project.developer,
                      style: const TextStyle(color: AppColors.muted, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      project.location,
                      style: const TextStyle(color: AppColors.gold, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isAr ? 'يبدأ من' : 'Starting Price',
                          style: const TextStyle(color: AppColors.muted, fontSize: 9),
                        ),
                        Text(
                          project.startingPrice,
                          style: const TextStyle(color: AppColors.ink, fontWeight: FontWeight.w900, fontSize: 13),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          isAr ? 'التقسيط' : 'Installment',
                          style: const TextStyle(color: AppColors.muted, fontSize: 9),
                        ),
                        Text(
                          project.installmentYears,
                          style: const TextStyle(color: AppColors.ink, fontWeight: FontWeight.bold, fontSize: 11),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Contact Buttons
                Row(
                  children: [
                    Expanded(
                      child: AnimatedTap(
                        onTap: () {
                          Get.snackbar(
                            isAr ? 'الاتصال بالمستشار' : 'Call Broker',
                            isAr ? 'جاري الاتصال بمستشار صفقة العقاري...' : 'Calling Safqa Property Advisor...',
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.border),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.phone_rounded,
                            color: AppColors.ink,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: AnimatedTap(
                        onTap: () {
                          Get.snackbar(
                            'WhatsApp',
                            isAr ? 'جاري فتح محادثة واتساب مع المستشار...' : 'Opening WhatsApp chat with advisor...',
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF25D366),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.center,
                          child: const FaIcon(
                            FontAwesomeIcons.whatsapp,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                      ),
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

class _LaunchesOffersCarousel extends StatelessWidget {
  const _LaunchesOffersCarousel();

  @override
  Widget build(BuildContext context) {
    final isAr = Get.locale?.languageCode == 'ar';
    final repo = const ProjectsRepository();
    final projects = repo.featuredProjects();
    
    final projectImages = [
      'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?w=500&auto=format&fit=crop&q=80',
      'https://images.unsplash.com/photo-1571896349842-33c89424de2d?w=500&auto=format&fit=crop&q=80',
      'https://images.unsplash.com/photo-1497366216548-37526070297c?w=500&auto=format&fit=crop&q=80',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              isAr ? 'الإطلاقات والعروض الحصرية' : 'Launches & Offers',
              style: const TextStyle(
                color: AppColors.ink,
                fontWeight: FontWeight.w900,
                fontSize: 16,
                fontFamily: 'Cairo',
              ),
            ),
            AnimatedTap(
              onTap: () {
                Get.snackbar(
                  isAr ? 'كل العروض' : 'All Offers',
                  isAr ? 'سيتم تحويلك لصفحة العروض الحصرية قريباً.' : 'Navigating to exclusive offers page...',
                );
              },
              child: Text(
                isAr ? 'عرض الكل' : 'Show all',
                style: const TextStyle(
                  color: AppColors.gold,
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                  fontFamily: 'Cairo',
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 290,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: projects.length,
            itemBuilder: (context, index) {
              final proj = projects[index];
              return _LaunchPropertyCard(
                project: proj,
                isAr: isAr,
                imageUrl: index < projectImages.length ? projectImages[index] : projectImages[0],
              );
            },
          ),
        ),
      ],
    );
  }
}
