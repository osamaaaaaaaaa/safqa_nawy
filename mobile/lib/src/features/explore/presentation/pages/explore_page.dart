import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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

const List<String> _projectImages = [
  'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?w=600&auto=format&fit=crop&q=80',
  'https://images.unsplash.com/photo-1571896349842-33c89424de2d?w=600&auto=format&fit=crop&q=80',
  'https://images.unsplash.com/photo-1497366216548-37526070297c?w=600&auto=format&fit=crop&q=80',
];

const List<String> _resaleImages = [
  'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?w=600&auto=format&fit=crop&q=80',
  'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?w=600&auto=format&fit=crop&q=80',
  'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?w=600&auto=format&fit=crop&q=80',
  'https://images.unsplash.com/photo-1600607687939-ce8a6c25118c?w=600&auto=format&fit=crop&q=80',
];

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  String searchQuery = '';
  bool showMapToggle = false;

  late PageController _pageController;

  // Search & Filter state variables matching Commission dashboard page
  String selectedDeveloperFilter = 'All';
  String selectedProjectFilter = 'All';
  String selectedLocation = 'All';
  bool _isSearching = false;

  // Filter States
  String selectedPropertyType = 'All'; // All, Villa, Chalet, Apartment
  double minPriceVal = 0.0; // Slider value for target property price

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  // Full developer inventory for searchable pickers
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
    'Modon Developments',
  ];

  // Full location inventory for searchable pickers
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
    'El Gouna',
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 1.0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  // 1. Searchable Developer Selector Modal Sheet
  void _showDeveloperSearchSheet(
    BuildContext context,
    bool isAr, {
    VoidCallback? onSelected,
  }) {
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
                        style: const TextStyle(
                          color: AppColors.ink,
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                          fontFamily: 'Cairo',
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.close_rounded,
                          color: AppColors.muted,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
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
                        const Icon(
                          Icons.search_rounded,
                          color: AppColors.muted,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            onChanged: (val) =>
                                setModalState(() => modalSearch = val),
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.ink,
                            ),
                            decoration: InputDecoration(
                              hintText: isAr
                                  ? 'ابحث باسم المطور (سوديك، إعمار...)'
                                  : 'Search developer (Sodic, Emaar...)',
                              hintStyle: const TextStyle(
                                color: AppColors.muted,
                                fontSize: 12,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Scrollable List of Developers
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredDevs.length,
                      itemBuilder: (context, index) {
                        final devName = filteredDevs[index];
                        final isSel =
                            selectedDeveloperFilter.toLowerCase() ==
                            devName.toLowerCase();
                        final displayLabel = devName == 'All'
                            ? (isAr ? 'كل المطورين' : 'All Developers')
                            : devName;

                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          decoration: BoxDecoration(
                            color: isSel
                                ? AppColors.gold.withValues(alpha: 0.08)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: ListTile(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 2,
                            ),
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
                                color: isSel
                                    ? AppColors.gold
                                    : AppColors.surface,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                devName == 'All'
                                    ? '*'
                                    : devName.substring(
                                        0,
                                        devName.length > 2 ? 2 : devName.length,
                                      ),
                                style: TextStyle(
                                  color: isSel
                                      ? AppColors.ink
                                      : AppColors.muted,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 9.5,
                                ),
                              ),
                            ),
                            title: Text(
                              displayLabel,
                              style: TextStyle(
                                color: AppColors.ink,
                                fontWeight: isSel
                                    ? FontWeight.w900
                                    : FontWeight.w600,
                                fontSize: 13.5,
                                fontFamily: 'Cairo',
                              ),
                            ),
                            trailing: isSel
                                ? const Icon(
                                    Icons.check_circle_rounded,
                                    color: AppColors.gold,
                                    size: 20,
                                  )
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

  // 2. Searchable Project Selector Modal Sheet
  void _showProjectSearchSheet(
    BuildContext context,
    bool isAr, {
    VoidCallback? onSelected,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        String modalSearch = '';
        return StatefulBuilder(
          builder: (context, setModalState) {
            // Get unique projects list from resale database
            final resaleUnits = const ResaleRepository().featuredResaleUnits();
            final rawProjects = resaleUnits
                .where((unit) {
                  if (selectedDeveloperFilter == 'All' ||
                      selectedDeveloperFilter == 'الكل') {
                    return true;
                  }
                  final devLower = unit.developer.toLowerCase();
                  final filterLower = selectedDeveloperFilter.toLowerCase();
                  return devLower.contains(filterLower) ||
                      (filterLower == 'sodic' && devLower.contains('سوديك')) ||
                      (filterLower == 'emaar misr' &&
                          devLower.contains('إعمار')) ||
                      (filterLower == 'ora developers' &&
                          devLower.contains('أورا'));
                })
                .map((unit) {
                  // Extract clean english project name if available, e.g. "Mivida" from "ميفيدا (Mivida)"
                  final pName = unit.projectName;
                  if (pName.contains('(') && pName.contains(')')) {
                    final start = pName.indexOf('(') + 1;
                    final end = pName.indexOf(')');
                    return pName.substring(start, end);
                  }
                  return pName;
                })
                .toSet()
                .toList();

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
                            style: const TextStyle(
                              color: AppColors.ink,
                              fontWeight: FontWeight.w900,
                              fontSize: 16,
                              fontFamily: 'Cairo',
                            ),
                          ),
                          if (selectedDeveloperFilter != 'All')
                            Text(
                              '${isAr ? 'مشاريع مطور: ' : 'Projects of: '}$selectedDeveloperFilter',
                              style: const TextStyle(
                                color: AppColors.muted,
                                fontSize: 10.5,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Cairo',
                              ),
                            ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.close_rounded,
                          color: AppColors.muted,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
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
                        const Icon(
                          Icons.search_rounded,
                          color: AppColors.muted,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            onChanged: (val) =>
                                setModalState(() => modalSearch = val),
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.ink,
                            ),
                            decoration: InputDecoration(
                              hintText: isAr
                                  ? 'ابحث باسم المشروع (ميفيدا، زد، جون...)'
                                  : 'Search project (Mivida, Zed...)',
                              hintStyle: const TextStyle(
                                color: AppColors.muted,
                                fontSize: 12,
                              ),
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
                        final isSel =
                            selectedProjectFilter.toLowerCase() ==
                            projName.toLowerCase();
                        final displayLabel = projName == 'All'
                            ? (isAr ? 'كل المشاريع' : 'All Projects')
                            : projName;

                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          decoration: BoxDecoration(
                            color: isSel
                                ? AppColors.gold.withValues(alpha: 0.08)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: ListTile(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 2,
                            ),
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
                                color: isSel
                                    ? AppColors.gold
                                    : AppColors.surface,
                              ),
                              alignment: Alignment.center,
                              child: const Icon(
                                Icons.business_rounded,
                                color: AppColors.muted,
                                size: 14,
                              ),
                            ),
                            title: Text(
                              displayLabel,
                              style: TextStyle(
                                color: AppColors.ink,
                                fontWeight: isSel
                                    ? FontWeight.w900
                                    : FontWeight.w600,
                                fontSize: 13.5,
                                fontFamily: 'Cairo',
                              ),
                            ),
                            trailing: isSel
                                ? const Icon(
                                    Icons.check_circle_rounded,
                                    color: AppColors.gold,
                                    size: 20,
                                  )
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

  // 3. Searchable Location Selector Modal Sheet
  void _showLocationSearchSheet(
    BuildContext context,
    bool isAr, {
    VoidCallback? onSelected,
  }) {
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
                        style: const TextStyle(
                          color: AppColors.ink,
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                          fontFamily: 'Cairo',
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.close_rounded,
                          color: AppColors.muted,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
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
                        const Icon(
                          Icons.location_on_rounded,
                          color: AppColors.gold,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            onChanged: (val) =>
                                setModalState(() => modalSearch = val),
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.ink,
                            ),
                            decoration: InputDecoration(
                              hintText: isAr
                                  ? 'ابحث باسم المنطقة (التجمع، زايد، الساحل...)'
                                  : 'Search location (Zayed, Tagamoa...)',
                              hintStyle: const TextStyle(
                                color: AppColors.muted,
                                fontSize: 12,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Scrollable List of Locations (No dividers)
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredLocs.length,
                      itemBuilder: (context, index) {
                        final locName = filteredLocs[index];
                        final isSel =
                            selectedLocation.toLowerCase() ==
                            locName.toLowerCase();
                        final displayLabel = locName == 'All'
                            ? (isAr ? 'كل المناطق الجغرافية' : 'All Locations')
                            : (locName == 'New Cairo'
                                  ? (isAr ? 'القاهرة الجديدة' : 'New Cairo')
                                  : (locName == 'New Zayed'
                                        ? (isAr
                                              ? 'الشيخ زايد الجديدة'
                                              : 'New Zayed')
                                        : (locName == '6th of October'
                                              ? (isAr
                                                    ? 'السادس من أكتوبر'
                                                    : '6th of October')
                                              : (locName == 'North Coast'
                                                    ? (isAr
                                                          ? 'الساحل الشمالي'
                                                          : 'North Coast')
                                                    : (locName == 'Sokhna'
                                                          ? (isAr
                                                                ? 'العين السخنة'
                                                                : 'Sokhna')
                                                          : (locName ==
                                                                    'Administrative Capital'
                                                                ? (isAr
                                                                      ? 'العاصمة الإدارية'
                                                                      : 'Administrative Capital')
                                                                : (locName ==
                                                                          'El Shorouk'
                                                                      ? (isAr
                                                                            ? 'الشروق'
                                                                            : 'El Shorouk')
                                                                      : (locName ==
                                                                                'Mostakbal City'
                                                                            ? (isAr
                                                                                  ? 'مستقبل سيتي'
                                                                                  : 'Mostakbal City')
                                                                            : (locName == 'Mokattam'
                                                                                  ? (isAr
                                                                                        ? 'المقطم'
                                                                                        : 'Mokattam')
                                                                                  : (isAr ? 'الجونة' : 'El Gouna'))))))))));

                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          decoration: BoxDecoration(
                            color: isSel
                                ? AppColors.gold.withValues(alpha: 0.08)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: ListTile(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 2,
                            ),
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
                                color: isSel
                                    ? AppColors.gold
                                    : AppColors.surface,
                              ),
                              alignment: Alignment.center,
                              child: const Icon(
                                Icons.location_on_rounded,
                                color: AppColors.muted,
                                size: 14,
                              ),
                            ),
                            title: Text(
                              displayLabel,
                              style: TextStyle(
                                color: AppColors.ink,
                                fontWeight: isSel
                                    ? FontWeight.w900
                                    : FontWeight.w600,
                                fontSize: 13.5,
                                fontFamily: 'Cairo',
                              ),
                            ),
                            trailing: isSel
                                ? const Icon(
                                    Icons.check_circle_rounded,
                                    color: AppColors.gold,
                                    size: 20,
                                  )
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

  // 4. Fluid iOS Filtering Sheet (No borders, extremely minimal and seamless)
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
          padding: EdgeInsets.fromLTRB(
            24,
            20,
            24,
            MediaQuery.of(context).viewInsets.bottom + 30,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isAr ? 'تصفية عقارات استكشف' : 'Filter Properties',
                    style: const TextStyle(
                      color: AppColors.ink,
                      fontWeight: FontWeight.w900,
                      fontSize: 17,
                      fontFamily: 'Cairo',
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.close_rounded,
                      color: AppColors.muted,
                      size: 22,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Fluid Picker Cards Stack
              Column(
                children: [
                  // Developer Picker
                  _buildFluidPickerTile(
                    label: isAr ? 'المطور العقاري' : 'Developer',
                    value: selectedDeveloperFilter == 'All'
                        ? (isAr ? 'كل المطورين' : 'All Developers')
                        : selectedDeveloperFilter,
                    icon: Icons.business_rounded,
                    onTap: () => _showDeveloperSearchSheet(
                      context,
                      isAr,
                      onSelected: () {
                        setModalState(() {});
                      },
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Project Picker
                  _buildFluidPickerTile(
                    label: isAr ? 'المشروع العقاري' : 'Project / Compound',
                    value: selectedProjectFilter == 'All'
                        ? (isAr ? 'كل المشاريع' : 'All Projects')
                        : selectedProjectFilter,
                    icon: Icons.layers_rounded,
                    onTap: () => _showProjectSearchSheet(
                      context,
                      isAr,
                      onSelected: () {
                        setModalState(() {});
                      },
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Location Picker
                  _buildFluidPickerTile(
                    label: isAr ? 'المنطقة الجغرافية' : 'Location',
                    value: selectedLocation == 'All'
                        ? (isAr ? 'كل المناطق الجغرافية' : 'All Locations')
                        : (selectedLocation == 'New Cairo'
                              ? (isAr ? 'القاهرة الجديدة' : 'New Cairo')
                              : (selectedLocation == 'New Zayed'
                                    ? (isAr
                                          ? 'الشيخ زايد الجديدة'
                                          : 'New Zayed')
                                    : (selectedLocation == '6th of October'
                                          ? (isAr
                                                ? 'السادس من أكتوبر'
                                                : '6th of October')
                                          : (selectedLocation == 'North Coast'
                                                ? (isAr
                                                      ? 'الساحل الشمالي'
                                                      : 'North Coast')
                                                : (selectedLocation == 'Sokhna'
                                                      ? (isAr
                                                            ? 'العين السخنة'
                                                            : 'Sokhna')
                                                      : (selectedLocation ==
                                                                'Administrative Capital'
                                                            ? (isAr
                                                                  ? 'العاصمة الإدارية'
                                                                  : 'Administrative Capital')
                                                            : (selectedLocation ==
                                                                      'El Shorouk'
                                                                  ? (isAr
                                                                        ? 'الشروق'
                                                                        : 'El Shorouk')
                                                                  : (selectedLocation ==
                                                                            'Mostakbal City'
                                                                        ? (isAr
                                                                              ? 'مستقبل سيتي'
                                                                              : 'Mostakbal City')
                                                                        : (selectedLocation == 'Mokattam'
                                                                              ? (isAr
                                                                                    ? 'المقطم'
                                                                                    : 'Mokattam')
                                                                              : (isAr ? 'الجونة' : 'El Gouna')))))))))),
                    icon: Icons.location_on_rounded,
                    onTap: () => _showLocationSearchSheet(
                      context,
                      isAr,
                      onSelected: () {
                        setModalState(() {});
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              // Property Type Filter
              Text(
                isAr ? 'نوع العقار' : 'Property Type',
                style: const TextStyle(
                  color: AppColors.ink,
                  fontWeight: FontWeight.bold,
                  fontSize: 12.5,
                  fontFamily: 'Cairo',
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: ['All', 'Apartment', 'Villa', 'Chalet'].map((type) {
                  final label = type == 'All'
                      ? (isAr ? 'الكل' : 'All')
                      : (type == 'Apartment'
                            ? (isAr ? 'شقة' : 'Apartment')
                            : (type == 'Villa'
                                  ? (isAr ? 'فيلا' : 'Villa')
                                  : (isAr ? 'شاليه' : 'Chalet')));
                  final isSel = selectedPropertyType == type;
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: AnimatedTap(
                        onTap: () =>
                            setModalState(() => selectedPropertyType = type),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 9),
                          decoration: BoxDecoration(
                            color: isSel ? AppColors.ink : AppColors.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSel
                                  ? AppColors.gold
                                  : AppColors.border.withValues(alpha: 0.5),
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

              // Target Price Filter (Sleek slider)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isAr ? 'الحد الأقصى لسعر العقار' : 'Max Property Price',
                    style: const TextStyle(
                      color: AppColors.ink,
                      fontWeight: FontWeight.bold,
                      fontSize: 12.5,
                      fontFamily: 'Cairo',
                    ),
                  ),
                  Text(
                    minPriceVal == 0.0
                        ? (isAr ? 'الكل' : 'All')
                        : '${(minPriceVal / 1000000).toStringAsFixed(1)}M ج.م',
                    style: const TextStyle(
                      color: AppColors.gold,
                      fontWeight: FontWeight.w900,
                      fontSize: 12.5,
                      fontFamily: 'Cairo',
                    ),
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
                  thumbShape: const RoundSliderThumbShape(
                    enabledThumbRadius: 8,
                  ),
                ),
                child: Slider(
                  value: minPriceVal,
                  min: 0.0,
                  max: 15000000.0,
                  divisions: 15,
                  onChanged: (val) {
                    setModalState(() => minPriceVal = val);
                  },
                ),
              ),

              const SizedBox(height: 24),

              // Fluid Action Buttons
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
                          minPriceVal = 0.0;
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
                          style: const TextStyle(
                            color: AppColors.ink,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            fontFamily: 'Cairo',
                          ),
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
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            fontFamily: 'Cairo',
                          ),
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
                    style: const TextStyle(
                      color: AppColors.muted,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cairo',
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: const TextStyle(
                      color: AppColors.ink,
                      fontWeight: FontWeight.w900,
                      fontSize: 12.5,
                      fontFamily: 'Cairo',
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: AppColors.muted,
              size: 14,
            ),
          ],
        ),
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
        style: const TextStyle(
          color: AppColors.ink,
          fontSize: 9.5,
          fontWeight: FontWeight.bold,
          fontFamily: 'Cairo',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isAr = Get.locale?.languageCode == 'ar';
    final projects = const ProjectsRepository().featuredProjects();
    final resaleUnits = const ResaleRepository().featuredResaleUnits();
    final settingsController = Get.find<SettingsController>();

    // Initials helper
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
      return clean.length >= 3
          ? clean.substring(0, 3).toUpperCase()
          : clean.toUpperCase();
    }

    // Base default developers circular badges with optional logo URLs
    final List<Map<String, dynamic>> baseDevelopers = [
      {'name': isAr ? 'الكل' : 'All', 'color': AppColors.gold, 'logo': null},
      {
        'name': 'SODIC',
        'color': Colors.black,
        'logo': 'https://logo.clearbit.com/sodic.com',
      },
      {
        'name': 'Emaar Misr',
        'color': Colors.indigo,
        'logo': 'https://logo.clearbit.com/emaar.com',
      },
      {'name': 'Mountain View', 'color': Colors.blue, 'logo': null},
      {'name': 'Ora Developers', 'color': Colors.orange, 'logo': null},
      {
        'name': 'Hyde Park Developments',
        'color': Colors.blueGrey,
        'logo': 'https://logo.clearbit.com/hydepark.com.eg',
      },
    ];

    // Dynamic Preset Circles row insertion
    final circularList = List<Map<String, dynamic>>.from(baseDevelopers);
    final isPresetSelected = circularList.any(
      (d) =>
          d['name'].toString().toLowerCase() ==
          selectedDeveloperFilter.toLowerCase(),
    );
    if (!isPresetSelected &&
        selectedDeveloperFilter != 'All' &&
        selectedDeveloperFilter != 'الكل') {
      circularList.insert(1, {
        'name': selectedDeveloperFilter.toUpperCase(),
        'color': AppColors.gold,
        'logo': null,
      });
    }

    // Filter resale database logic matching all criteria
    final filteredResale = resaleUnits.where((unit) {
      // 1. Search Query Filter
      if (searchQuery.isNotEmpty) {
        final q = searchQuery.toLowerCase();
        final matchesSearch =
            unit.title.toLowerCase().contains(q) ||
            unit.projectName.toLowerCase().contains(q) ||
            unit.developer.toLowerCase().contains(q);
        if (!matchesSearch) return false;
      }

      // 2. Developer Filter (Cross-language equivalence matching)
      if (selectedDeveloperFilter != 'All' &&
          selectedDeveloperFilter != 'الكل') {
        final devLower = unit.developer.toLowerCase();
        final filterLower = selectedDeveloperFilter.toLowerCase();

        bool matches = devLower.contains(filterLower);
        if (filterLower == 'sodic' && devLower.contains('سوديك')) { matches = true; }
        if (filterLower == 'emaar misr' && devLower.contains('إعمار')) { matches = true; }
        if (filterLower == 'ora developers' && devLower.contains('أورا')) { matches = true; }
        if (filterLower == 'mountain view' && devLower.contains('ماونتن')) { matches = true; }
        if (filterLower == 'hyde park developments' &&
            devLower.contains('هايد بارك')) { matches = true; }

        if (!matches) { return false; }
      }

      // 3. Project Filter
      if (selectedProjectFilter != 'All') {
        final projLower = unit.projectName.toLowerCase();
        final filterLower = selectedProjectFilter.toLowerCase();
        if (!projLower.contains(filterLower)) {
          return false;
        }
      }

      // 4. Location Filter (Cross-language matching)
      if (selectedLocation != 'All') {
        final locLower = unit.location.toLowerCase();
        final filterLower = selectedLocation.toLowerCase();

        bool matches = locLower.contains(filterLower);
        if (filterLower == 'new cairo' &&
            (locLower.contains('القاهرة الجديدة') ||
                locLower.contains('التجمع'))) { matches = true; }
        if (filterLower == 'north coast' &&
            (locLower.contains('الساحل الشمالي') ||
                locLower.contains('رأس الحكمة'))) { matches = true; }
        if (filterLower == 'new zayed' &&
            (locLower.contains('الشيخ زايد') || locLower.contains('زايد'))) { matches = true; }
        if (filterLower == '6th of october' && locLower.contains('أكتوبر')) { matches = true; }
        if (filterLower == 'sokhna' && locLower.contains('سخنة')) { matches = true; }
        if (filterLower == 'administrative capital' &&
            locLower.contains('العاصمة الإدارية')) { matches = true; }

        if (!matches) { return false; }
      }

      // 5. Property Type Filter
      if (selectedPropertyType != 'All') {
        final typeLower = unit.unitType.toLowerCase();
        final filterLower = selectedPropertyType.toLowerCase();
        if (!typeLower.contains(filterLower)) {
          return false;
        }
      }

      // 6. Max Price Filter
      if (minPriceVal > 0.0) {
        final priceNum =
            double.tryParse(
              unit.totalPrice.replaceAll(RegExp(r'[^0-9]'), ''),
            ) ??
            0.0;
        if (priceNum > minPriceVal) {
          return false;
        }
      }

      return true;
    }).toList();

    final bool canPop = Navigator.canPop(context);

    return Scaffold(
      backgroundColor: AppColors.surface,
      // Premium Custom iOS Animated Search AppBar
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
                // iOS Back button shown conditionally
                if (canPop && !_isSearching)
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
                              onChanged: (val) =>
                                  setState(() => searchQuery = val),
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.ink,
                              ),
                              decoration: InputDecoration(
                                hintText: isAr
                                    ? 'ابحث بالمنطقة، المطور، الكمبوند...'
                                    : 'Search Area, Developer, Compound...',
                                hintStyle: const TextStyle(
                                  color: AppColors.muted,
                                  fontSize: 12,
                                ),
                                prefixIcon: const Icon(
                                  Icons.search_rounded,
                                  color: AppColors.gold,
                                  size: 20,
                                ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                              ),
                            ),
                          )
                        : Container(
                            key: const ValueKey('title_active'),
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            alignment: isAr
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Text(
                              isAr ? 'استكشف العقارات' : 'Explore Properties',
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

                // AppBar actions (Tune filter and search trigger)
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.tune_rounded,
                        color: AppColors.ink,
                        size: 20,
                      ),
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
                                Future.delayed(
                                  const Duration(milliseconds: 80),
                                  () {
                                    _searchFocusNode.requestFocus();
                                  },
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: AppColors.paper,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: AppColors.border),
                                ),
                                child: const Icon(
                                  Icons.search_rounded,
                                  color: AppColors.ink,
                                  size: 18,
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
      ),
      body: Stack(
        children: [
          BrokerPage(
            padding: EdgeInsets.zero,
            children: [
              // 1. Horizontal Developer Logos Filter Scroll Row
              SizedBox(
                height: 84,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount:
                      circularList.length + 1, // Appending +1 for "More" button
                  itemBuilder: (context, index) {
                    // Show "More (+)" Circle
                    if (index == circularList.length) {
                      return Container(
                        margin: const EdgeInsets.only(
                          right: 12,
                          top: 8,
                          bottom: 8,
                        ),
                        child: AnimatedTap(
                          onTap: () => _showDeveloperSearchSheet(context, isAr),
                          child: Container(
                            width: 66,
                            height: 66,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.paper,
                              border: Border.all(
                                color: AppColors.gold,
                                width: 1.5,
                                style: BorderStyle.solid,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.add_rounded,
                                  color: AppColors.gold,
                                  size: 20,
                                ),
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

                    // Popular Developer item
                    final dev = circularList[index];
                    final name = dev['name'] as String;
                    final isSelected =
                        selectedDeveloperFilter.toLowerCase() ==
                        name.toLowerCase();
                    final logoUrl = dev['logo'] as String?;
                    final abbreviation = getDeveloperAbbreviation(name);

                    return Container(
                      margin: const EdgeInsets.only(
                        right: 12,
                        top: 8,
                        bottom: 8,
                      ),
                      child: AnimatedTap(
                        onTap: () {
                          setState(() {
                            selectedDeveloperFilter = name;
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
                              color: isSelected
                                  ? AppColors.gold
                                  : AppColors.border,
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
                                      loadingBuilder:
                                          (context, child, progress) {
                                            if (progress == null) return child;
                                            return const Center(
                                              child: SizedBox(
                                                height: 12,
                                                width: 12,
                                                child:
                                                    CircularProgressIndicator(
                                                      strokeWidth: 1.5,
                                                      color: AppColors.gold,
                                                    ),
                                              ),
                                            );
                                          },
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return Center(
                                              child: Text(
                                                abbreviation,
                                                style: TextStyle(
                                                  color: isSelected
                                                      ? Colors.white
                                                      : (dev['color']
                                                                as Color? ??
                                                            AppColors.ink),
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
                                          color: isSelected
                                              ? Colors.white
                                              : (dev['color'] as Color? ??
                                                    AppColors.ink),
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

              // Quick Airbnb-style Active Badge strip — only rendered when filters are on
              if (selectedDeveloperFilter != 'All' ||
                  selectedProjectFilter != 'All' ||
                  selectedLocation != 'All' ||
                  selectedPropertyType != 'All' ||
                  minPriceVal > 0.0) ...[
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 2,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              if (selectedDeveloperFilter != 'All')
                                _buildActiveFilterIndicator(
                                  '${isAr ? 'مطور: ' : 'Dev: '}$selectedDeveloperFilter',
                                ),
                              if (selectedProjectFilter != 'All')
                                _buildActiveFilterIndicator(
                                  '${isAr ? 'مشروع: ' : 'Proj: '}$selectedProjectFilter',
                                ),
                              if (selectedLocation != 'All')
                                _buildActiveFilterIndicator(
                                  '${isAr ? 'منطقة: ' : 'Loc: '}${selectedLocation == 'New Cairo' ? (isAr ? 'القاهرة الجديدة' : 'New Cairo') : (selectedLocation == 'New Zayed' ? (isAr ? 'الشيخ زايد الجديدة' : 'New Zayed') : (selectedLocation == '6th of October' ? (isAr ? 'السادس من أكتوبر' : '6th of October') : (selectedLocation == 'North Coast' ? (isAr ? 'الساحل الشمالي' : 'North Coast') : (selectedLocation == 'Sokhna' ? (isAr ? 'العين السخنة' : 'Sokhna') : (selectedLocation == 'Administrative Capital' ? (isAr ? 'العاصمة الإدارية' : 'Administrative Capital') : (selectedLocation == 'El Shorouk' ? (isAr ? 'الشروق' : 'El Shorouk') : (selectedLocation == 'Mostakbal City' ? (isAr ? 'مستقبل سيتي' : 'Mostakbal City') : (selectedLocation == 'Mokattam' ? (isAr ? 'المقطم' : 'Mokattam') : (isAr ? 'الجونة' : 'El Gouna')))))))))}',
                                ),
                              if (selectedPropertyType != 'All')
                                _buildActiveFilterIndicator(
                                  selectedPropertyType == 'Apartment'
                                      ? (isAr ? 'شقة' : 'Apartment')
                                      : (selectedPropertyType == 'Villa'
                                            ? (isAr ? 'فيلا' : 'Villa')
                                            : (isAr ? 'شاليه' : 'Chalet')),
                                ),
                              if (minPriceVal > 0.0)
                                _buildActiveFilterIndicator(
                                  '${isAr ? 'سعر < ' : 'Price < '}${(minPriceVal / 1000000).toStringAsFixed(1)}M',
                                ),
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
                            minPriceVal = 0.0;
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
                const SizedBox(height: 10),
              ] else
                const SizedBox(height: 8),

              // 2. Launches & Offers Carousel Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isAr ? 'عروض وإطلاقات حصرية' : 'Launches & Offers',
                      style: const TextStyle(
                        color: AppColors.ink,
                        fontWeight: FontWeight.w900,
                        fontSize: 15,
                        fontFamily: 'Cairo',
                      ),
                    ),
                    Text(
                      isAr ? 'عرض الكل' : 'Show all',
                      style: const TextStyle(
                        color: AppColors.gold,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              // const SizedBox(height: 5),

              // Full-Width Sleek Launches Carousel (Zero borders, zero shadow)
              SizedBox(
                height: 160,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: projects.length,
                  itemBuilder: (context, index) {
                    final proj = projects[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: AppColors.ink,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Image.network(
                              index < _projectImages.length
                                  ? _projectImages[index]
                                  : _projectImages[0],
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
                                    Icons.business_rounded,
                                    color: Colors.white24,
                                    size: 40,
                                  ),
                                );
                              },
                            ),
                          ),
                          Positioned.fill(
                            child: Container(
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Colors.black87, Colors.transparent],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 18,
                            left: 18,
                            right: 18,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                StatusPill(
                                  label: proj.badge,
                                  color: AppColors.gold,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  proj.name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.5,
                                    fontFamily: 'Cairo',
                                  ),
                                ),
                                Text(
                                  proj.location,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 10.5,
                                    fontFamily: 'Cairo',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 4),

              // 4. Compounds list header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isAr
                              ? 'الوحدات العقارية المتاحة'
                              : 'Compounds in Egypt',
                          style: const TextStyle(
                            color: AppColors.ink,
                            fontWeight: FontWeight.w900,
                            fontSize: 15,
                            fontFamily: 'Cairo',
                          ),
                        ),
                        Text(
                          '${filteredResale.length} ${isAr ? 'نتائج مطابقة' : 'Available Results'}',
                          style: const TextStyle(
                            color: AppColors.muted,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                    IconButton.outlined(
                      style: IconButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: const BorderSide(color: AppColors.border),
                      ),
                      onPressed: () => _showFilterSheet(context, isAr),
                      icon: const Icon(
                        Icons.tune_rounded,
                        color: AppColors.ink,
                        size: 18,
                      ),
                    ),
                  ],
                ),
              ),

              // const SizedBox(height: 2),

              // 5. Large Property Cards List
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: filteredResale.isEmpty
                    ? Container(
                        height: 250,
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.search_off_rounded,
                              color: AppColors.muted,
                              size: 48,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              isAr
                                  ? 'عذراً، لا توجد نتائج مطابقة لخيارات التصفية'
                                  : 'Sorry, no matching results found',
                              style: const TextStyle(
                                color: AppColors.muted,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Cairo',
                              ),
                            ),
                          ],
                        ),
                      )
                    : Obx(() {
                        final hidePayout = settingsController.clientMode.value;

                        return Column(
                          children: List.generate(filteredResale.length, (
                            index,
                          ) {
                            final unit = filteredResale[index];
                            final origIndex = resaleUnits.indexWhere(
                              (u) => u.id == unit.id,
                            );
                            final imgUrl =
                                origIndex >= 0 &&
                                    origIndex < _resaleImages.length
                                ? _resaleImages[origIndex]
                                : _resaleImages[0];

                            return _NawyBigPropertyCard(
                              unit: unit,
                              isAr: isAr,
                              hidePayout: hidePayout,
                              imageUrl: imgUrl,
                            );
                          }),
                        );
                      }),
              ),
              const SizedBox(height: 80),
            ],
          ),

          // 7. Floating Immersive Map/List toggle button
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
                        ? (isAr
                              ? 'تم فتح عرض الخرائط التفاعلي'
                              : 'Switched to interactive Map View')
                        : (isAr
                              ? 'تم فتح عرض القوائم'
                              : 'Switched to list layout view'),
                    snackPosition: SnackPosition.BOTTOM,
                  );
                },
                child: Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  decoration: BoxDecoration(
                    color: AppColors.ink,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        showMapToggle ? Icons.list_rounded : Icons.map_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        showMapToggle
                            ? (isAr ? 'عرض القائمة' : 'Properties View')
                            : (isAr ? 'عرض الخريطة' : 'Map View'),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
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
    required this.imageUrl,
  });

  final ResaleUnit unit;
  final bool isAr;
  final bool hidePayout;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
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
          // 1. Big Hero Image with overlay tags
          SizedBox(
            height: 185,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.network(
                    imageUrl,
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
                // Overlays
                Positioned(
                  top: 16,
                  left: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.ink.withValues(alpha: 0.85),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: AppColors.gold.withValues(alpha: 0.5),
                        width: 1.0,
                      ),
                    ),
                    child: Text(
                      unit.unitCode,
                      style: const TextStyle(
                        color: AppColors.gold,
                        fontWeight: FontWeight.w900,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 16,
                  right: 16,
                  child: Row(
                    children: [
                      const _ImageCircleActionButton(
                        icon: Icons.share_rounded,
                      ),
                      const SizedBox(width: 8),
                      _FavoriteHeartButton(),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 16,
                  left: 16,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
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
                            unit.developer,
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
                // Overlapping Developer Logo bottom right
                Positioned(
                  bottom: -6,
                  right: 18,
                  child: Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                      color: AppColors.paper,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.border, width: 2.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      unit.projectName.split(' ').first,
                      style: const TextStyle(
                        color: AppColors.ink,
                        fontWeight: FontWeight.w900,
                        fontSize: 8.5,
                      ),
                      textAlign: TextAlign.center,
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
                  unit.projectName,
                  style: const TextStyle(
                    color: AppColors.ink,
                    fontWeight: FontWeight.w900,
                    fontSize: 16.5,
                    fontFamily: 'Cairo',
                  ),
                ),
                const SizedBox(height: 4),
                // Typology row
                Text(
                  isAr
                      ? 'فيلا • شاليه • توين هاوس • تاون هاوس'
                      : 'Villa • Chalet • Twinhouse • Townhouse',
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 14),
                const Divider(
                  height: 1,
                  thickness: 1.0,
                  color: AppColors.border,
                ),
                const SizedBox(height: 14),

                // Price details
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isAr
                              ? 'الكاش المطلوب للوساطة'
                              : 'Developer start price',
                          style: const TextStyle(
                            color: AppColors.muted,
                            fontSize: 9.5,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          unit.cashRequired,
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
                          isAr ? 'سعر التنازل النهائي' : 'Resale start price',
                          style: const TextStyle(
                            color: AppColors.muted,
                            fontSize: 9.5,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          unit.marketSavings,
                          style: const TextStyle(
                            color: AppColors.orange,
                            fontWeight: FontWeight.w900,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                if (!hidePayout) ...[
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(
                        Icons.monetization_on_rounded,
                        color: AppColors.gold,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        unit.commission,
                        style: const TextStyle(
                          color: AppColors.emerald,
                          fontWeight: FontWeight.w800,
                          fontSize: 11.5,
                        ),
                      ),
                    ],
                  ),
                ],

                const SizedBox(height: 16),

                // 3. Two Action Icon Buttons (Call / WhatsApp)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedTap(
                      onTap: () => Get.to(() => ResaleDetailsPage(unit: unit)),
                      child: Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.border,
                            width: 1.2,
                          ),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.phone_rounded,
                          color: AppColors.ink,
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    AnimatedTap(
                      onTap: () {
                        Get.snackbar(
                          'WhatsApp',
                          isAr
                              ? 'جاري فتح المحادثة الآمنة مع مسؤول التوثيق والصفقات...'
                              : 'Opening secure chat with closing administrator...',
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      },
                      child: Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF25D366), Color(0xFF128C7E)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF25D366).withValues(alpha: 0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: const FaIcon(
                          FontAwesomeIcons.whatsapp,
                          color: Colors.white,
                          size: 22,
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

class _ImageCircleActionButton extends StatelessWidget {
  const _ImageCircleActionButton({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return AnimatedTap(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          color: Colors.black45,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 15),
      ),
    );
  }
}

class _FavoriteHeartButton extends StatefulWidget {
  @override
  State<_FavoriteHeartButton> createState() => _FavoriteHeartButtonState();
}

class _FavoriteHeartButtonState extends State<_FavoriteHeartButton>
    with SingleTickerProviderStateMixin {
  bool _isLiked = false;
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.4), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.4, end: 1.0), weight: 50),
    ]).animate(_animController);
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _isLiked = !_isLiked;
          });
          _animController.forward(from: 0.0);
        },
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            color: Colors.black45,
            shape: BoxShape.circle,
          ),
          child: Icon(
            _isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
            color: _isLiked ? Colors.redAccent : Colors.white,
            size: 15,
          ),
        ),
      ),
    );
  }
}
