import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rionydo/core/constants/font_manager.dart';
import 'package:rionydo/core/utils/app_colors.dart';
import 'package:rionydo/core/utils/app_spacing.dart';
import 'package:rionydo/core/widgets/custom_back_button.dart';

/// A single chat message model.
class _ChatMessage {
  final String? text;
  final String? imagePath;
  final String time;
  final bool isSupport;

  _ChatMessage({
    this.text,
    this.imagePath,
    required this.time,
    required this.isSupport,
  });
}

class ChatSupportView extends StatefulWidget {
  const ChatSupportView({super.key});

  @override
  State<ChatSupportView> createState() => _ChatSupportViewState();
}

class _ChatSupportViewState extends State<ChatSupportView> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _picker = ImagePicker();

  final List<_ChatMessage> _messages = [
    _ChatMessage(
      text: "Hello! Welcome to SwissCarExchange support. How can I help you today?",
      time: "10:30 AM",
      isSupport: true,
    ),
  ];

  /// Predefined demo replies keyed by chip text.
  static const Map<String, String> _demoReplies = {
    "How to bid?":
        "To place a bid, go to any active auction, review the car details, then tap \"Place Bid\". Enter your amount and confirm!",
    "Payment methods":
        "We accept Visa, Mastercard, AMEX, and direct bank transfers (IBAN). You can manage your payment methods in Settings.",
    "Contact dealer":
        "After winning an auction you'll receive the dealer's phone number and email on the Auction Contact screen.",
  };

  /// Fallback replies for free-text messages.
  static const List<String> _genericReplies = [
    "Thanks for reaching out! A support agent will review your message shortly.",
    "Got it! Let me look into that for you.",
    "I appreciate your patience. We'll get back to you within a few minutes.",
    "Thank you! Is there anything else I can help you with?",
    "That's a great question. Let me check our records.",
  ];

  int _replyIndex = 0;

  String _currentTime() {
    final now = TimeOfDay.now();
    final hour = now.hourOfPeriod == 0 ? 12 : now.hourOfPeriod;
    final period = now.period == DayPeriod.am ? "AM" : "PM";
    return "${hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')} $period";
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendTextMessage(String text) {
    if (text.trim().isEmpty) return;
    setState(() {
      _messages.add(_ChatMessage(text: text, time: _currentTime(), isSupport: false));
    });
    _controller.clear();
    _scrollToBottom();
    _simulateReply(text);
  }

  void _sendImageMessage(String path) {
    setState(() {
      _messages.add(_ChatMessage(imagePath: path, time: _currentTime(), isSupport: false));
    });
    _scrollToBottom();
    _simulateReply(null);
  }

  void _simulateReply(String? userText) {
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      String reply;
      if (userText != null && _demoReplies.containsKey(userText)) {
        reply = _demoReplies[userText]!;
      } else if (userText == null) {
        reply = "Thanks for the image! I'll review it and get back to you.";
      } else {
        reply = _genericReplies[_replyIndex % _genericReplies.length];
        _replyIndex++;
      }
      setState(() {
        _messages.add(_ChatMessage(text: reply, time: _currentTime(), isSupport: true));
      });
      _scrollToBottom();
    });
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      imageQuality: 80,
    );
    if (image != null) {
      _sendImageMessage(image.path);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.sceDarkBg,
      appBar: AppBar(
        backgroundColor: AppColors.sceDarkBg,
        elevation: 0,
        leadingWidth: 60.w,
        leading: Padding(
          padding: EdgeInsets.only(left: 10.w),
          child: const CustomBackButton(),
        ),
        title: Row(
          children: [
            Container(
              height: 44.w,
              width: 44.w,
              decoration: const BoxDecoration(
                color: AppColors.sceTeal,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                "SC",
                style: FontManager.bodyMedium(
                  color: AppColors.white,
                ).copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            AppSpacing.w12,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "SwissCarExchange Support",
                    style: FontManager.bodyMedium(
                      color: AppColors.white,
                    ).copyWith(fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Container(
                        height: 8.w,
                        width: 8.w,
                        decoration: const BoxDecoration(
                          color: AppColors.sceTeal,
                          shape: BoxShape.circle,
                        ),
                      ),
                      AppSpacing.w6,
                      Text(
                        "Online",
                        style: FontManager.bodySmall(color: AppColors.sceTeal),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.h),
          child: Divider(color: Colors.white.withOpacity(0.05), height: 1),
        ),
      ),
      body: Column(
        children: [
          /// MESSAGE LIST
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.all(20.w),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                if (msg.imagePath != null) {
                  return _ImageBubble(
                    imagePath: msg.imagePath!,
                    time: msg.time,
                    isSupport: msg.isSupport,
                  );
                }
                return _ChatBubble(
                  message: msg.text!,
                  time: msg.time,
                  isSupport: msg.isSupport,
                );
              },
            ),
          ),

          /// SUGGESTION CHIPS
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            child: Row(
              children: [
                _SuggestionChip(
                  text: "How to bid?",
                  onTap: () => _sendTextMessage("How to bid?"),
                ),
                AppSpacing.w10,
                _SuggestionChip(
                  text: "Payment methods",
                  onTap: () => _sendTextMessage("Payment methods"),
                ),
                AppSpacing.w10,
                _SuggestionChip(
                  text: "Contact dealer",
                  onTap: () => _sendTextMessage("Contact dealer"),
                ),
              ],
            ),
          ),

          /// INPUT BAR
          SafeArea(
            child: Container(
              padding: EdgeInsets.only(
                left: 20.w,
                right: 20.w,
                bottom: 30.h,
                top: 10.h,
              ),
              decoration: BoxDecoration(
                color: AppColors.sceDarkBg,
                border: Border(
                  top: BorderSide(color: Colors.white.withOpacity(0.05)),
                ),
              ),
              child: Row(
                children: [
                  _ChatIconButton(
                    icon: Icons.image_outlined,
                    onTap: _pickImage,
                  ),
                  AppSpacing.w12,
                  Expanded(
                    child: Container(
                      height: 50.h,
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      decoration: BoxDecoration(
                        color: AppColors.sceCardBg,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.08),
                        ),
                      ),
                      child: TextField(
                        controller: _controller,
                        style: FontManager.bodyMedium(color: AppColors.white),
                        textInputAction: TextInputAction.send,
                        onSubmitted: _sendTextMessage,
                        decoration: InputDecoration(
                          hintText: "Type a message...",
                          hintStyle: FontManager.bodySmall(
                            color: AppColors.sceGrey99,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  AppSpacing.w12,
                  Container(
                    height: 50.h,
                    width: 50.h,
                    decoration: BoxDecoration(
                      color: AppColors.sceCardBg,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.08),
                      ),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.send_rounded,
                        color: AppColors.white,
                        size: 20.sp,
                      ),
                      onPressed: () => _sendTextMessage(_controller.text),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────── Private Widgets ───────────────────

class _ChatBubble extends StatelessWidget {
  final String message;
  final String time;
  final bool isSupport;

  const _ChatBubble({
    required this.message,
    required this.time,
    required this.isSupport,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSupport ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: isSupport
              ? AppColors.sceCardBg
              : AppColors.sceTeal.withOpacity(0.1),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.r),
            topRight: Radius.circular(16.r),
            bottomLeft: Radius.circular(isSupport ? 0 : 16.r),
            bottomRight: Radius.circular(isSupport ? 16.r : 0),
          ),
          border: Border.all(
            color: isSupport
                ? Colors.white.withOpacity(0.05)
                : AppColors.sceTeal.withOpacity(0.2),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              message,
              style: FontManager.bodyMedium(color: AppColors.white),
            ),
            AppSpacing.h4,
            Text(
              time,
              style: FontManager.bodySmall(
                color: AppColors.sceGrey99,
              ).copyWith(fontSize: 10.sp),
            ),
          ],
        ),
      ),
    );
  }
}

class _ImageBubble extends StatelessWidget {
  final String imagePath;
  final String time;
  final bool isSupport;

  const _ImageBubble({
    required this.imagePath,
    required this.time,
    required this.isSupport,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSupport ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.65,
        ),
        decoration: BoxDecoration(
          color: isSupport
              ? AppColors.sceCardBg
              : AppColors.sceTeal.withOpacity(0.1),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.r),
            topRight: Radius.circular(16.r),
            bottomLeft: Radius.circular(isSupport ? 0 : 16.r),
            bottomRight: Radius.circular(isSupport ? 16.r : 0),
          ),
          border: Border.all(
            color: isSupport
                ? Colors.white.withOpacity(0.05)
                : AppColors.sceTeal.withOpacity(0.2),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.r),
                topRight: Radius.circular(15.r),
              ),
              child: Image.file(
                File(imagePath),
                width: double.infinity,
                height: 180.h,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              child: Text(
                time,
                style: FontManager.bodySmall(
                  color: AppColors.sceGrey99,
                ).copyWith(fontSize: 10.sp),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _ChatIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45.h,
      width: 45.h,
      decoration: BoxDecoration(
        color: AppColors.sceCardBg,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: IconButton(
        icon: Icon(icon, color: AppColors.sceGrey99, size: 22.sp),
        onPressed: onTap,
      ),
    );
  }
}

class _SuggestionChip extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const _SuggestionChip({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: AppColors.sceCardBg,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: Colors.white.withOpacity(0.08)),
        ),
        child: Text(
          text,
          style: FontManager.bodySmall(
            color: AppColors.white,
          ).copyWith(fontSize: 12.sp),
        ),
      ),
    );
  }
}
