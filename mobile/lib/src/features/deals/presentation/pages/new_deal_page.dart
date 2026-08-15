import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/controllers/navigation_controller.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/animated_tap.dart';
import '../../../broker_contracts/data/repositories/projects_repository.dart';

class NewDealPage extends StatefulWidget {
  const NewDealPage({super.key, this.preSelectedProject});

  final String? preSelectedProject;

  @override
  State<NewDealPage> createState() => _NewDealPageState();
}

class _NewDealPageState extends State<NewDealPage> {
  final _formKey = GlobalKey<FormState>();

  final _clientNameController = TextEditingController();
  final _clientPhoneController = TextEditingController();
  final _contractValueController = TextEditingController();

  final List<ProjectModel> _projects = const ProjectsRepository().allProjects();
  ProjectModel? _selectedProject;
  List<UnitModel> _availableUnits = [];
  UnitModel? _selectedUnit;

  double _estimatedCommission = 0.0;

  // Document Upload Mock State: 0 = Idle, 1 = Uploading, 2 = Uploaded
  int _uploadState = 0;
  double _uploadProgress = 0.0;
  Timer? _uploadTimer;

  @override
  void initState() {
    super.initState();
    if (widget.preSelectedProject != null) {
      final index = _projects.indexWhere(
        (p) => p.name == widget.preSelectedProject,
      );
      if (index != -1) {
        _selectedProject = _projects[index];
        _availableUnits = _selectedProject!.units;
      }
    }
  }

  @override
  void dispose() {
    _clientNameController.dispose();
    _clientPhoneController.dispose();
    _contractValueController.dispose();
    _uploadTimer?.cancel();
    super.dispose();
  }

  void _onProjectChanged(ProjectModel? project) {
    setState(() {
      _selectedProject = project;
      _availableUnits = project != null ? project.units : [];
      _selectedUnit = null;
      _contractValueController.clear();
      _estimatedCommission = 0.0;
    });
  }

  void _onUnitChanged(UnitModel? unit) {
    setState(() {
      _selectedUnit = unit;
      if (unit != null) {
        _contractValueController.text = unit.priceValue.toStringAsFixed(0);
        _estimatedCommission = (unit.priceValue * unit.commissionRate) / 100;
      } else {
        _contractValueController.clear();
        _estimatedCommission = 0.0;
      }
    });
  }

  void _simulateUpload() {
    if (_uploadState == 2) return;

    setState(() {
      _uploadState = 1;
      _uploadProgress = 0.0;
    });

    _uploadTimer?.cancel();
    _uploadTimer = Timer.periodic(const Duration(milliseconds: 150), (timer) {
      setState(() {
        if (_uploadProgress < 1.0) {
          _uploadProgress += 0.1;
        } else {
          _uploadState = 2;
          timer.cancel();
        }
      });
    });
  }

  void _submitDeal() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_uploadState != 2) {
      Get.snackbar(
        'form.error.title'.tr,
        'form.error.upload_docs'.tr,
        backgroundColor: AppColors.clay,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return _SuccessDialog(
          projectName: _selectedProject?.name ?? '',
          unitCode: _selectedUnit?.code ?? '',
          commission: _estimatedCommission,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.transparent, // transparent to let background show
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'form.title'.tr,
          style: textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w900,
            color: AppColors.ink,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.gold.withValues(alpha: .1),
                    border: Border.all(
                      color: AppColors.gold.withValues(alpha: .2),
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.info_outline_rounded,
                        color: AppColors.gold,
                        size: 20,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          'form.banner.info'.tr,
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.ink,
                            height: 1.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                Text(
                  'form.section.client'.tr,
                  style: textTheme.titleMedium?.copyWith(color: AppColors.gold),
                ),
                const SizedBox(height: AppSpacing.sm),

                TextFormField(
                  controller: _clientNameController,
                  validator: (value) => value == null || value.isEmpty
                      ? 'form.validation.required'.tr
                      : null,
                  style: const TextStyle(color: AppColors.ink),
                  decoration: InputDecoration(
                    labelText: 'form.client.name'.tr,
                    prefixIcon: const Icon(
                      Icons.person_outline,
                      color: AppColors.muted,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),

                TextFormField(
                  controller: _clientPhoneController,
                  keyboardType: TextInputType.phone,
                  validator: (value) => value == null || value.isEmpty
                      ? 'form.validation.required'.tr
                      : null,
                  style: const TextStyle(color: AppColors.ink),
                  decoration: InputDecoration(
                    labelText: 'form.client.phone'.tr,
                    prefixIcon: const Icon(
                      Icons.phone_outlined,
                      color: AppColors.muted,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                Text(
                  'form.section.deal'.tr,
                  style: textTheme.titleMedium?.copyWith(color: AppColors.gold),
                ),
                const SizedBox(height: AppSpacing.sm),

                DropdownButtonFormField<ProjectModel>(
                  initialValue: _selectedProject,
                  dropdownColor: AppColors.paper,
                  style: const TextStyle(color: AppColors.ink),
                  decoration: InputDecoration(
                    labelText: 'form.deal.project'.tr,
                    prefixIcon: const Icon(
                      Icons.location_city_outlined,
                      color: AppColors.muted,
                    ),
                  ),
                  items: _projects.map((ProjectModel project) {
                    return DropdownMenuItem<ProjectModel>(
                      value: project,
                      child: Text(project.name),
                    );
                  }).toList(),
                  onChanged: _onProjectChanged,
                  validator: (value) =>
                      value == null ? 'form.validation.required'.tr : null,
                ),
                const SizedBox(height: AppSpacing.md),

                DropdownButtonFormField<UnitModel>(
                  key: ValueKey(_selectedProject?.name ?? ''),
                  initialValue: _selectedUnit,
                  dropdownColor: AppColors.paper,
                  style: const TextStyle(color: AppColors.ink),
                  decoration: InputDecoration(
                    labelText: 'form.deal.unit'.tr,
                    prefixIcon: const Icon(
                      Icons.tag_outlined,
                      color: AppColors.muted,
                    ),
                    hintText: _selectedProject == null
                        ? 'form.deal.select_project_first'.tr
                        : null,
                  ),
                  items: _availableUnits.map((UnitModel unit) {
                    return DropdownMenuItem<UnitModel>(
                      value: unit,
                      child: Text(
                        '${unit.code} (${unit.type} • ${unit.price})',
                      ),
                    );
                  }).toList(),
                  onChanged: _selectedProject == null ? null : _onUnitChanged,
                  validator: (value) =>
                      value == null ? 'form.validation.required'.tr : null,
                ),
                const SizedBox(height: AppSpacing.md),

                TextFormField(
                  controller: _contractValueController,
                  readOnly: true,
                  style: const TextStyle(
                    color: AppColors.ink,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: InputDecoration(
                    labelText: 'form.deal.value'.tr,
                    prefixIcon: const Icon(
                      Icons.monetization_on_outlined,
                      color: AppColors.muted,
                    ),
                    fillColor: AppColors.paper.withValues(alpha: .5),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                // Live Commission Estimator display (Animated height entry)
                AnimatedSize(
                  duration: const Duration(milliseconds: 350),
                  curve: Curves.easeOutBack,
                  child: (_selectedUnit != null && _estimatedCommission > 0)
                      ? Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: AppSpacing.lg),
                          padding: const EdgeInsets.all(AppSpacing.md),
                          decoration: BoxDecoration(
                            color: AppColors.emerald.withValues(alpha: .08),
                            border: Border.all(
                              color: AppColors.emerald.withValues(alpha: .3),
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'form.calculator.title'.tr,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.emerald,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.emerald,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      '${_selectedUnit!.commissionRate}%',
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'EGP ${_estimatedCommission.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => "${m[1]},")}',
                                style: textTheme.headlineSmall?.copyWith(
                                  color: AppColors.emerald,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 22,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'form.calculator.sub'.tr,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppColors.muted,
                                ),
                              ),
                            ],
                          ),
                        )
                      : const SizedBox.shrink(),
                ),

                Text(
                  'form.section.docs'.tr,
                  style: textTheme.titleMedium?.copyWith(color: AppColors.gold),
                ),
                const SizedBox(height: AppSpacing.sm),

                // Springy Tap Card for upload
                AnimatedTap(
                  onTap: _simulateUpload,
                  child: Container(
                    width: double.infinity,
                    height: 110,
                    decoration: BoxDecoration(
                      color: AppColors.paper.withValues(alpha: .85),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: _uploadState == 2
                            ? AppColors.emerald
                            : AppColors.border,
                        width: 1.5,
                      ),
                    ),
                    child: _buildUploadContent(textTheme),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),

                // Springy Tap Submit Button
                SizedBox(
                  width: double.infinity,
                  child: AnimatedTap(
                    onTap: _submitDeal,
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: AppColors.gold,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          'form.submit'.tr,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUploadContent(TextTheme textTheme) {
    if (_uploadState == 0) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.cloud_upload_outlined,
            size: 36,
            color: AppColors.gold,
          ),
          const SizedBox(height: 6),
          Text(
            'form.upload.click'.tr,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'form.upload.sub'.tr,
            style: const TextStyle(fontSize: 10, color: AppColors.muted),
          ),
        ],
      );
    } else if (_uploadState == 1) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const _PulsingIcon(),
            const SizedBox(height: 8),
            Text(
              '${'form.upload.loading'.tr} ${(_uploadProgress * 100).toStringAsFixed(0)}%',
              style: const TextStyle(fontSize: 11, color: AppColors.ink),
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: _uploadProgress,
                backgroundColor: AppColors.border,
                color: AppColors.gold,
                minHeight: 4,
              ),
            ),
          ],
        ),
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(
              color: AppColors.emerald,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'form.upload.success'.tr,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.emerald,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 2),
              const Text(
                'contract_booking_final.pdf',
                style: TextStyle(fontSize: 11, color: AppColors.ink),
              ),
            ],
          ),
        ],
      );
    }
  }
}

// Stateful pulsing icon to represent live upload progress activity
class _PulsingIcon extends StatefulWidget {
  const _PulsingIcon();

  @override
  State<_PulsingIcon> createState() => _PulsingIconState();
}

class _PulsingIconState extends State<_PulsingIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
      lowerBound: 0.85,
      upperBound: 1.15,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _pulseController,
      child: const Icon(
        Icons.upload_file_rounded,
        size: 28,
        color: AppColors.gold,
      ),
    );
  }
}

class _SuccessDialog extends StatelessWidget {
  const _SuccessDialog({
    required this.projectName,
    required this.unitCode,
    required this.commission,
  });

  final String projectName;
  final String unitCode;
  final double commission;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.paper,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Bouncy Scale-in for Shield Icon
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOutBack,
              builder: (context, value, child) {
                return Transform.scale(scale: value, child: child);
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.emerald.withValues(alpha: .1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.verified_user_rounded,
                  color: AppColors.emerald,
                  size: 48,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'form.success.title'.tr,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 8),
            Text(
              'form.success.desc'.tr,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.muted,
                fontSize: 12,
                height: 1.4,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'form.deal.project'.tr,
                        style: const TextStyle(
                          color: AppColors.muted,
                          fontSize: 11,
                        ),
                      ),
                      Text(
                        projectName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.ink,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'form.deal.unit'.tr,
                        style: const TextStyle(
                          color: AppColors.muted,
                          fontSize: 11,
                        ),
                      ),
                      Text(
                        unitCode,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.ink,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'contract.commission'.tr,
                        style: const TextStyle(
                          color: AppColors.muted,
                          fontSize: 11,
                        ),
                      ),
                      Text(
                        'EGP ${commission.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => "${m[1]},")}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.emerald,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              width: double.infinity,
              child: AnimatedTap(
                onTap: () {
                  Navigator.of(context).pop();
                  final navigationController = Get.find<NavigationController>();
                  navigationController.changeIndex(1);
                },
                child: Container(
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.emerald,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      'form.success.btn'.tr,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
