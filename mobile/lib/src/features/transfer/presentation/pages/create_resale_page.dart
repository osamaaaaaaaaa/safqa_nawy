import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/animated_tap.dart';

class CreateResalePage extends StatefulWidget {
  const CreateResalePage({super.key});

  @override
  State<CreateResalePage> createState() => _CreateResalePageState();
}

class _CreateResalePageState extends State<CreateResalePage> {
  int currentStep = 1;
  bool isSubmitted = false;
  bool isUploading = false;

  // Controllers / States
  final developerController = TextEditingController();
  final projectController = TextEditingController();
  final locationController = TextEditingController();
  final areaController = TextEditingController();
  final priceController = TextEditingController();
  final cashPaidController = TextEditingController();
  final nextInstallmentController = TextEditingController();
  final dueDateController = TextEditingController();
  final ownerNameController = TextEditingController();
  final ownerPhoneController = TextEditingController();

  String unitType = 'apartment';
  String finishing = 'core_shell';
  bool uploadContract = false;
  bool ownerConfirm = false;
  bool maintenancePaid = true;

  // Validation Error States (In-field validation instead of Snackbar)
  String? developerError;
  String? projectError;
  String? locationError;
  String? areaError;
  String? priceError;
  String? cashPaidError;
  String? ownerNameError;
  String? ownerPhoneError;
  String? contractError;
  String? confirmError;

  // Helper to format currency to Millions dynamically
  String _formatToMillions(String val, bool isAr) {
    if (val.isEmpty) return '';
    final numVal = double.tryParse(val.replaceAll(',', ''));
    if (numVal == null) return '';
    if (numVal >= 1000000) {
      final millions = numVal / 1000000;
      return isAr 
          ? '${millions.toStringAsFixed(2)} مليون جنيه' 
          : '${millions.toStringAsFixed(2)} Million EGP';
    } else if (numVal >= 1000) {
      final thousands = numVal / 1000;
      return isAr 
          ? '${thousands.toStringAsFixed(0)} ألف جنيه' 
          : '${thousands.toStringAsFixed(0)} Thousand EGP';
    }
    return isAr ? '$val جنيه' : '$val EGP';
  }

  @override
  Widget build(BuildContext context) {
    final isAr = Get.locale?.languageCode == 'ar';

    if (isSubmitted) {
      return Scaffold(
        backgroundColor: AppColors.surface,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Glowing success badge
                Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    color: AppColors.emerald.withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.emerald.withValues(alpha: 0.15),
                      width: 2,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Container(
                    height: 70,
                    width: 70,
                    decoration: const BoxDecoration(
                      color: AppColors.emerald,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.check_circle_outline_rounded, color: Colors.white, size: 40),
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  isAr ? 'تم تسجيل طلب الإدراج بنجاح' : 'Listing Submitted Successfully',
                  style: const TextStyle(
                    color: AppColors.ink,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'Cairo',
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  isAr
                      ? 'مستندات ملكية الوحدة قيد المراجعة القانونية حالياً من قبل لجنة التوثيق بصفقة. سنقوم بإشعارك فور اكتمال المطابقة لبدء عرض الوحدة على المشترين المستعدين.'
                      : 'Unit contract documents are under escrow verification by Safqa legal committee. You will be notified once matching begins.',
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontSize: 13,
                    height: 1.5,
                    fontFamily: 'Cairo',
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                
                // Listing summary card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.paper,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    children: [
                      _buildSummaryRow(isAr ? 'نوع الوحدة' : 'Unit Type', isAr ? _getUnitTypeNameAr(unitType) : unitType.capitalizeFirst!),
                      const Divider(height: 24),
                      _buildSummaryRow(isAr ? 'المشروع' : 'Compound', projectController.text),
                      const Divider(height: 24),
                      _buildSummaryRow(isAr ? 'المطور' : 'Developer', developerController.text),
                      const Divider(height: 24),
                      _buildSummaryRow(isAr ? 'إجمالي السعر' : 'Contract Price', _formatToMillions(priceController.text, isAr)),
                    ],
                  ),
                ),
                
                const Spacer(),
                AnimatedTap(
                  onTap: () => Get.back(),
                  child: Container(
                    height: 54,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.ink,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      isAr ? 'العودة للوحة الرئيسية' : 'Return to Dashboard',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13, fontFamily: 'Cairo'),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        foregroundColor: AppColors.ink,
        centerTitle: true,
        title: Text(
          isAr ? 'بيع وحدتك بالعمولة' : 'Sell Your Unit',
          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, fontFamily: 'Cairo'),
        ),
      ),
      body: Column(
        children: [
          // Step Progress Tracker
          _buildProgressTracker(isAr),

          // Main wizard container
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.paper,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (currentStep == 1) _buildStep1(isAr),
                    if (currentStep == 2) _buildStep2(isAr),
                    if (currentStep == 3) _buildStep3(isAr),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomActions(isAr),
    );
  }

  Widget _buildSummaryRow(String title, String val) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(color: AppColors.muted, fontSize: 12, fontFamily: 'Cairo')),
        Text(val, style: const TextStyle(color: AppColors.ink, fontWeight: FontWeight.bold, fontSize: 12, fontFamily: 'Cairo')),
      ],
    );
  }

  String _getUnitTypeNameAr(String type) {
    switch (type) {
      case 'apartment': return 'شقة سكينة';
      case 'townhouse': return 'تاون هاوس';
      case 'twinhouse': return 'توين هاوس';
      case 'villa': return 'فيلا مستقلة';
      case 'chalet': return 'شاليه ساحلي';
      default: return type;
    }
  }

  Widget _buildProgressTracker(bool isAr) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
      color: AppColors.surface,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _StepIndicator(step: 1, label: isAr ? 'المواصفات' : 'Specs', currentStep: currentStep),
          _ConnectorLine(isActive: currentStep > 1),
          _StepIndicator(step: 2, label: isAr ? 'المالية' : 'Finance', currentStep: currentStep),
          _ConnectorLine(isActive: currentStep > 2),
          _StepIndicator(step: 3, label: isAr ? 'التوثيق' : 'Verify', currentStep: currentStep),
        ],
      ),
    );
  }

  Widget _buildStep1(bool isAr) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isAr ? '01. مواصفات ونوع الوحدة' : '01. Unit Specifications', 
          style: const TextStyle(color: AppColors.ink, fontWeight: FontWeight.w900, fontSize: 16, fontFamily: 'Cairo'),
        ),
        const SizedBox(height: 4),
        Text(
          isAr ? 'أدخل التفاصيل العامة ومساحة العقار بدقة' : 'Provide basic building parameters and area',
          style: const TextStyle(color: AppColors.muted, fontSize: 11, fontFamily: 'Cairo'),
        ),
        
        const SizedBox(height: 20),

        // Visual Unit Type Selector
        Text(
          isAr ? 'نوع العقار *' : 'Property Type *',
          style: const TextStyle(color: AppColors.ink, fontWeight: FontWeight.bold, fontSize: 12, fontFamily: 'Cairo'),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildTypeSelectorItem('apartment', Icons.apartment_rounded, isAr ? 'شقة' : 'Apartment'),
            const SizedBox(width: 8),
            _buildTypeSelectorItem('chalet', Icons.beach_access_rounded, isAr ? 'شاليه' : 'Chalet'),
            const SizedBox(width: 8),
            _buildTypeSelectorItem('villa', Icons.villa_rounded, isAr ? 'فيلا' : 'Villa'),
            const SizedBox(width: 8),
            _buildTypeSelectorItem('townhouse', Icons.holiday_village_rounded, isAr ? 'تاون' : 'Townhouse'),
          ],
        ),

        const SizedBox(height: 20),

        // Custom Styled Form Fields with in-field errors
        _buildCustomField(
          controller: projectController,
          label: isAr ? 'المشروع / الكمبوند *' : 'Compound / Project *',
          hint: 'e.g. Mivida, Zed East, Badya',
          icon: Icons.business_rounded,
          errorText: projectError,
          onChanged: (val) {
            if (projectError != null) setState(() => projectError = null);
          },
        ),
        const SizedBox(height: 16),
        _buildCustomField(
          controller: developerController,
          label: isAr ? 'اسم المطور العقاري *' : 'Developer Name *',
          hint: 'e.g. Emaar, SODIC, Palm Hills',
          icon: Icons.corporate_fare_rounded,
          errorText: developerError,
          onChanged: (val) {
            if (developerError != null) setState(() => developerError = null);
          },
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildCustomField(
                controller: locationController,
                label: isAr ? 'المنطقة أو المحافظة *' : 'Location / Area *',
                hint: isAr ? 'مثال: التجمع الخامس' : 'e.g. Sheikh Zayed',
                icon: Icons.location_on_rounded,
                errorText: locationError,
                onChanged: (val) {
                  if (locationError != null) setState(() => locationError = null);
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildCustomField(
                controller: areaController,
                label: isAr ? 'المساحة م² *' : 'Area m² *',
                hint: 'e.g. 165',
                icon: Icons.photo_size_select_small_rounded,
                keyboardType: TextInputType.number,
                errorText: areaError,
                onChanged: (val) {
                  if (areaError != null) setState(() => areaError = null);
                },
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        // Finishing Selector
        Text(
          isAr ? 'حالة التشطيب *' : 'Finishing Condition *',
          style: const TextStyle(color: AppColors.ink, fontWeight: FontWeight.bold, fontSize: 12, fontFamily: 'Cairo'),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            _buildFinishingItem('core_shell', isAr ? 'بدون تشطيب' : 'Core & Shell'),
            const SizedBox(width: 8),
            _buildFinishingItem('semi_finished', isAr ? 'نصف تشطيب' : 'Semi Finished'),
            const SizedBox(width: 8),
            _buildFinishingItem('fully_finished', isAr ? 'تشطيب كامل' : 'Fully Finished'),
          ],
        ),
      ],
    );
  }

  Widget _buildStep2(bool isAr) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isAr ? '02. المعطيات والالتزامات المالية' : '02. Financial Obligations', 
          style: const TextStyle(color: AppColors.ink, fontWeight: FontWeight.w900, fontSize: 16, fontFamily: 'Cairo'),
        ),
        const SizedBox(height: 4),
        Text(
          isAr ? 'حدد الأسعار والمبالغ المسددة وتفاصيل التقسيط' : 'Define compound pricing and remaining installments',
          style: const TextStyle(color: AppColors.muted, fontSize: 11, fontFamily: 'Cairo'),
        ),
        
        const SizedBox(height: 20),

        _buildCustomField(
          controller: priceController,
          label: isAr ? 'إجمالي سعر الوحدة في عقد الشراء الأصلي *' : 'Total Original Contract Price *',
          hint: 'e.g. 6,500,000',
          icon: Icons.monetization_on_rounded,
          keyboardType: TextInputType.number,
          suffix: _formatToMillions(priceController.text, isAr),
          errorText: priceError,
          onChanged: (val) {
            setState(() {
              if (priceError != null) priceError = null;
            });
          },
        ),
        const SizedBox(height: 16),
        _buildCustomField(
          controller: cashPaidController,
          label: isAr ? 'المبلغ الكاش المدفوع للمطور حتى الآن *' : 'Cash Amount Paid to Developer *',
          hint: 'e.g. 2,800,000',
          icon: Icons.payments_rounded,
          keyboardType: TextInputType.number,
          suffix: _formatToMillions(cashPaidController.text, isAr),
          errorText: cashPaidError,
          onChanged: (val) {
            setState(() {
              if (cashPaidError != null) cashPaidError = null;
            });
          },
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildCustomField(
                controller: nextInstallmentController,
                label: isAr ? 'قيمة القسط القادم' : 'Next Installment',
                hint: 'e.g. 200,000',
                icon: Icons.schedule_send_rounded,
                keyboardType: TextInputType.number,
                suffix: _formatToMillions(nextInstallmentController.text, isAr),
                onChanged: (val) => setState(() {}),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildCustomField(
                controller: dueDateController,
                label: isAr ? 'تاريخ الاستحقاق' : 'Due Date',
                hint: 'DD/MM/YYYY',
                icon: Icons.calendar_month_rounded,
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 20),

        // Custom Toggle for Maintenance
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.surface,
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
                    isAr ? 'وديعة الصيانة مدفوعة بالكامل؟' : 'Maintenance Deposit Paid?',
                    style: const TextStyle(color: AppColors.ink, fontWeight: FontWeight.bold, fontSize: 12, fontFamily: 'Cairo'),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    isAr ? 'شاملة الودائع والوصلات المدفوعة' : 'Including all due deposits',
                    style: const TextStyle(color: AppColors.muted, fontSize: 10, fontFamily: 'Cairo'),
                  ),
                ],
              ),
              Switch(
                value: maintenancePaid,
                onChanged: (val) => setState(() => maintenancePaid = val),
                activeThumbColor: AppColors.gold,
                activeTrackColor: AppColors.gold.withValues(alpha: 0.3),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStep3(bool isAr) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isAr ? '03. إثبات الهوية والمستندات' : '03. Ownership Verification', 
          style: const TextStyle(color: AppColors.ink, fontWeight: FontWeight.w900, fontSize: 16, fontFamily: 'Cairo'),
        ),
        const SizedBox(height: 4),
        Text(
          isAr ? 'أرفق نسخة من العقد لتسريع عملية التوثيق القانوني بصفقة' : 'Upload document scans to verify legal escrow',
          style: const TextStyle(color: AppColors.muted, fontSize: 11, fontFamily: 'Cairo'),
        ),
        
        const SizedBox(height: 20),

        _buildCustomField(
          controller: ownerNameController,
          label: isAr ? 'اسم مالك الوحدة بالكامل (طبقاً للعقد) *' : 'Owner Full Name (on Contract) *',
          hint: isAr ? 'مثال: أسامة أحمد محمود' : 'e.g. Osama Ahmed Mahmoud',
          icon: Icons.badge_rounded,
          errorText: ownerNameError,
          onChanged: (val) {
            if (ownerNameError != null) setState(() => ownerNameError = null);
          },
        ),
        const SizedBox(height: 16),
        _buildCustomField(
          controller: ownerPhoneController,
          label: isAr ? 'رقم هاتف المالك للتوثيق العقاري *' : 'Owner Contact Phone *',
          hint: '01xxxxxxxxx',
          icon: Icons.phone_android_rounded,
          keyboardType: TextInputType.phone,
          errorText: ownerPhoneError,
          onChanged: (val) {
            if (ownerPhoneError != null) setState(() => ownerPhoneError = null);
          },
        ),

        const SizedBox(height: 24),

        Text(
          isAr ? 'تحميل العقد والمستندات العقارية *' : 'Upload Contract & Ownership Receipts *',
          style: const TextStyle(color: AppColors.ink, fontWeight: FontWeight.bold, fontSize: 12, fontFamily: 'Cairo'),
        ),
        const SizedBox(height: 10),

        // Beautiful Interactive Upload Area
        AnimatedTap(
          onTap: () async {
            if (uploadContract) return;
            setState(() => isUploading = true);
            await Future.delayed(const Duration(seconds: 1));
            setState(() {
              isUploading = false;
              uploadContract = true;
              if (contractError != null) contractError = null;
            });
          },
          child: Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              color: uploadContract 
                  ? AppColors.emerald.withValues(alpha: 0.03) 
                  : AppColors.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: contractError != null 
                    ? AppColors.clay 
                    : (uploadContract ? AppColors.emerald : AppColors.border),
                width: 1.5,
                style: BorderStyle.solid,
              ),
            ),
            child: isUploading
                ? const Center(
                    child: SizedBox(
                      height: 28,
                      width: 28,
                      child: CircularProgressIndicator(color: AppColors.gold, strokeWidth: 2),
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        uploadContract ? Icons.check_circle_outline_rounded : Icons.cloud_upload_outlined,
                        color: contractError != null 
                            ? AppColors.clay 
                            : (uploadContract ? AppColors.emerald : AppColors.muted),
                        size: 32,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        uploadContract 
                            ? (isAr ? 'عقد_الوحدة_موقع.pdf (تم الرفع)' : 'contract_signed.pdf (Uploaded)')
                            : (isAr ? 'انقر هنا لرفع العقد العقاري' : 'Click here to upload property contract'),
                        style: TextStyle(
                          color: contractError != null 
                              ? AppColors.clay 
                              : (uploadContract ? AppColors.emerald : AppColors.ink),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          fontFamily: 'Cairo',
                        ),
                      ),
                      if (!uploadContract)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            isAr ? 'يدعم PDF أو الصور حتى 10 ميجا' : 'Supports PDF, JPEG up to 10MB',
                            style: TextStyle(
                              color: contractError != null ? AppColors.clay.withValues(alpha: 0.8) : AppColors.muted, 
                              fontSize: 9, 
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ),
                    ],
                  ),
          ),
        ),
        if (contractError != null)
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 8, right: 8),
            child: Text(
              contractError!,
              style: const TextStyle(color: AppColors.clay, fontSize: 11, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
            ),
          ),

        const SizedBox(height: 20),

        // Owner Confirmation Checkbox
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Checkbox(
              value: ownerConfirm,
              activeColor: AppColors.emerald,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              side: BorderSide(
                color: confirmError != null ? AppColors.clay : AppColors.border,
                width: 1.5,
              ),
              onChanged: (val) => setState(() {
                ownerConfirm = val!;
                if (ownerConfirm && confirmError != null) {
                  confirmError = null;
                }
              }),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(
                  isAr
                      ? 'أقر بأنني مفوض قانوناً بالكامل من مالك العقار للتسويق لهذه الوحدة، وأتحمل المسؤولية الكاملة عن صحة كافة البيانات المذكورة.'
                      : 'I acknowledge that I am fully authorized by the owner to list this property, and assume full legal liability for the data accuracy.',
                  style: TextStyle(
                    fontSize: 11, 
                    color: confirmError != null ? AppColors.clay : AppColors.muted, 
                    height: 1.4, 
                    fontFamily: 'Cairo',
                  ),
                ),
              ),
            ),
          ],
        ),
        if (confirmError != null)
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 8, right: 8),
            child: Text(
              confirmError!,
              style: const TextStyle(color: AppColors.clay, fontSize: 11, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
            ),
          ),
      ],
    );
  }

  Widget _buildCustomField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String suffix = '',
    String? errorText,
    ValueChanged<String>? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: AppColors.ink, fontWeight: FontWeight.bold, fontSize: 11.5, fontFamily: 'Cairo'),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: AppColors.muted, fontSize: 12),
            prefixIcon: Icon(icon, color: AppColors.gold, size: 18),
            fillColor: AppColors.surface,
            filled: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            errorText: errorText,
            errorStyle: const TextStyle(color: AppColors.clay, fontWeight: FontWeight.bold, fontSize: 11, fontFamily: 'Cairo'),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: AppColors.border, width: 1.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: AppColors.border, width: 1.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.gold, width: 1.2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.clay, width: 1.0),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.clay, width: 1.2),
            ),
            helperText: (suffix.isNotEmpty && errorText == null) ? suffix : null,
            helperStyle: const TextStyle(color: AppColors.emerald, fontWeight: FontWeight.bold, fontSize: 10, fontFamily: 'Cairo'),
          ),
        ),
      ],
    );
  }

  Widget _buildTypeSelectorItem(String type, IconData icon, String label) {
    final isSelected = unitType == type;
    return Expanded(
      child: AnimatedTap(
        onTap: () => setState(() => unitType = type),
        scaleDownTo: 0.94,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.gold.withValues(alpha: 0.08) : AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? AppColors.gold : AppColors.border,
              width: 1.5,
            ),
          ),
          child: Column(
            children: [
              Icon(icon, color: isSelected ? AppColors.gold : AppColors.muted, size: 22),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? AppColors.gold : AppColors.ink,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                  fontSize: 10,
                  fontFamily: 'Cairo',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFinishingItem(String type, String label) {
    final isSelected = finishing == type;
    return Expanded(
      child: AnimatedTap(
        onTap: () => setState(() => finishing = type),
        scaleDownTo: 0.94,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.gold.withValues(alpha: 0.08) : AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected ? AppColors.gold : AppColors.border,
              width: 1.2,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? AppColors.gold : AppColors.ink,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
              fontSize: 10.5,
              fontFamily: 'Cairo',
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomActions(bool isAr) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.paper,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (currentStep > 1)
            AnimatedTap(
              onTap: () => setState(() => currentStep--),
              child: Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.border),
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.center,
                child: Text(
                  isAr ? 'السابق' : 'Back', 
                  style: const TextStyle(color: AppColors.ink, fontWeight: FontWeight.bold, fontSize: 13, fontFamily: 'Cairo'),
                ),
              ),
            )
          else
            const SizedBox(),
          AnimatedTap(
            onTap: () {
              if (currentStep == 1) {
                // Validate Step 1
                bool hasError = false;
                if (projectController.text.isEmpty) {
                  projectError = isAr ? 'اسم المشروع مطلوب *' : 'Compound/Project is required *';
                  hasError = true;
                }
                if (developerController.text.isEmpty) {
                  developerError = isAr ? 'اسم المطور مطلوب *' : 'Developer Name is required *';
                  hasError = true;
                }
                if (locationController.text.isEmpty) {
                  locationError = isAr ? 'المنطقة مطلوبة *' : 'Location/Area is required *';
                  hasError = true;
                }
                if (areaController.text.isEmpty) {
                  areaError = isAr ? 'المساحة مطلوبة *' : 'Area is required *';
                  hasError = true;
                }
                if (hasError) {
                  setState(() {});
                  return;
                }
                setState(() => currentStep = 2);
              } else if (currentStep == 2) {
                // Validate Step 2
                bool hasError = false;
                if (priceController.text.isEmpty) {
                  priceError = isAr ? 'إجمالي السعر مطلوب *' : 'Total Price is required *';
                  hasError = true;
                }
                if (cashPaidController.text.isEmpty) {
                  cashPaidError = isAr ? 'المبلغ الكاش المدفوع مطلوب *' : 'Cash Paid is required *';
                  hasError = true;
                }
                if (hasError) {
                  setState(() {});
                  return;
                }
                setState(() => currentStep = 3);
              } else if (currentStep == 3) {
                // Validate Step 3
                bool hasError = false;
                if (ownerNameController.text.isEmpty) {
                  ownerNameError = isAr ? 'اسم المالك مطلوب *' : 'Owner name is required *';
                  hasError = true;
                }
                if (ownerPhoneController.text.isEmpty) {
                  ownerPhoneError = isAr ? 'رقم هاتف المالك مطلوب *' : 'Owner phone is required *';
                  hasError = true;
                }
                if (!uploadContract) {
                  contractError = isAr ? 'يرجى رفع صورة أو ملف العقد أولاً للتوثيق *' : 'Please upload contract first *';
                  hasError = true;
                }
                if (!ownerConfirm) {
                  confirmError = isAr ? 'يجب الموافقة على إقرار التفويض العقاري للمتابعة *' : 'You must accept the authorization declaration to continue *';
                  hasError = true;
                }
                if (hasError) {
                  setState(() {});
                  return;
                }
                setState(() => isSubmitted = true);
              }
            },
            child: Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 36),
              decoration: BoxDecoration(
                color: AppColors.ink,
                borderRadius: BorderRadius.circular(16),
              ),
              alignment: Alignment.center,
              child: Text(
                currentStep == 3 ? (isAr ? 'إرسال للمراجعة' : 'Submit for Escrow') : (isAr ? 'التالي' : 'Next'),
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13, fontFamily: 'Cairo'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StepIndicator extends StatelessWidget {
  const _StepIndicator({required this.step, required this.label, required this.currentStep});

  final int step;
  final String label;
  final int currentStep;

  @override
  Widget build(BuildContext context) {
    final isActive = step <= currentStep;
    final isCurrent = step == currentStep;

    return Row(
      children: [
        Container(
          height: 28,
          width: 28,
          decoration: BoxDecoration(
            color: isCurrent
                ? AppColors.gold
                : isActive
                    ? AppColors.gold.withValues(alpha: 0.1)
                    : Colors.transparent,
            border: Border.all(color: isActive ? AppColors.gold : AppColors.border, width: 1.5),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            '0$step',
            style: TextStyle(
              color: isCurrent
                  ? Colors.white
                  : isActive
                      ? AppColors.gold
                      : AppColors.muted,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            color: isActive ? AppColors.ink : AppColors.muted,
            fontSize: 11,
            fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
            fontFamily: 'Cairo',
          ),
        )
      ],
    );
  }
}

class _ConnectorLine extends StatelessWidget {
  const _ConnectorLine({required this.isActive});

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 1.5,
        color: isActive ? AppColors.gold : AppColors.border,
      ),
    );
  }
}
