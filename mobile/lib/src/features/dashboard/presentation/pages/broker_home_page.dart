import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:ui';

import '../../../../core/controllers/locale_controller.dart';
import '../../../../core/controllers/settings_controller.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/animated_tap.dart';
import '../../../../shared/widgets/status_pill.dart';
import '../../../deals/data/repositories/deals_repository.dart';
import '../../../deals/presentation/pages/deals_page.dart';
import '../../../explore/data/repositories/resale_repository.dart';
import '../../../explore/domain/entities/resale_unit.dart';
import '../../../explore/presentation/pages/resale_details_page.dart';
import '../../../leads/data/repositories/leads_repository.dart';
import '../../../leads/presentation/pages/leads_page.dart';
import '../../../wallet/data/repositories/wallet_repository.dart';
import '../../../wallet/presentation/pages/wallet_page.dart';
import '../../../transfer/presentation/pages/conversational_create_resale_page.dart';

class BrokerHomePage extends StatefulWidget {
  const BrokerHomePage({super.key});

  @override
  State<BrokerHomePage> createState() => _BrokerHomePageState();
}

class _BrokerHomePageState extends State<BrokerHomePage> {
  late PageController _pageController;
  double _currentPage = 0.0;
  bool _isMenuOpen = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.88);
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page ?? 0.0;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final resaleUnits = const ResaleRepository().featuredResaleUnits();
    final isAr = Get.locale?.languageCode == 'ar';
    final settingsController = Get.find<SettingsController>();

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Stack(
        children: [
          // 1. Immersive Radial Background Glowing orb
          Positioned(
            top: -100,
            right: -50,
            child: Container(
              height: 250,
              width: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.gold.withValues(alpha: 0.08),
                    blurRadius: 120,
                    spreadRadius: 40,
                  )
                ],
              ),
            ),
          ),

          // 2. Main Title Header (No emojis, clean vector icon layout)
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        isAr ? 'منصة التنازل الآمنة' : 'Safqa Resale Deck',
                        style: const TextStyle(
                          color: AppColors.ink,
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        isAr ? 'تصفح محفظة الفرص العقارية الحصرية' : 'Exclusive real estate resale portfolio',
                        style: const TextStyle(color: AppColors.muted, fontSize: 10),
                      )
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.gold.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.shield_rounded, color: AppColors.gold, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          isAr ? 'بروكر معتمد' : 'Escrow Broker',
                          style: const TextStyle(color: AppColors.gold, fontWeight: FontWeight.bold, fontSize: 9),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),

          // 3. Immersive 3D perspective PageView Deck
          Positioned.fill(
            top: 100,
            bottom: 120,
            child: PageView.builder(
              controller: _pageController,
              itemCount: resaleUnits.length,
              itemBuilder: (context, index) {
                final unit = resaleUnits[index];

                // Calculate the 3D perspective transform parameters
                final percent = (index - _currentPage);
                final rotation = percent * 0.12; // Rotate slightly as it moves
                final scale = (1.0 - (percent.abs() * 0.08)).clamp(0.8, 1.0);
                final opacity = (1.0 - (percent.abs() * 0.4)).clamp(0.0, 1.0);

                return Transform(
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001) // perspective
                    ..rotateY(rotation)
                    ..scale(scale, scale, 1.0),
                  alignment: Alignment.center,
                  child: Opacity(
                    opacity: opacity,
                    child: _ImmersiveResaleCard(
                      unit: unit,
                      isAr: isAr,
                      settingsController: settingsController,
                    ),
                  ),
                );
              },
            ),
          ),

          // 4. Custom Radial Floating Command Hub Button (Bottom Center)
          Positioned(
            left: 0,
            right: 0,
            bottom: 30,
            child: Center(
              child: AnimatedTap(
                onTap: () => setState(() => _isMenuOpen = !_isMenuOpen),
                child: Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    color: AppColors.ink,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.gold.withValues(alpha: 0.3),
                        blurRadius: 16,
                        spreadRadius: 2,
                      )
                    ],
                  ),
                  child: Icon(
                    _isMenuOpen ? Icons.close_rounded : Icons.grid_view_rounded,
                    color: AppColors.gold,
                    size: 26,
                  ),
                ),
              ),
            ),
          ),

          // 5. Radial blurred menu overlay (when _isMenuOpen is true)
          if (_isMenuOpen)
            Positioned.fill(
              child: _RadialMenuOverlay(
                isAr: isAr,
                settingsController: settingsController,
                onClose: () => setState(() => _isMenuOpen = false),
                onWorkspaceTap: () {
                  setState(() => _isMenuOpen = false);
                  _showWorkspaceDrawer(context, isAr);
                },
              ),
            ),
        ],
      ),
    );
  }

  // Radial overlay drawer listing Leads & escrow deals
  void _showWorkspaceDrawer(BuildContext context, bool isAr) {
    final leads = const LeadsRepository().activeLeads();
    final deals = const DealsRepository().activeDeals();
    final wallet = const WalletRepository();
    final settingsController = Get.find<SettingsController>();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              color: AppColors.surface.withValues(alpha: 0.94),
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      height: 5,
                      width: 50,
                      decoration: BoxDecoration(
                        color: AppColors.border,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    isAr ? 'حقيبة أعمالي والمحفظة' : 'My Wallet & CRM Portfolio',
                    style: const TextStyle(color: AppColors.ink, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 16),

                  // Wallet Bar
                  Obx(
                    () => Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.paper,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.account_balance_wallet_rounded, color: AppColors.gold),
                              const SizedBox(width: 10),
                              Text(isAr ? 'رصيد المحفظة المتاح' : 'Available Balance', style: const TextStyle(fontSize: 12, color: AppColors.muted)),
                            ],
                          ),
                          Text(
                            settingsController.clientMode.value ? '***' : wallet.availableBalance.split(' ').first,
                            style: const TextStyle(color: AppColors.gold, fontWeight: FontWeight.bold, fontSize: 14),
                          )
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Quick navigation links
                  ListTile(
                    leading: const Icon(Icons.people_alt_rounded, color: AppColors.gold),
                    title: Text(isAr ? 'العملاء النشطين' : 'Active CRM Leads'),
                    subtitle: Text('${leads.length} ${isAr ? 'عملاء مسجلين' : 'leads registered'}'),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                    onTap: () {
                      Navigator.pop(context);
                      Get.to(() => const LeadsPage());
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.swap_horiz_rounded, color: AppColors.gold),
                    title: Text(isAr ? 'صفقات التنازل الجارية' : 'Active Escrow Deals'),
                    subtitle: Text('${deals.length} ${isAr ? 'عقود قيد الإجراء' : 'escrow deals'}'),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                    onTap: () {
                      Navigator.pop(context);
                      Get.to(() => const DealsPage());
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.monetization_on_rounded, color: AppColors.gold),
                    title: Text(isAr ? 'طلبات سحب الأرباح' : 'Payout Requests'),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                    onTap: () {
                      Navigator.pop(context);
                      Get.to(() => const WalletPage());
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ImmersiveResaleCard extends StatelessWidget {
  const _ImmersiveResaleCard({
    required this.unit,
    required this.isAr,
    required this.settingsController,
  });

  final ResaleUnit unit;
  final bool isAr;
  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    return AnimatedTap(
      onTap: () => Get.to(() => ResaleDetailsPage(unit: unit)),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.paper,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: AppColors.ink.withValues(alpha: 0.05),
              blurRadius: 20,
              offset: const Offset(0, 8),
            )
          ],
          border: Border.all(color: AppColors.border),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Stack(
            children: [
              // 1. High-fidelity architectural mockup image simulation
              Positioned.fill(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Center(
                    child: Icon(Icons.apartment_rounded, color: AppColors.gold.withValues(alpha: 0.1), size: 100),
                  ),
                ),
              ),

              // 2. Dark glass overlay
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.5),
                        Colors.black.withValues(alpha: 0.9),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),

              // 3. Status Badge and Code
              Positioned(
                top: 24,
                left: 24,
                right: 24,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    StatusPill(label: unit.unitCode, color: AppColors.gold),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(color: Colors.white10, shape: BoxShape.circle),
                      child: const Icon(Icons.verified_user_rounded, color: AppColors.emerald, size: 16),
                    ),
                  ],
                ),
              ),

              // 4. Financial Specs Deck Overlay (Bottom half of card)
              Positioned(
                bottom: 24,
                left: 24,
                right: 24,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      unit.projectName,
                      style: const TextStyle(color: AppColors.gold, fontWeight: FontWeight.w800, fontSize: 13, letterSpacing: 0.5),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      unit.title,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 18),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _SpecIndicator(icon: Icons.hotel_rounded, val: '${unit.bedrooms}'),
                        const SizedBox(width: 16),
                        _SpecIndicator(icon: Icons.bathtub_rounded, val: '${unit.bathrooms}'),
                        const SizedBox(width: 16),
                        _SpecIndicator(icon: Icons.square_foot_rounded, val: '${unit.area.toInt()}m²'),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Divider(color: Colors.white24, height: 1),
                    const SizedBox(height: 16),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(isAr ? 'الكاش المطلوبة' : 'Cash Required', style: const TextStyle(color: Colors.white54, fontSize: 8)),
                            const SizedBox(height: 4),
                            Text(
                              unit.cashRequired.split(' ').first,
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(isAr ? 'مكسب المشتري الفوري' : 'Buyer instant Savings', style: const TextStyle(color: Colors.white54, fontSize: 8)),
                            const SizedBox(height: 4),
                            Text(
                              unit.marketSavings.split(' ').first,
                              style: const TextStyle(color: AppColors.emerald, fontWeight: FontWeight.w900, fontSize: 16),
                            ),
                          ],
                        )
                      ],
                    ),

                    Obx(
                      () => !settingsController.clientMode.value
                          ? Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: Row(
                                children: [
                                  const Icon(Icons.monetization_on_rounded, color: AppColors.emerald, size: 14),
                                  const SizedBox(width: 6),
                                  Text(
                                    unit.commission,
                                    style: const TextStyle(color: AppColors.emerald, fontWeight: FontWeight.bold, fontSize: 11),
                                  )
                                ],
                              ),
                            )
                          : const SizedBox(),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _SpecIndicator extends StatelessWidget {
  const _SpecIndicator({required this.icon, required this.val});

  final IconData icon;
  final String val;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.gold, size: 14),
        const SizedBox(width: 4),
        Text(val, style: const TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class _RadialMenuOverlay extends StatelessWidget {
  const _RadialMenuOverlay({
    required this.isAr,
    required this.settingsController,
    required this.onClose,
    required this.onWorkspaceTap,
  });

  final bool isAr;
  final SettingsController settingsController;
  final VoidCallback onClose;
  final VoidCallback onWorkspaceTap;

  @override
  Widget build(BuildContext context) {
    final localeController = Get.find<LocaleController>();

    return GestureDetector(
      onTap: onClose,
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            color: Colors.black.withValues(alpha: 0.6),
            child: Stack(
              children: [
                // Option 1: List resale property (Conversational wizard)
                Positioned(
                  bottom: 120,
                  left: 40,
                  child: _MenuOptionItem(
                    icon: Icons.chat_rounded,
                    label: isAr ? 'إدراج وحدة حوارياً' : 'List Unit Chat',
                    onTap: () {
                      onClose();
                      Get.to(() => const ConversationalCreateResalePage());
                    },
                  ),
                ),

                // Option 2: Workspace drawer
                Positioned(
                  bottom: 180,
                  left: MediaQuery.of(context).size.width / 2 - 40,
                  child: _MenuOptionItem(
                    icon: Icons.cases_rounded,
                    label: isAr ? 'محفظة أعمالي كبروكر' : 'Workspace Hub',
                    onTap: onWorkspaceTap,
                  ),
                ),

                // Option 3: Client presentation toggle
                Positioned(
                  bottom: 120,
                  right: 40,
                  child: Obx(
                    () => _MenuOptionItem(
                      icon: settingsController.clientMode.value ? Icons.visibility_rounded : Icons.visibility_off_rounded,
                      label: settingsController.clientMode.value
                          ? (isAr ? 'إظهار العمولات' : 'Show Commissions')
                          : (isAr ? 'إخفاء العمولات' : 'Hide Commissions'),
                      onTap: () {
                        settingsController.toggleClientMode();
                      },
                    ),
                  ),
                ),

                // Option 4: Switch Language
                Positioned(
                  bottom: 240,
                  left: 60,
                  child: _MenuOptionItem(
                    icon: Icons.language_rounded,
                    label: localeController.isArabic ? 'English' : 'عربي',
                    onTap: () {
                      localeController.toggleLocale();
                      onClose();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MenuOptionItem extends StatelessWidget {
  const _MenuOptionItem({required this.icon, required this.label, required this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedTap(
          onTap: onTap,
          child: Container(
            height: 54,
            width: 54,
            decoration: BoxDecoration(
              color: AppColors.paper,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.gold, width: 1.5),
            ),
            child: Icon(icon, color: AppColors.gold, size: 20),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
