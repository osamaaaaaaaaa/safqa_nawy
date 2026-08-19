import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/animated_tap.dart';
import '../../../../shared/widgets/broker_page.dart';

class CommissionDashboardPage extends StatefulWidget {
  const CommissionDashboardPage({super.key});

  @override
  State<CommissionDashboardPage> createState() => _CommissionDashboardPageState();
}

class _CommissionDashboardPageState extends State<CommissionDashboardPage> {
  String searchQuery = '';
  String selectedDeveloperFilter = 'All';
  String selectedProjectFilter = 'All';
  String selectedLocation = 'All'; // Searchable Location state
  bool _isSearching = false;

  // Filter States
  String selectedPropertyType = 'All'; // All, Villa, Chalet, Apartment
  double minCommissionVal = 0.0; // 0, 500k, 800k, 1M

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  // Full developer inventory for searchable picker
  final List<String> allDevelopers = [
    'All',
    'SODIC',
    'Emaar Misr',
    'Mountain View',
    'Ora Developers',
    'Palm Hills',
    'Tatweer Misr',
    'Misr Italia',
    'Hyde Park Developments',
    'Talaat Moustafa Group',
    'Al Ahly Sabbour',
    'LMD',
    'Madinet Masr',
    'Modon Developments'
  ];

  // Full location inventory for searchable picker
  final List<String> allLocations = [
    'All',
    'New Cairo',
    'New Zayed',
    '6th of October',
    'North Coast',
    'Sokhna',
    'Administrative Capital',
    'El Shorouk',
    'Mostakbal City',
    'Mokattam',
    'El Gouna'
  ];

  // Dummy developer project data (Rich cascading dataset: 1 developer owns multiple projects!)
  final List<Map<String, dynamic>> developerProjects = [
    // Mountain View Projects
    {
      'project': 'ماونتن فيو آي سيتي',
      'project_en': 'Mountain View iCity',
      'developer': 'Mountain View',
      'location': 'القاهرة الجديدة، التجمع الخامس',
      'location_en': 'New Cairo',
      'location_key': 'New Cairo',
      'property_type': 'Apartment',
      'commission_pct': 5.0,
      'max_commission': 750000,
      'starting_price': 5200000,
      'badge': 'أقساط تصل لـ 9 سنوات',
      'badge_en': 'Up to 9 Years Installments',
      'image': 'https://images.unsplash.com/photo-1497366216548-37526070297c?w=600&auto=format&fit=crop&q=80',
      'unit_code': 'DEV-ICITY',
    },
    {
      'project': 'ماونتن فيو هايد بارك',
      'project_en': 'Mountain View Hyde Park',
      'developer': 'Mountain View',
      'location': 'القاهرة الجديدة، التجمع الخامس',
      'location_en': 'New Cairo',
      'location_key': 'New Cairo',
      'property_type': 'Villa',
      'commission_pct': 4.8,
      'max_commission': 890000,
      'starting_price': 8200000,
      'badge': 'استلام فوري',
      'badge_en': 'Ready to Deliver',
      'image': 'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?w=600&auto=format&fit=crop&q=80',
      'unit_code': 'DEV-MVHYDE',
    },
    {
      'project': 'ماونتن فيو تشيل أوت بارك',
      'project_en': 'MV Chillout Park',
      'developer': 'Mountain View',
      'location': 'سادس من أكتوبر، التوسعات الشمالية',
      'location_en': '6th of October',
      'location_key': '6th of October',
      'property_type': 'Villa',
      'commission_pct': 5.2,
      'max_commission': 1100000,
      'starting_price': 9800000,
      'badge': 'عرض حصري لفترة محدودة',
      'badge_en': 'Limited Time Offer',
      'image': 'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?w=600&auto=format&fit=crop&q=80',
      'unit_code': 'DEV-CHILLOUT',
    },
    // Emaar Misr Projects
    {
      'project': 'بل في الشيخ زايد',
      'project_en': 'Belle Vie Zayed',
      'developer': 'Emaar Misr',
      'location': 'الشيخ زايد الجديدة',
      'location_en': 'New Zayed',
      'location_key': 'New Zayed',
      'property_type': 'Villa',
      'commission_pct': 4.0,
      'max_commission': 960000,
      'starting_price': 8500000,
      'badge': 'أعلى نسبة مبيعات بالمنطقة',
      'badge_en': 'Top Selling Project',
      'image': 'https://images.unsplash.com/photo-1600607687939-ce8a6c25118c?w=600&auto=format&fit=crop&q=80',
      'unit_code': 'DEV-BELLE',
    },
    {
      'project': 'أب تاون كايرو',
      'project_en': 'Uptown Cairo',
      'developer': 'Emaar Misr',
      'location': 'المقطم، وسط القاهرة',
      'location_en': 'Mokattam',
      'location_key': 'Mokattam',
      'property_type': 'Apartment',
      'commission_pct': 3.8,
      'max_commission': 580000,
      'starting_price': 7200000,
      'badge': 'إطلالة بانورامية على القاهرة',
      'badge_en': 'Panoramic Views',
      'image': 'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?w=600&auto=format&fit=crop&q=80',
      'unit_code': 'DEV-UPTOWN',
    },
    {
      'project': 'مراسي الساحل الشمالي',
      'project_en': 'Marassi North Coast',
      'developer': 'Emaar Misr',
      'location': 'سيدي عبد الرحمن، الكيلو 129',
      'location_en': 'Sidi Abdel Rahman',
      'location_key': 'North Coast',
      'property_type': 'Chalet',
      'commission_pct': 4.5,
      'max_commission': 1300000,
      'starting_price': 12000000,
      'badge': 'أرقى منتجع بالساحل',
      'badge_en': 'Premium Beachfront resort',
      'image': 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=600&auto=format&fit=crop&q=80',
      'unit_code': 'DEV-MARASSI',
    },
    // SODIC Projects
    {
      'project': 'فايليت سوديك التجمع',
      'project_en': 'Villette SODIC',
      'developer': 'SODIC',
      'location': 'القاهرة الجديدة، التجمع الخامس',
      'location_en': 'New Cairo',
      'location_key': 'New Cairo',
      'property_type': 'Villa',
      'commission_pct': 4.2,
      'max_commission': 1050000,
      'starting_price': 11000000,
      'badge': 'جاهز للاستلام والتسليم',
      'badge_en': 'Ready to Move',
      'image': 'https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?w=600&auto=format&fit=crop&q=80',
      'unit_code': 'DEV-VILLETTE',
    },
    {
      'project': 'جون سوديك الساحل',
      'project_en': 'June SODIC Coast',
      'developer': 'SODIC',
      'location': 'رأس الحكمة، الكيلو 193',
      'location_en': 'Ras El Hekma',
      'location_key': 'North Coast',
      'property_type': 'Chalet',
      'commission_pct': 5.0,
      'max_commission': 920000,
      'starting_price': 6800000,
      'badge': 'شاطئ رملي مميز',
      'badge_en': 'Sandy Beach Lagoon',
      'image': 'https://images.unsplash.com/photo-1571896349842-33c89424de2d?w=600&auto=format&fit=crop&q=80',
      'unit_code': 'DEV-JUNE',
    },
    // Misr Italia Projects
    {
      'project': 'سولاري الساحل الشمالي',
      'project_en': 'Solare North Coast',
      'developer': 'Misr Italia',
      'location': 'رأس الحكمة، الكيلو 199',
      'location_en': 'Ras El Hekma, Km 199',
      'location_key': 'North Coast',
      'property_type': 'Chalet',
      'commission_pct': 6.0,
      'max_commission': 1200000,
      'starting_price': 7200000,
      'badge': 'موقع مميز جداً - خليج رأس الحكمة',
      'badge_en': 'Ras El Hekma Bay Location',
      'image': 'https://images.unsplash.com/photo-1582268611958-ebfd161ef9cf?w=600&auto=format&fit=crop&q=80',
      'unit_code': 'DEV-SOLARE',
    },
    // Hyde Park Projects
    {
      'project': 'هايد بارك القاهرة الجديدة',
      'project_en': 'Hyde Park New Cairo',
      'developer': 'Hyde Park Developments',
      'location': 'الدائري الأوسطي، التجمع الخامس',
      'location_en': 'New Cairo',
      'location_key': 'New Cairo',
      'property_type': 'Apartment',
      'commission_pct': 4.5,
      'max_commission': 680000,
      'starting_price': 6100000,
      'badge': 'جاهز للاستلام الفوري',
      'badge_en': 'Ready to Deliver',
      'image': 'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?w=600&auto=format&fit=crop&q=80',
      'unit_code': 'DEV-HYDE',
    }
  ];

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _showProfitCalculator(BuildContext context, bool isAr, {double priceMillions = 6.0, double commissionRate = 3.0}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _ProfitCalculatorSheet(
        isAr: isAr,
        initialPriceMillions: priceMillions,
        initialCommissionRate: commissionRate,
      ),
    );
  }

  // 1. Searchable Developer Selector Modal
  void _showDeveloperSearchSheet(BuildContext context, bool isAr, {VoidCallback? onSelected}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        String modalSearch = '';
        return StatefulBuilder(
          builder: (context, setModalState) {
            final filteredDevs = allDevelopers.where((dev) {
              if (modalSearch.isEmpty) return true;
              return dev.toLowerCase().contains(modalSearch.toLowerCase());
            }).toList();

            return Container(
              height: MediaQuery.of(context).size.height * 0.75,
              decoration: const BoxDecoration(
                color: AppColors.paper,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
              child: Column(
                children: [
                  Container(
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                      color: AppColors.border,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isAr ? 'البحث عن المطور العقاري' : 'Search Developer',
                        style: const TextStyle(color: AppColors.ink, fontWeight: FontWeight.w900, fontSize: 16, fontFamily: 'Cairo'),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded, color: AppColors.muted),
                        onPressed: () => Navigator.pop(context),
                      )
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Search input in Modal
                  Container(
                    height: 46,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.border),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: [
                        const Icon(Icons.search_rounded, color: AppColors.muted, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            onChanged: (val) => setModalState(() => modalSearch = val),
                            style: const TextStyle(fontSize: 13, color: AppColors.ink),
                            decoration: InputDecoration(
                              hintText: isAr ? 'ابحث باسم المطور (سوديك، إعمار...)' : 'Search developer (Sodic, Emaar...)',
                              hintStyle: const TextStyle(color: AppColors.muted, fontSize: 12),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Scrollable List
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredDevs.length,
                      itemBuilder: (context, index) {
                        final devName = filteredDevs[index];
                        final isSel = selectedDeveloperFilter.toLowerCase() == devName.toLowerCase();
                        final displayLabel = devName == 'All' ? (isAr ? 'كل المطورين' : 'All Developers') : devName;

                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          decoration: BoxDecoration(
                            color: isSel ? AppColors.gold.withValues(alpha: 0.08) : Colors.transparent,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: ListTile(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                            onTap: () {
                              setState(() {
                                selectedDeveloperFilter = devName;
                                selectedProjectFilter = 'All';
                              });
                              Navigator.pop(context);
                              if (onSelected != null) onSelected();
                            },
                            leading: Container(
                              height: 28,
                              width: 28,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isSel ? AppColors.gold : AppColors.surface,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                devName == 'All' ? '*' : devName.substring(0, devName.length > 2 ? 2 : devName.length),
                                style: TextStyle(
                                  color: isSel ? AppColors.ink : AppColors.muted,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 9.5,
                                ),
                              ),
                            ),
                            title: Text(
                              displayLabel,
                              style: TextStyle(
                                color: AppColors.ink,
                                fontWeight: isSel ? FontWeight.w900 : FontWeight.w600,
                                fontSize: 13.5,
                                fontFamily: 'Cairo',
                              ),
                            ),
                            trailing: isSel 
                                ? const Icon(Icons.check_circle_rounded, color: AppColors.gold, size: 20)
                                : null,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // 2. Searchable Project Selector Modal
  void _showProjectSearchSheet(BuildContext context, bool isAr, {VoidCallback? onSelected}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        String modalSearch = '';
        return StatefulBuilder(
          builder: (context, setModalState) {
            // Get unique list of projects matching the currently selected developer!
            final rawProjects = developerProjects.where((unit) {
              if (selectedDeveloperFilter == 'All' || selectedDeveloperFilter == 'الكل') return true;
              return unit['developer'].toString().toLowerCase().contains(selectedDeveloperFilter.toLowerCase());
            }).map((unit) => isAr ? unit['project'] as String : unit['project_en'] as String).toSet().toList();

            final allOptions = ['All', ...rawProjects];

            final filteredOptions = allOptions.where((proj) {
              if (modalSearch.isEmpty) return true;
              return proj.toLowerCase().contains(modalSearch.toLowerCase());
            }).toList();

            return Container(
              height: MediaQuery.of(context).size.height * 0.75,
              decoration: const BoxDecoration(
                color: AppColors.paper,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
              child: Column(
                children: [
                  Container(
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                      color: AppColors.border,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isAr ? 'اختر المشروع العقاري' : 'Select Project',
                            style: const TextStyle(color: AppColors.ink, fontWeight: FontWeight.w900, fontSize: 16, fontFamily: 'Cairo'),
                          ),
                          if (selectedDeveloperFilter != 'All')
                            Text(
                              '${isAr ? 'مشاريع مطور: ' : 'Projects of: '}$selectedDeveloperFilter',
                              style: const TextStyle(color: AppColors.muted, fontSize: 10.5, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
                            ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded, color: AppColors.muted),
                        onPressed: () => Navigator.pop(context),
                      )
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Search input in Modal
                  Container(
                    height: 46,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.border),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: [
                        const Icon(Icons.search_rounded, color: AppColors.muted, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            onChanged: (val) => setModalState(() => modalSearch = val),
                            style: const TextStyle(fontSize: 13, color: AppColors.ink),
                            decoration: InputDecoration(
                              hintText: isAr ? 'ابحث باسم المشروع (آي سيتي، مراسي...)' : 'Search project (iCity, Marassi...)',
                              hintStyle: const TextStyle(color: AppColors.muted, fontSize: 12),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Scrollable List of Projects
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredOptions.length,
                      itemBuilder: (context, index) {
                        final projName = filteredOptions[index];
                        final isSel = selectedProjectFilter.toLowerCase() == projName.toLowerCase();
                        final displayLabel = projName == 'All' ? (isAr ? 'كل المشاريع' : 'All Projects') : projName;

                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          decoration: BoxDecoration(
                            color: isSel ? AppColors.gold.withValues(alpha: 0.08) : Colors.transparent,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: ListTile(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                            onTap: () {
                              setState(() {
                                selectedProjectFilter = projName;
                              });
                              Navigator.pop(context);
                              if (onSelected != null) onSelected();
                            },
                            leading: Container(
                              height: 28,
                              width: 28,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isSel ? AppColors.gold : AppColors.surface,
                              ),
                              alignment: Alignment.center,
                              child: const Icon(Icons.business_rounded, color: AppColors.muted, size: 14),
                            ),
                            title: Text(
                              displayLabel,
                              style: TextStyle(
                                color: AppColors.ink,
                                fontWeight: isSel ? FontWeight.w900 : FontWeight.w600,
                                fontSize: 13.5,
                                fontFamily: 'Cairo',
                              ),
                            ),
                            trailing: isSel 
                                ? const Icon(Icons.check_circle_rounded, color: AppColors.gold, size: 20)
                                : null,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // 3. Searchable Location Selector Modal (UX solution for 100+ locations)
  void _showLocationSearchSheet(BuildContext context, bool isAr, {VoidCallback? onSelected}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        String modalSearch = '';
        return StatefulBuilder(
          builder: (context, setModalState) {
            final filteredLocs = allLocations.where((loc) {
              if (modalSearch.isEmpty) return true;
              return loc.toLowerCase().contains(modalSearch.toLowerCase());
            }).toList();

            return Container(
              height: MediaQuery.of(context).size.height * 0.75,
              decoration: const BoxDecoration(
                color: AppColors.paper,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
              child: Column(
                children: [
                  Container(
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                      color: AppColors.border,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isAr ? 'البحث عن المنطقة الجغرافية' : 'Search Location',
                        style: const TextStyle(color: AppColors.ink, fontWeight: FontWeight.w900, fontSize: 16, fontFamily: 'Cairo'),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded, color: AppColors.muted),
                        onPressed: () => Navigator.pop(context),
                      )
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Search input in Modal
                  Container(
                    height: 46,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.border),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: [
                        const Icon(Icons.location_on_rounded, color: AppColors.gold, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            onChanged: (val) => setModalState(() => modalSearch = val),
                            style: const TextStyle(fontSize: 13, color: AppColors.ink),
                            decoration: InputDecoration(
                              hintText: isAr ? 'ابحث باسم المنطقة (التجمع، زايد، الساحل...)' : 'Search location (Zayed, Tagamoa...)',
                              hintStyle: const TextStyle(color: AppColors.muted, fontSize: 12),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Scrollable List of Locations
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredLocs.length,
                      itemBuilder: (context, index) {
                        final locName = filteredLocs[index];
                        final isSel = selectedLocation.toLowerCase() == locName.toLowerCase();
                        final displayLabel = locName == 'All' 
                            ? (isAr ? 'كل المناطق الجغرافية' : 'All Locations') 
                            : (locName == 'New Cairo' ? (isAr ? 'القاهرة الجديدة' : 'New Cairo') : (locName == 'New Zayed' ? (isAr ? 'الشيخ زايد الجديدة' : 'New Zayed') : (locName == '6th of October' ? (isAr ? 'السادس من أكتوبر' : '6th of October') : (locName == 'North Coast' ? (isAr ? 'الساحل الشمالي' : 'North Coast') : (locName == 'Sokhna' ? (isAr ? 'العين السخنة' : 'Sokhna') : (locName == 'Administrative Capital' ? (isAr ? 'العاصمة الإدارية' : 'Administrative Capital') : (locName == 'El Shorouk' ? (isAr ? 'الشروق' : 'El Shorouk') : (locName == 'Mostakbal City' ? (isAr ? 'مستقبل سيتي' : 'Mostakbal City') : (locName == 'Mokattam' ? (isAr ? 'المقطم' : 'Mokattam') : (isAr ? 'الجونة' : 'El Gouna'))))))))));

                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          decoration: BoxDecoration(
                            color: isSel ? AppColors.gold.withValues(alpha: 0.08) : Colors.transparent,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: ListTile(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                            onTap: () {
                              setState(() {
                                selectedLocation = locName;
                              });
                              Navigator.pop(context);
                              if (onSelected != null) onSelected();
                            },
                            leading: Container(
                              height: 28,
                              width: 28,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isSel ? AppColors.gold : AppColors.surface,
                              ),
                              alignment: Alignment.center,
                              child: const Icon(Icons.location_on_rounded, color: AppColors.muted, size: 14),
                            ),
                            title: Text(
                              displayLabel,
                              style: TextStyle(
                                color: AppColors.ink,
                                fontWeight: isSel ? FontWeight.w900 : FontWeight.w600,
                                fontSize: 13.5,
                                fontFamily: 'Cairo',
                              ),
                            ),
                            trailing: isSel 
                                ? const Icon(Icons.check_circle_rounded, color: AppColors.gold, size: 20)
                                : null,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // 4. Luxurious Fluid Unified Filtering Modal Sheet (No borders, no heavy lines, extremely sleek cards)
  void _showFilterSheet(BuildContext context, bool isAr) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          decoration: const BoxDecoration(
            color: AppColors.paper,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(32),
              topRight: Radius.circular(32),
            ),
          ),
          padding: EdgeInsets.fromLTRB(24, 20, 24, MediaQuery.of(context).viewInsets.bottom + 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Pull Handle
              Center(
                child: Container(
                  width: 50,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 22),

              // Title block (Zero hard lines)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isAr ? 'تصفية العمولات المتقدمة' : 'Advanced Filters',
                    style: const TextStyle(
                      color: AppColors.ink, 
                      fontWeight: FontWeight.w900, 
                      fontSize: 17, 
                      fontFamily: 'Cairo',
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, color: AppColors.muted, size: 22),
                    onPressed: () => Navigator.pop(context),
                  )
                ],
              ),
              const SizedBox(height: 12),

              // Fluid Picker Cards block (Sleek minimalist selection tiles with chevron indicators and zero dividers)
              Column(
                children: [
                  // Developer Selector Row
                  _buildFluidPickerTile(
                    label: isAr ? 'المطور العقاري' : 'Developer',
                    value: selectedDeveloperFilter == 'All' 
                        ? (isAr ? 'كل المطورين' : 'All Developers')
                        : selectedDeveloperFilter,
                    icon: Icons.business_rounded,
                    onTap: () => _showDeveloperSearchSheet(context, isAr, onSelected: () {
                      setModalState(() {});
                    }),
                  ),
                  const SizedBox(height: 10),

                  // Project Selector Row (Cascading dependency)
                  _buildFluidPickerTile(
                    label: isAr ? 'المشروع العقاري' : 'Project',
                    value: selectedProjectFilter == 'All'
                        ? (isAr ? 'كل المشاريع' : 'All Projects')
                        : selectedProjectFilter,
                    icon: Icons.layers_rounded,
                    onTap: () => _showProjectSearchSheet(context, isAr, onSelected: () {
                      setModalState(() {});
                    }),
                  ),
                  const SizedBox(height: 10),

                  // Location Selector Row (Searchable)
                  _buildFluidPickerTile(
                    label: isAr ? 'المنطقة الجغرافية' : 'Location',
                    value: selectedLocation == 'All'
                        ? (isAr ? 'كل المناطق الجغرافية' : 'All Locations')
                        : (selectedLocation == 'New Cairo' ? (isAr ? 'القاهرة الجديدة' : 'New Cairo') : (selectedLocation == 'New Zayed' ? (isAr ? 'الشيخ زايد الجديدة' : 'New Zayed') : (selectedLocation == '6th of October' ? (isAr ? 'السادس من أكتوبر' : '6th of October') : (selectedLocation == 'North Coast' ? (isAr ? 'الساحل الشمالي' : 'North Coast') : (selectedLocation == 'Sokhna' ? (isAr ? 'العين السخنة' : 'Sokhna') : (selectedLocation == 'Administrative Capital' ? (isAr ? 'العاصمة الإدارية' : 'Administrative Capital') : (selectedLocation == 'El Shorouk' ? (isAr ? 'الشروق' : 'El Shorouk') : (selectedLocation == 'Mostakbal City' ? (isAr ? 'مستقبل سيتي' : 'Mostakbal City') : (selectedLocation == 'Mokattam' ? (isAr ? 'المقطم' : 'Mokattam') : (isAr ? 'الجونة' : 'El Gouna')))))))))),
                    icon: Icons.location_on_rounded,
                    onTap: () => _showLocationSearchSheet(context, isAr, onSelected: () {
                      setModalState(() {});
                    }),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              // Property Type Filter
              Text(
                isAr ? 'نوع العقار' : 'Property Type',
                style: const TextStyle(color: AppColors.ink, fontWeight: FontWeight.bold, fontSize: 12.5, fontFamily: 'Cairo'),
              ),
              const SizedBox(height: 8),
              Row(
                children: ['All', 'Apartment', 'Villa', 'Chalet'].map((type) {
                  final label = type == 'All' ? (isAr ? 'الكل' : 'All') : (type == 'Apartment' ? (isAr ? 'شقة' : 'Apartment') : (type == 'Villa' ? (isAr ? 'فيلا' : 'Villa') : (isAr ? 'شاليه' : 'Chalet')));
                  final isSel = selectedPropertyType == type;
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: AnimatedTap(
                        onTap: () => setModalState(() => selectedPropertyType = type),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 9),
                          decoration: BoxDecoration(
                            color: isSel ? AppColors.ink : AppColors.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSel ? AppColors.gold : AppColors.border.withValues(alpha: 0.5),
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            label,
                            style: TextStyle(
                              color: isSel ? Colors.white : AppColors.ink, 
                              fontWeight: FontWeight.bold, 
                              fontSize: 11, 
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 18),

              // Minimum Commission Filter (Sleek slider wrapper)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isAr ? 'الحد الأدنى لعمولة التسويق' : 'Min Commission Payout',
                    style: const TextStyle(color: AppColors.ink, fontWeight: FontWeight.bold, fontSize: 12.5, fontFamily: 'Cairo'),
                  ),
                  Text(
                    minCommissionVal == 0.0 ? (isAr ? 'الكل' : 'All') : '${(minCommissionVal / 1000).toStringAsFixed(0)}K ج.م',
                    style: const TextStyle(color: AppColors.gold, fontWeight: FontWeight.w900, fontSize: 12.5, fontFamily: 'Cairo'),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: AppColors.gold,
                  inactiveTrackColor: AppColors.border,
                  thumbColor: AppColors.ink,
                  overlayColor: AppColors.gold.withValues(alpha: 0.15),
                  trackHeight: 3,
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
                ),
                child: Slider(
                  value: minCommissionVal,
                  min: 0.0,
                  max: 1200000.0,
                  divisions: 12,
                  onChanged: (val) {
                    setModalState(() => minCommissionVal = val);
                  },
                ),
              ),

              const SizedBox(height: 24),

              // Fluid Action Buttons (Clean rounded shapes, zero divider separation)
              Row(
                children: [
                  Expanded(
                    child: AnimatedTap(
                      onTap: () {
                        setModalState(() {
                          selectedDeveloperFilter = 'All';
                          selectedProjectFilter = 'All';
                          selectedLocation = 'All';
                          selectedPropertyType = 'All';
                          minCommissionVal = 0.0;
                        });
                        setState(() {});
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          isAr ? 'إعادة تعيين' : 'Reset All',
                          style: const TextStyle(color: AppColors.ink, fontWeight: FontWeight.bold, fontSize: 13, fontFamily: 'Cairo'),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AnimatedTap(
                      onTap: () {
                        setState(() {});
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: AppColors.ink,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          isAr ? 'تطبيق الفلتر' : 'Apply Filters',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13, fontFamily: 'Cairo'),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget to build fluid picker card selection row without borders/dividers
  Widget _buildFluidPickerTile({
    required String label,
    required String value,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.gold, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(color: AppColors.muted, fontSize: 10, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: const TextStyle(color: AppColors.ink, fontWeight: FontWeight.w900, fontSize: 12.5, fontFamily: 'Cairo'),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.muted, size: 14), // Auto-mirrors in RTL
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isAr = Get.locale?.languageCode == 'ar';

    // Helper to get initials or clean single-line abbreviation
    String getDeveloperAbbreviation(String nameStr) {
      final clean = nameStr.trim();
      if (clean == 'All' || clean == 'الكل') return clean;
      if (clean.length <= 6 && !clean.contains(' ')) return clean;
      final parts = clean.split(' ');
      if (parts.length >= 2) {
        final first = parts[0].isNotEmpty ? parts[0][0] : '';
        final second = parts[1].isNotEmpty ? parts[1][0] : '';
        return '$first$second'.toUpperCase();
      }
      return clean.length >= 3 ? clean.substring(0, 3).toUpperCase() : clean.toUpperCase();
    }

    // Base default developers circular badges with optional logo URLs
    final List<Map<String, dynamic>> baseDevelopers = [
      {'name': isAr ? 'الكل' : 'All', 'color': AppColors.gold, 'logo': null},
      {'name': 'SODIC', 'color': Colors.black, 'logo': 'https://logo.clearbit.com/sodic.com'},
      {'name': 'Emaar Misr', 'color': Colors.indigo, 'logo': 'https://logo.clearbit.com/emaar.com'},
      {'name': 'Mountain View', 'color': Colors.blue, 'logo': null}, 
      {'name': 'Ora Developers', 'color': Colors.orange, 'logo': null}, 
      {'name': 'Hyde Park Developments', 'color': Colors.blueGrey, 'logo': 'https://logo.clearbit.com/hydepark.com.eg'},
    ];

    // Build circular items list dynamically.
    final circularList = List<Map<String, dynamic>>.from(baseDevelopers);
    final isPresetSelected = circularList.any((d) => d['name'].toString().toLowerCase() == selectedDeveloperFilter.toLowerCase());
    if (!isPresetSelected && selectedDeveloperFilter != 'All' && selectedDeveloperFilter != 'الكل') {
      circularList.insert(1, {
        'name': selectedDeveloperFilter.toUpperCase(),
        'color': AppColors.gold,
        'logo': null, // Fallback to initials
      });
    }

    // Filter projects logic matching all criteria
    final filteredProjects = developerProjects.where((unit) {
      // 1. Search Query
      if (searchQuery.isNotEmpty) {
        final q = searchQuery.toLowerCase();
        final matchesSearch =
            unit['project'].toLowerCase().contains(q) ||
            unit['developer'].toLowerCase().contains(q);
        if (!matchesSearch) return false;
      }
      // 2. Developer Filter
      if (selectedDeveloperFilter != 'All' && selectedDeveloperFilter != 'الكل') {
        if (!unit['developer'].toLowerCase().contains(selectedDeveloperFilter.toLowerCase())) {
          return false;
        }
      }
      // 3. Project Filter (Cascading match)
      if (selectedProjectFilter != 'All') {
        final currentProjName = isAr ? unit['project'] as String : unit['project_en'] as String;
        if (currentProjName.toLowerCase() != selectedProjectFilter.toLowerCase()) {
          return false;
        }
      }
      // 4. Property Type Filter
      if (selectedPropertyType != 'All') {
        if (unit['property_type'] != selectedPropertyType) {
          return false;
        }
      }
      // 5. Location Filter
      if (selectedLocation != 'All') {
        if (unit['location_key'].toString().toLowerCase() != selectedLocation.toLowerCase()) {
          return false;
        }
      }
      // 6. Min Commission Value Filter
      if (minCommissionVal > 0.0) {
        if ((unit['max_commission'] as int) < minCommissionVal) {
          return false;
        }
      }
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.surface,
      // Premium Custom iOS Animated Search AppBar with native Back button
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          color: AppColors.surface,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              children: [
                // iOS-Style native Back button (Show only when not searching)
                if (!_isSearching)
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: AppColors.ink,
                      size: 20,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),

                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 220),
                    transitionBuilder: (child, animation) => FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0.08, 0.0),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      ),
                    ),
                    child: _isSearching
                        ? Container(
                            key: const ValueKey('search_active'),
                            height: 42,
                            decoration: BoxDecoration(
                              color: AppColors.paper,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: TextField(
                              controller: _searchController,
                              focusNode: _searchFocusNode,
                              onChanged: (val) => setState(() => searchQuery = val),
                              style: const TextStyle(fontSize: 13, color: AppColors.ink),
                              decoration: InputDecoration(
                                hintText: isAr ? 'ابحث بالمنطقة، المطور، المشروع...' : 'Search Area, Developer, Project...',
                                hintStyle: const TextStyle(color: AppColors.muted, fontSize: 12),
                                prefixIcon: const Icon(Icons.search_rounded, color: AppColors.gold, size: 20),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                              ),
                            ),
                          )
                        : Container(
                            key: const ValueKey('title_active'),
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            alignment: isAr ? Alignment.centerRight : Alignment.centerLeft,
                            child: Text(
                              isAr ? 'البيع بالعمولة' : 'Sell on Commission',
                              style: const TextStyle(
                                color: AppColors.ink,
                                fontWeight: FontWeight.w900,
                                fontSize: 16.5,
                                fontFamily: 'Cairo',
                              ),
                            ),
                          ),
                  ),
                ),
                const SizedBox(width: 4),

                // Actions: Advanced Filter Button & Search Toggle button
                Row(
                  children: [
                    // Advanced iOS Filter Icon Trigger
                    IconButton(
                      icon: const Icon(Icons.tune_rounded, color: AppColors.ink, size: 20),
                      onPressed: () => _showFilterSheet(context, isAr),
                    ),
                    const SizedBox(width: 4),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 220),
                      child: _isSearching
                          ? TextButton(
                              key: const ValueKey('cancel_btn'),
                              onPressed: () {
                                setState(() {
                                  _isSearching = false;
                                  _searchController.clear();
                                  searchQuery = '';
                                  _searchFocusNode.unfocus();
                                });
                              },
                              child: Text(
                                isAr ? 'إلغاء' : 'Cancel',
                                style: const TextStyle(
                                  color: AppColors.ink,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  fontFamily: 'Cairo',
                                ),
                              ),
                            )
                          : AnimatedTap(
                              key: const ValueKey('search_btn'),
                              onTap: () {
                                setState(() {
                                  _isSearching = true;
                                });
                                Future.delayed(const Duration(milliseconds: 80), () {
                                  _searchFocusNode.requestFocus();
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: AppColors.paper,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: AppColors.border),
                                ),
                                child: const Icon(Icons.search_rounded, color: AppColors.ink, size: 18),
                              ),
                            ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: BrokerPage(
        padding: EdgeInsets.zero,
        children: [
          // 2. Circular Developer Filters Horizontal Row with "More (+)" button at the end
          SizedBox(
            height: 84,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: circularList.length + 1, // Appending +1 for "More" button
              itemBuilder: (context, index) {
                // If it is the last item, show the "More (+)" Circle
                if (index == circularList.length) {
                  return Container(
                    margin: const EdgeInsets.only(right: 12, top: 8, bottom: 8),
                    child: AnimatedTap(
                      onTap: () => _showDeveloperSearchSheet(context, isAr),
                      child: Container(
                        width: 66,
                        height: 66,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.paper,
                          border: Border.all(color: AppColors.gold, width: 1.5, style: BorderStyle.solid),
                        ),
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.add_rounded, color: AppColors.gold, size: 20),
                            const SizedBox(height: 2),
                            Text(
                              isAr ? 'المزيد' : 'More',
                              style: const TextStyle(
                                color: AppColors.gold,
                                fontSize: 9.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Cairo',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }

                // Render circular developer item
                final dev = circularList[index];
                final name = dev['name'] as String;
                final isSelected = selectedDeveloperFilter.toLowerCase() == name.toLowerCase();
                final logoUrl = dev['logo'] as String?;
                final abbreviation = getDeveloperAbbreviation(name);

                return Container(
                  margin: const EdgeInsets.only(right: 12, top: 8, bottom: 8),
                  child: AnimatedTap(
                    onTap: () {
                      setState(() {
                        selectedDeveloperFilter = name;
                        // Cascading Reset: Reset project filter if developer changes to prevent mismatch!
                        selectedProjectFilter = 'All';
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      width: 66,
                      height: 66,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected ? AppColors.ink : AppColors.paper,
                        border: Border.all(
                          color: isSelected ? AppColors.gold : AppColors.border,
                          width: isSelected ? 2.2 : 1.0,
                        ),
                        boxShadow: [
                          if (isSelected)
                            BoxShadow(
                              color: AppColors.gold.withValues(alpha: 0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(33),
                          child: logoUrl != null
                              ? Image.network(
                                  logoUrl,
                                  fit: BoxFit.contain,
                                  width: 50,
                                  height: 50,
                                  loadingBuilder: (context, child, progress) {
                                    if (progress == null) return child;
                                    return const Center(
                                      child: SizedBox(
                                        height: 12,
                                        width: 12,
                                        child: CircularProgressIndicator(strokeWidth: 1.5, color: AppColors.gold),
                                      ),
                                    );
                                  },
                                  errorBuilder: (context, error, stackTrace) {
                                    return Center(
                                      child: Text(
                                        abbreviation,
                                        style: TextStyle(
                                          color: isSelected ? Colors.white : (dev['color'] as Color? ?? AppColors.ink),
                                          fontWeight: FontWeight.w900,
                                          fontSize: 9.5,
                                          fontFamily: 'Cairo',
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    );
                                  },
                                )
                              : Center(
                                  child: Text(
                                    abbreviation,
                                    style: TextStyle(
                                      color: isSelected ? Colors.white : (dev['color'] as Color? ?? AppColors.ink),
                                      fontWeight: FontWeight.w900,
                                      fontSize: 9.5,
                                      fontFamily: 'Cairo',
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // 3. Quick Active Info Badge — only rendered when filters are on
          if (selectedDeveloperFilter != 'All' || selectedProjectFilter != 'All' || selectedLocation != 'All' || selectedPropertyType != 'All' || minCommissionVal > 0.0) ...[
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
              child: Row(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          if (selectedDeveloperFilter != 'All')
                            _buildActiveFilterIndicator('${isAr ? 'مطور: ' : 'Dev: '}$selectedDeveloperFilter'),
                          if (selectedProjectFilter != 'All')
                            _buildActiveFilterIndicator('${isAr ? 'مشروع: ' : 'Proj: '}$selectedProjectFilter'),
                          if (selectedLocation != 'All')
                            _buildActiveFilterIndicator('${isAr ? 'منطقة: ' : 'Loc: '}${selectedLocation == 'New Cairo' ? (isAr ? 'القاهرة الجديدة' : 'New Cairo') : (selectedLocation == 'New Zayed' ? (isAr ? 'الشيخ زايد الجديدة' : 'New Zayed') : (selectedLocation == '6th of October' ? (isAr ? 'السادس من أكتوبر' : '6th of October') : (selectedLocation == 'North Coast' ? (isAr ? 'الساحل الشمالي' : 'North Coast') : (selectedLocation == 'Sokhna' ? (isAr ? 'العين السخنة' : 'Sokhna') : (selectedLocation == 'Administrative Capital' ? (isAr ? 'العاصمة الإدارية' : 'Administrative Capital') : (selectedLocation == 'El Shorouk' ? (isAr ? 'الشروق' : 'El Shorouk') : (selectedLocation == 'Mostakbal City' ? (isAr ? 'مستقبل سيتي' : 'Mostakbal City') : (selectedLocation == 'Mokattam' ? (isAr ? 'المقطم' : 'Mokattam') : (isAr ? 'الجونة' : 'El Gouna')))))))))}'),
                          if (selectedPropertyType != 'All')
                            _buildActiveFilterIndicator(selectedPropertyType == 'Apartment' ? (isAr ? 'شقة' : 'Apartment') : (selectedPropertyType == 'Villa' ? (isAr ? 'فيلا' : 'Villa') : (isAr ? 'شاليه' : 'Chalet'))),
                          if (minCommissionVal > 0.0)
                            _buildActiveFilterIndicator('${isAr ? 'عمولة > ' : 'Min: > '}${(minCommissionVal / 1000).toStringAsFixed(0)}K'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedDeveloperFilter = 'All';
                        selectedProjectFilter = 'All';
                        selectedLocation = 'All';
                        selectedPropertyType = 'All';
                        minCommissionVal = 0.0;
                      });
                    },
                    child: const Icon(
                      Icons.cancel_rounded,
                      color: AppColors.clay,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
          ] else
            const SizedBox(height: 6),

          // 4. Digital luxury list items
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildDeveloperItemsGrid(filteredProjects, isAr),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveFilterIndicator(String text) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.ink.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: const TextStyle(color: AppColors.ink, fontSize: 9.5, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
      ),
    );
  }

  Widget _buildDeveloperItemsGrid(List<Map<String, dynamic>> items, bool isAr) {
    if (items.isEmpty) {
      return Container(
        height: 250,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off_rounded, color: AppColors.muted, size: 48),
            const SizedBox(height: 12),
            Text(
              isAr ? 'عذراً، لا توجد نتائج مطابقة لخيارات التصفية' : 'Sorry, no matching results found',
              style: const TextStyle(color: AppColors.muted, fontSize: 13, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
            ),
          ],
        ),
      );
    }

    return Column(
      children: items.map((item) {
        final priceInMillions = (item['starting_price'] as int) / 1000000;
        final commissionPct = item['commission_pct'] as double;
        return _ExploreStyleCommissionCard(
          title: isAr ? item['project'] : item['project_en'],
          developer: item['developer'],
          location: isAr ? item['location'] : item['location_en'],
          price: item['starting_price'],
          commissionPct: commissionPct,
          commissionVal: item['max_commission'],
          area: 0,
          image: item['image'],
          unitCode: item['unit_code'],
          isAr: isAr,
          isDeveloperProject: true,
          developerBadge: isAr ? item['badge'] : item['badge_en'],
          onCalculate: () => _showProfitCalculator(
            context, 
            isAr, 
            priceMillions: priceInMillions, 
            commissionRate: commissionPct,
          ),
        );
      }).toList(),
    );
  }
}

// ==========================================
// Explore-Style Premium Commission Property Card
// ==========================================
class _ExploreStyleCommissionCard extends StatelessWidget {
  const _ExploreStyleCommissionCard({
    required this.title,
    required this.developer,
    required this.location,
    required this.price,
    required this.commissionPct,
    required this.commissionVal,
    required this.area,
    required this.image,
    required this.unitCode,
    required this.isAr,
    required this.onCalculate,
    this.isDeveloperProject = false,
    this.developerBadge = '',
  });

  final String title;
  final String developer;
  final String location;
  final int price;
  final double commissionPct;
  final int commissionVal;
  final int area;
  final String image;
  final String unitCode;
  final bool isAr;
  final bool isDeveloperProject;
  final String developerBadge;
  final VoidCallback onCalculate;

  @override
  Widget build(BuildContext context) {
    String formatCurrency(int val) {
      if (val >= 1000000) {
        return '${(val / 1000000).toStringAsFixed(1)}M';
      }
      return val.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 22),
      decoration: BoxDecoration(
        color: AppColors.paper,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.border, width: 1.0),
        boxShadow: [
          BoxShadow(
            color: AppColors.ink.withValues(alpha: 0.015),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Hero image & overlays
          SizedBox(
            height: 185,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.network(
                    image,
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
                        child: const Icon(
                          Icons.image_rounded,
                          color: Colors.white24,
                          size: 40,
                        ),
                      );
                    },
                  ),
                ),
                // Left overlay: Unit Code
                Positioned(
                  top: 16,
                  left: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.ink.withValues(alpha: 0.85),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: AppColors.gold.withValues(alpha: 0.5),
                        width: 1.0,
                      ),
                    ),
                    child: Text(
                      unitCode,
                      style: const TextStyle(
                        color: AppColors.gold,
                        fontWeight: FontWeight.w900,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
                // Right overlays: Share & Dedicated Calculator button
                Positioned(
                  top: 16,
                  right: 16,
                  child: Row(
                    children: [
                      // Card level prefilled calculator icon!
                      AnimatedTap(
                        onTap: onCalculate,
                        child: Container(
                          height: 36,
                          width: 36,
                          decoration: const BoxDecoration(
                            color: Colors.black38,
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: const Icon(Icons.calculate_rounded, color: AppColors.gold, size: 18),
                        ),
                      ),
                      const SizedBox(width: 8),
                      AnimatedTap(
                        onTap: () {
                          Get.snackbar(
                            isAr ? 'مشاركة العمولة' : 'Share Commission',
                            isAr ? 'تم نسخ رابط تفاصيل العمولة بنجاح.' : 'Commission details link copied.',
                            backgroundColor: AppColors.ink,
                            colorText: Colors.white,
                          );
                        },
                        child: Container(
                          height: 36,
                          width: 36,
                          decoration: const BoxDecoration(
                            color: Colors.black38,
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: const Icon(Icons.share_rounded, color: Colors.white, size: 16),
                        ),
                      ),
                    ],
                  ),
                ),
                // Bottom developer/location pill
                Positioned(
                  bottom: 16,
                  left: 16,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      color: Colors.black45,
                      child: Row(
                        children: [
                          const Icon(
                            Icons.location_on_rounded,
                            color: AppColors.gold,
                            size: 12,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            developer,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (isDeveloperProject && developerBadge.isNotEmpty)
                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.gold,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        developerBadge,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 9.5, fontFamily: 'Cairo'),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // 2. Info details section
          Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.ink,
                    fontWeight: FontWeight.w900,
                    fontSize: 16.5,
                    fontFamily: 'Cairo',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isAr ? 'مشاريع المطورين المعتمدة للتسويق بالعمولة' : 'Verified Developer Primary Listings',
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 12),

                // Pricing Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isAr ? 'سعر المطور الابتدائي' : 'Developer Start Price',
                          style: const TextStyle(
                            color: AppColors.muted,
                            fontSize: 9.5,
                            fontFamily: 'Cairo',
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${formatCurrency(price)} ج.م',
                          style: const TextStyle(
                            color: AppColors.ink,
                            fontWeight: FontWeight.w900,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          isAr ? 'صافي أرباح العمولات' : 'Broker Net Payout',
                          style: const TextStyle(
                            color: AppColors.muted,
                            fontSize: 9.5,
                            fontFamily: 'Cairo',
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${formatCurrency(commissionVal)} ج.م',
                          style: const TextStyle(
                            color: AppColors.emerald,
                            fontWeight: FontWeight.w900,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                
                const SizedBox(height: 12),
                
                // Translucent Commission Percentage Badge
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.emerald.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.emerald.withValues(alpha: 0.15), width: 1),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.monetization_on_rounded, color: AppColors.emerald, size: 14),
                          const SizedBox(width: 6),
                          Text(
                            isAr 
                                ? 'عمولة مضمونة بنسبة $commissionPct%' 
                                : 'Guaranteed payout of $commissionPct%',
                            style: const TextStyle(
                              color: AppColors.emerald,
                              fontWeight: FontWeight.w800,
                              fontSize: 10,
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Floating card-level calculation button
                    AnimatedTap(
                      onTap: onCalculate,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.gold.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.gold.withValues(alpha: 0.2)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.calculate_rounded, color: AppColors.gold, size: 12),
                            const SizedBox(width: 4),
                            Text(
                              isAr ? 'تفصيل الأرباح' : 'Breakdown',
                              style: const TextStyle(color: AppColors.gold, fontWeight: FontWeight.bold, fontSize: 9.5, fontFamily: 'Cairo'),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 14),

                // Contact icon buttons
                Row(
                  children: [
                    AnimatedTap(
                      onTap: () {
                        Get.snackbar(
                          isAr ? 'الاتصال بالمطور' : 'Call Developer',
                          isAr ? 'جاري الاتصال بمندوب المطور...' : 'Calling developer representative...',
                        );
                      },
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.border, width: 1.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.phone_rounded,
                          color: AppColors.ink,
                          size: 19,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    AnimatedTap(
                      onTap: () {
                        Get.snackbar(
                          'WhatsApp',
                          isAr ? 'جاري فتح محادثة واتساب مع مسؤول العمولات...' : 'Opening WhatsApp with commission manager...',
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      },
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF25D366), Color(0xFF128C7E)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF25D366).withValues(alpha: 0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: const FaIcon(
                          FontAwesomeIcons.whatsapp,
                          color: Colors.white,
                          size: 21,
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

// ==========================================
// Luxurious interactive bottom sheet calculator
// ==========================================
class _ProfitCalculatorSheet extends StatefulWidget {
  const _ProfitCalculatorSheet({
    required this.isAr,
    this.initialPriceMillions = 6.0,
    this.initialCommissionRate = 3.0,
  });

  final bool isAr;
  final double initialPriceMillions;
  final double initialCommissionRate;

  @override
  State<_ProfitCalculatorSheet> createState() => _ProfitCalculatorSheetState();
}

class _ProfitCalculatorSheetState extends State<_ProfitCalculatorSheet> {
  late double unitPriceMillions;
  late double selectedCommissionRate;

  final List<double> ratePresets = [2.0, 2.5, 3.0, 4.0, 5.0, 6.0];

  @override
  void initState() {
    super.initState();
    unitPriceMillions = widget.initialPriceMillions;
    selectedCommissionRate = widget.initialCommissionRate;
  }

  @override
  Widget build(BuildContext context) {
    final priceEgp = unitPriceMillions * 1000000;
    final grossCommission = priceEgp * (selectedCommissionRate / 100);
    final safqaFee = grossCommission * 0.10; 
    final netBrokerProfit = grossCommission - safqaFee;

    String formatCurrency(double val) {
      return val.toStringAsFixed(0).replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), 
        (Match m) => '${m[1]},',
      );
    }

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.paper,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      padding: EdgeInsets.fromLTRB(24, 20, 24, MediaQuery.of(context).viewInsets.bottom + 30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.isAr ? 'حاسبة أرباح الوسطاء والعمولات' : 'Safqa Profit Calculator',
                style: const TextStyle(color: AppColors.ink, fontWeight: FontWeight.w900, fontSize: 16, fontFamily: 'Cairo'),
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded, color: AppColors.muted),
                onPressed: () => Navigator.pop(context),
              )
            ],
          ),
          const SizedBox(height: 18),

          // Unit Price Digital Dial
          Text(
            widget.isAr ? 'سعر الوحدة العقارية المستهدفة *' : 'Target Property Unit Price *',
            style: const TextStyle(color: AppColors.ink, fontWeight: FontWeight.bold, fontSize: 12, fontFamily: 'Cairo'),
          ),
          const SizedBox(height: 8),
          
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    AnimatedTap(
                      onTap: () {
                        if (unitPriceMillions > 1.0) {
                          setState(() => unitPriceMillions -= 1.0);
                        }
                      },
                      child: Container(
                        height: 38,
                        width: 38,
                        decoration: BoxDecoration(
                          color: AppColors.paper,
                          border: Border.all(color: AppColors.border),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: const Icon(Icons.remove_rounded, color: AppColors.ink, size: 18),
                      ),
                    ),
                    const SizedBox(width: 8),
                    AnimatedTap(
                      onTap: () {
                        if (unitPriceMillions > 0.5) {
                          setState(() => unitPriceMillions -= 0.5);
                        }
                      },
                      child: Container(
                        height: 38,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: AppColors.paper,
                          border: Border.all(color: AppColors.border),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          widget.isAr ? '-٠.٥' : '-0.5',
                          style: const TextStyle(color: AppColors.ink, fontWeight: FontWeight.bold, fontSize: 11),
                        ),
                      ),
                    ),
                  ],
                ),
                
                Text(
                  '${unitPriceMillions.toStringAsFixed(1)} ${widget.isAr ? 'مليون ج.م' : 'M EGP'}',
                  style: const TextStyle(color: AppColors.ink, fontWeight: FontWeight.w900, fontSize: 16, fontFamily: 'Cairo'),
                ),

                Row(
                  children: [
                    AnimatedTap(
                      onTap: () {
                        setState(() => unitPriceMillions += 0.5);
                      },
                      child: Container(
                        height: 38,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: AppColors.paper,
                          border: Border.all(color: AppColors.border),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          widget.isAr ? '+٠.٥' : '+0.5',
                          style: const TextStyle(color: AppColors.ink, fontWeight: FontWeight.bold, fontSize: 11),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    AnimatedTap(
                      onTap: () {
                        setState(() => unitPriceMillions += 1.0);
                      },
                      child: Container(
                        height: 38,
                        width: 38,
                        decoration: BoxDecoration(
                          color: AppColors.paper,
                          border: Border.all(color: AppColors.border),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: const Icon(Icons.add_rounded, color: AppColors.ink, size: 18),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Custom Commission Percent Selector Grid
          Text(
            widget.isAr ? 'اختر نسبة عمولة التسويق *' : 'Select Commission Rate *',
            style: const TextStyle(color: AppColors.ink, fontWeight: FontWeight.bold, fontSize: 12, fontFamily: 'Cairo'),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: ratePresets.map((rate) {
              final isSelected = selectedCommissionRate == rate;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: AnimatedTap(
                    onTap: () => setState(() => selectedCommissionRate = rate),
                    scaleDownTo: 0.94,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.gold.withValues(alpha: 0.08) : AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? AppColors.gold : AppColors.border,
                          width: 1.5,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '${rate.toStringAsFixed(1)}%',
                        style: TextStyle(
                          color: isSelected ? AppColors.gold : AppColors.ink,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 24),

          // Luxury Profit Breakdown Container
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.border, width: 1.2),
            ),
            child: Column(
              children: [
                _buildDetailsRow(
                  widget.isAr ? 'إجمالي قيمة عمولة الوحدة' : 'Gross Commission Value', 
                  '${formatCurrency(grossCommission)} ج.م',
                  isBold: true,
                ),
                const Divider(height: 20),
                _buildDetailsRow(
                  widget.isAr ? 'رسوم مطابقة منصة صفقة (١٠٪)' : 'Safqa Platform Escrow Fee (10%)', 
                  '- ${formatCurrency(safqaFee)} ج.م',
                  isRed: true,
                ),
                const Divider(height: 24, thickness: 1.2),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.isAr ? 'صافي أرباحك النقدية (٩٠٪)' : 'Your Net Cash Profit (90%)',
                          style: const TextStyle(color: AppColors.ink, fontWeight: FontWeight.w900, fontSize: 13, fontFamily: 'Cairo'),
                        ),
                        Text(
                          widget.isAr ? 'تودع مباشرة في رصيدك' : 'Deposited directly to wallet',
                          style: const TextStyle(color: AppColors.muted, fontSize: 9.5, fontFamily: 'Cairo'),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.emerald.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.emerald.withValues(alpha: 0.15), width: 1),
                      ),
                      child: Text(
                        '${formatCurrency(netBrokerProfit)} ج.م',
                        style: const TextStyle(color: AppColors.emerald, fontWeight: FontWeight.w900, fontSize: 16, fontFamily: 'Cairo'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildDetailsRow(String label, String val, {bool isBold = false, bool isRed = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppColors.muted, 
            fontSize: 11, 
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            fontFamily: 'Cairo',
          ),
        ),
        Text(
          val,
          style: TextStyle(
            color: isRed 
                ? AppColors.clay 
                : (isBold ? AppColors.ink : AppColors.muted), 
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
