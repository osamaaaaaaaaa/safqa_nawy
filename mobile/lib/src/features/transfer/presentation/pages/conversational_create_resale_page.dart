import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/animated_tap.dart';

class ConversationalCreateResalePage extends StatefulWidget {
  const ConversationalCreateResalePage({super.key});

  @override
  State<ConversationalCreateResalePage> createState() => _ConversationalCreateResalePageState();
}

class _ConversationalCreateResalePageState extends State<ConversationalCreateResalePage> {
  final List<Map<String, dynamic>> messages = [];
  final TextEditingController textController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  
  int currentQuestionIndex = 0;
  final Map<String, dynamic> collectedData = {};

  final List<Map<String, dynamic>> questions = [
    {
      'id': 'project',
      'bot': 'مرحباً بك في مساعد الإدراج الحواري لصفقة. ما هو اسم الكمبوند أو المشروع العقاري؟',
      'bot_en': 'Welcome to Safqa conversational listing assistant. What is the name of the compound or project?',
      'type': 'text',
      'hint': 'مثال: زد إيست، ميفيدا...',
      'hint_en': 'e.g. Zed East, Mivida...',
    },
    {
      'id': 'developer',
      'bot': 'من هو المطور العقاري للمشروع؟',
      'bot_en': 'Who is the developer of the project?',
      'type': 'text',
      'hint': 'مثال: أورا، إعمار...',
      'hint_en': 'e.g. Ora, Emaar...',
    },
    {
      'id': 'type',
      'bot': 'ما هو نوع الوحدة العقارية؟',
      'bot_en': 'What is the property type?',
      'type': 'options',
      'options': ['شقة', 'تاون هاوس', 'توين هاوس', 'فيلات مستقلة', 'شاليه'],
      'options_en': ['Apartment', 'Townhouse', 'Twinhouse', 'Villa', 'Chalet'],
    },
    {
      'id': 'area',
      'bot': 'كم مساحة الوحدة بالمتر المربع؟',
      'bot_en': 'What is the property area in square meters?',
      'type': 'number',
      'hint': 'مثال: 150',
      'hint_en': 'e.g. 150',
    },
    {
      'id': 'cash',
      'bot': 'كم يبلغ الكاش المطلوب حالياً بالملايين؟',
      'bot_en': 'How much is the required cash in millions?',
      'type': 'number',
      'hint': 'مثال: 2.4',
      'hint_en': 'e.g. 2.4',
    },
    {
      'id': 'contract',
      'bot': 'كم يبلغ سعر العقد الأصلي بالملايين؟',
      'bot_en': 'What is the original contract price in millions?',
      'type': 'number',
      'hint': 'مثال: 4.5',
      'hint_en': 'e.g. 4.5',
    },
    {
      'id': 'contract_upload',
      'bot': 'لإنهاء التوثيق القانوني وحفظ حقوقك، يرجى رفع صورة أو ملف عقد الملكية.',
      'bot_en': 'To verify title and close legal escrow, please upload your contract document.',
      'type': 'file',
    },
    {
      'id': 'final',
      'bot': 'شكرًا لك! تم التحقق من البيانات وجاري تجهيز طلب التنازل وعرضه على المشترين المستعدين.',
      'bot_en': 'Thank you! The details are verified and the title transfer request is ready for buyer matching.',
      'type': 'done',
    }
  ];

  @override
  void initState() {
    super.initState();
    // Add first bot question
    _addBotMessage();
  }

  void _addBotMessage() {
    final isAr = Get.locale?.languageCode == 'ar';
    final currentQ = questions[currentQuestionIndex];
    messages.add({
      'isBot': true,
      'text': isAr ? currentQ['bot'] : currentQ['bot_en'],
      'type': currentQ['type'],
      'options': isAr ? currentQ['options'] : currentQ['options_en'],
    });
    setState(() {});
    _scrollToBottom();
  }

  void _handleUserResponse(String responseText) {
    if (responseText.trim().isEmpty) return;

    messages.add({
      'isBot': false,
      'text': responseText,
    });
    
    final currentQ = questions[currentQuestionIndex];
    collectedData[currentQ['id']] = responseText;

    setState(() {});
    _scrollToBottom();

    // Advance to next question
    if (currentQuestionIndex < questions.length - 1) {
      currentQuestionIndex++;
      Future.delayed(const Duration(milliseconds: 600), () {
        _addBotMessage();
      });
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isAr = Get.locale?.languageCode == 'ar';
    final currentQ = questions[currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(isAr ? 'مساعد الإدراج الذكي' : 'Conversational Listing'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.ink,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final msg = messages[index];
                  final isBot = msg['isBot'] as bool;
                  return _ChatBubble(isBot: isBot, text: msg['text'] as String);
                },
              ),
            ),
            
            // Interactive Input Bar
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.paper,
                border: Border(top: BorderSide(color: AppColors.border)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Options selector if type is options
                  if (currentQ['type'] == 'options')
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Wrap(
                        spacing: 8,
                        children: (currentQ[isAr ? 'options' : 'options_en'] as List<String>).map((opt) {
                          return ActionChip(
                            label: Text(opt),
                            backgroundColor: AppColors.gold.withValues(alpha: 0.1),
                            labelStyle: const TextStyle(color: AppColors.gold, fontWeight: FontWeight.bold, fontSize: 11),
                            onPressed: () => _handleUserResponse(opt),
                          );
                        }).toList(),
                      ),
                    ),

                  // File upload button if type is file
                  if (currentQ['type'] == 'file')
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: AnimatedTap(
                        onTap: () => _handleUserResponse(isAr ? 'تم رفع العقد بنجاح.pdf' : 'contract_signed.pdf'),
                        child: Container(
                          height: 52,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.gold, style: BorderStyle.solid),
                            color: AppColors.gold.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.cloud_upload_rounded, color: AppColors.gold),
                              const SizedBox(width: 8),
                              Text(
                                isAr ? 'اضغط هنا لرفع العقد' : 'Tap to Upload Contract',
                                style: const TextStyle(color: AppColors.gold, fontWeight: FontWeight.bold, fontSize: 12),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),

                  // Standard Text Field Input
                  if (currentQ['type'] == 'text' || currentQ['type'] == 'number')
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: textController,
                            keyboardType: currentQ['type'] == 'number' ? TextInputType.number : TextInputType.text,
                            decoration: InputDecoration(
                              hintText: isAr ? currentQ['hint'] : currentQ['hint_en'],
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            ),
                            onSubmitted: (val) {
                              _handleUserResponse(val);
                              textController.clear();
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton.filled(
                          style: IconButton.styleFrom(backgroundColor: AppColors.gold),
                          icon: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                          onPressed: () {
                            _handleUserResponse(textController.text);
                            textController.clear();
                          },
                        ),
                      ],
                    ),

                  // Success Close button when done
                  if (currentQ['type'] == 'done')
                    AnimatedTap(
                      onTap: () => Get.back(),
                      child: Container(
                        height: 48,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.emerald,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          isAr ? 'العودة للرئيسية' : 'Return to Home',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ),
                    ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  const _ChatBubble({required this.isBot, required this.text});

  final bool isBot;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isBot ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: isBot ? AppColors.paper : AppColors.gold,
          border: isBot ? Border.all(color: AppColors.border) : null,
          borderRadius: BorderRadius.only(
            topRight: const Radius.circular(16),
            topLeft: const Radius.circular(16),
            bottomLeft: isBot ? const Radius.circular(16) : Radius.zero,
            bottomRight: isBot ? Radius.zero : const Radius.circular(16),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isBot ? AppColors.ink : Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            height: 1.4,
          ),
        ),
      ),
    );
  }
}
