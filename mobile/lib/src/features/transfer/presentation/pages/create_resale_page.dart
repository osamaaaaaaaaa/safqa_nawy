import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/animated_tap.dart';

class CreateResalePage extends StatefulWidget {
  const CreateResalePage({super.key});

  @override
  State<CreateResalePage> createState() => _CreateResalePageState();
}

class _CreateResalePageState extends State<CreateResalePage> {
  int currentStep = 1;
  bool isSubmitted = false;

  // Controllers / States
  final developerController = TextEditingController();
  final projectController = TextEditingController();
  final locationController = TextEditingController();
  final areaController = TextEditingController();
  final priceController = TextEditingController();
  final cashPaidController = TextEditingController();
  final ownerNameController = TextEditingController();
  final ownerPhoneController = TextEditingController();

  String unitType = 'apartment';
  String finishing = 'core_shell';
  bool uploadContract = false;
  bool ownerConfirm = false;

  @override
  Widget build(BuildContext context) {
    final isAr = Get.locale?.languageCode == 'ar';

    if (isSubmitted) {
      return Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    color: AppColors.emerald.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check_circle_rounded, color: AppColors.emerald, size: 48),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  isAr ? 'تم تسجيل الوحدة بنجاح 🎉' : 'Unit Registered Successfully 🎉',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  isAr
                      ? 'مستندات الوحدة قيد المراجعة حالياً من قبل فريق الإغلاق بصفقة. سيتم إشعارك فور اكتمال التوثيق لبدء استقبال المشترين.'
                      : 'Unit documents are under review by Safqa closing team. You will be notified once verified to start matching buyers.',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.xl),
                AnimatedTap(
                  onTap: () => Get.back(),
                  child: Container(
                    height: 52,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.ink,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      isAr ? 'العودة للرئيسية' : 'Back to Dashboard',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
      appBar: AppBar(
        title: Text(
          isAr ? 'طلب إدراج وحدة تنازل' : 'List Resale Unit',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          // Step Progress Tracker
          _buildProgressTracker(isAr),

          // Main wizard container
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
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
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomActions(isAr),
    );
  }

  Widget _buildProgressTracker(bool isAr) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      decoration: BoxDecoration(
        color: AppColors.paper,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _StepIndicator(step: 1, label: isAr ? 'مواصفات العقار' : 'Specs', currentStep: currentStep),
          _ConnectorLine(isActive: currentStep > 1),
          _StepIndicator(step: 2, label: isAr ? 'المعطيات المالي' : 'Finance', currentStep: currentStep),
          _ConnectorLine(isActive: currentStep > 2),
          _StepIndicator(step: 3, label: isAr ? 'توثيق المالك' : 'Owner', currentStep: currentStep),
        ],
      ),
    );
  }

  Widget _buildStep1(bool isAr) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(isAr ? '01. هوية ومواصفات العقار' : '01. Property Specs', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: AppSpacing.md),
        TextField(
          controller: developerController,
          decoration: InputDecoration(
            labelText: isAr ? 'اسم المطور العقاري *' : 'Developer Name *',
            hintText: 'e.g. Emaar, Sodic, Ora',
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        TextField(
          controller: projectController,
          decoration: InputDecoration(
            labelText: isAr ? 'المشروع / الكمبوند *' : 'Project / Compound *',
            hintText: 'e.g. Mivida, Zed East, June',
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        TextField(
          controller: locationController,
          decoration: InputDecoration(
            labelText: isAr ? 'المنطقة أو المحافظة *' : 'Location / Area *',
            hintText: isAr ? 'مثال: التجمع الخامس، الساحل الشمالي' : 'e.g. New Cairo, North Coast',
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                value: unitType,
                decoration: InputDecoration(labelText: isAr ? 'نوع الوحدة' : 'Unit Type'),
                items: [
                  DropdownMenuItem(value: 'apartment', child: Text(isAr ? 'شقة' : 'Apartment')),
                  DropdownMenuItem(value: 'townhouse', child: Text(isAr ? 'تاون هاوس' : 'Townhouse')),
                  DropdownMenuItem(value: 'twinhouse', child: Text(isAr ? 'توين هاوس' : 'Twinhouse')),
                  DropdownMenuItem(value: 'villa', child: Text(isAr ? 'فيلا مستقلة' : 'Villa')),
                  DropdownMenuItem(value: 'chalet', child: Text(isAr ? 'شاليه' : 'Chalet')),
                ],
                onChanged: (val) => setState(() => unitType = val!),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: TextField(
                controller: areaController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: isAr ? 'المساحة م² *' : 'Area m² *',
                  hintText: 'e.g. 150',
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        DropdownButtonFormField<String>(
          value: finishing,
          decoration: InputDecoration(labelText: isAr ? 'حالة التشطيب' : 'Finishing'),
          items: [
            DropdownMenuItem(value: 'core_shell', child: Text(isAr ? 'بدون تشطيب (محارة وحلوق)' : 'Core & Shell')),
            DropdownMenuItem(value: 'semi_finished', child: Text(isAr ? 'نصف تشطيب' : 'Semi Finished')),
            DropdownMenuItem(value: 'fully_finished', child: Text(isAr ? 'تشطيب كامل سوبر لوكس' : 'Fully Finished')),
          ],
          onChanged: (val) => setState(() => finishing = val!),
        ),
      ],
    );
  }

  Widget _buildStep2(bool isAr) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(isAr ? '02. المعطيات والالتزامات المالية' : '02. Financial Details', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: AppSpacing.md),
        TextField(
          controller: priceController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: isAr ? 'إجمالي سعر الوحدة بالعقد *' : 'Total Contract Price *',
            hintText: 'e.g. 5,800,000',
            suffixText: 'ج.م',
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        TextField(
          controller: cashPaidController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: isAr ? 'المبلغ المدفوع كاش للمطور حتى الآن *' : 'Amount Paid in Cash *',
            hintText: 'e.g. 2,400,000',
            suffixText: 'ج.م',
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  labelText: isAr ? 'القسط القادم *' : 'Next Installment *',
                  hintText: 'e.g. 150,000',
                  suffixText: 'ج.م',
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  labelText: isAr ? 'تاريخ الاستحقاق *' : 'Due Date *',
                  hintText: 'DD/MM/YYYY',
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              isAr ? 'وديعة الصيانة مدفوعة بالكامل؟' : 'Maintenance deposit paid?',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Switch(
              value: true,
              onChanged: (val) {},
              activeThumbColor: AppColors.gold,
            ),
          ],
        )
      ],
    );
  }

  Widget _buildStep3(bool isAr) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(isAr ? '03. مستندات وتوثيق الملكية' : '03. Documents & Verification', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: AppSpacing.md),
        TextField(
          controller: ownerNameController,
          decoration: InputDecoration(
            labelText: isAr ? 'اسم مالك الوحدة بالكامل (طبقاً للعقد) *' : 'Owner Full Name (on Contract) *',
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        TextField(
          controller: ownerPhoneController,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            labelText: isAr ? 'رقم هاتف المالك للتحقق *' : 'Owner Phone Number *',
            prefixText: '+20 ',
          ),
        ),
        const SizedBox(height: AppSpacing.lg),

        // File Uploader
        Text(
          isAr ? 'أرفق نسخة من عقد الوحدة والوصولات المتاحة' : 'Upload contract and receipts scans',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        ),
        const SizedBox(height: 8),
        AnimatedTap(
          onTap: () {
            setState(() {
              uploadContract = true;
            });
          },
          child: Container(
            height: 80,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.ink.withValues(alpha: 0.03),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: uploadContract ? AppColors.emerald : AppColors.border, style: BorderStyle.solid),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  uploadContract ? Icons.check_circle_rounded : Icons.file_upload_outlined,
                  color: uploadContract ? AppColors.emerald : AppColors.muted,
                ),
                const SizedBox(width: 8),
                Text(
                  uploadContract
                      ? (isAr ? 'تم تحميل عقد_الوحدة_موقع.pdf ✅' : 'contract_signed.pdf loaded ✅')
                      : (isAr ? 'اضغط لرفع العقد والملفات (PDF / صور)' : 'Tap to upload contract (PDF / images)'),
                  style: TextStyle(
                    color: uploadContract ? AppColors.emerald : AppColors.muted,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Checkbox(
              value: ownerConfirm,
              activeColor: AppColors.gold,
              onChanged: (val) => setState(() => ownerConfirm = val!),
            ),
            Expanded(
              child: Text(
                isAr
                    ? 'أقر بأنني مفوض بالكامل من المالك للتسويق لهذه الوحدة، وأتحمل صحة كل المعطيات المرفوعة.'
                    : 'I confirm that I am legally authorized by the owner to list this unit, and all provided details are correct.',
                style: const TextStyle(fontSize: 11, color: AppColors.muted),
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildBottomActions(bool isAr) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
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
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.border),
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Text(isAr ? 'السابق' : 'Back', style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            )
          else
            const SizedBox(),
          AnimatedTap(
            onTap: () {
              if (currentStep < 3) {
                setState(() => currentStep++);
              } else {
                if (ownerConfirm && uploadContract) {
                  setState(() => isSubmitted = true);
                } else {
                  Get.snackbar(
                    isAr ? 'حقول مطلوبة' : 'Required fields',
                    isAr ? 'برجاء رفع العقد والموافقة على الإقرار أولاً' : 'Please upload contract and agree to terms first',
                    backgroundColor: AppColors.clay,
                    colorText: Colors.white,
                  );
                }
              }
            },
            child: Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 32),
              decoration: BoxDecoration(
                color: AppColors.ink,
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Text(
                currentStep == 3 ? (isAr ? 'إرسال ومراجعة 🚀' : 'Submit & Review 🚀') : (isAr ? 'التالي' : 'Next'),
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
