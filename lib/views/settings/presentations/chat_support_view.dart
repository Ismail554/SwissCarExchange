import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:rionydo/app_helper/s3_upload_helper.dart';
import 'package:rionydo/app_utils/constants/api_service.dart';
import 'package:rionydo/app_utils/constants/font_manager.dart';
import 'package:rionydo/app_utils/network/dio_manager.dart';
import 'package:rionydo/app_utils/network/enums.dart';
import 'package:rionydo/app_utils/utils/app_colors.dart';
import 'package:rionydo/app_utils/utils/app_spacing.dart';
import 'package:rionydo/core/widgets/custom_back_button.dart';
import 'package:rionydo/models/chat/chat_message_model.dart';

class ChatSupportView extends StatefulWidget {
  const ChatSupportView({super.key});

  @override
  State<ChatSupportView> createState() => _ChatSupportViewState();
}

class _ChatSupportViewState extends State<ChatSupportView> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _picker = ImagePicker();

  final List<ChatMessage> _messages = [];
  Timer? _pollTimer;
  bool _initialLoading = true;
  bool _isSending = false;
  bool _isUploading = false;
  bool _showTypingIndicator = false;
  int? _conversationId;

  // ─── Lifecycle ──────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // ─── API Calls ─────────────────────────────────────────────────────────────

  /// Fetch chat history – on first load shows spinner, later merges silently.
  Future<void> _loadHistory() async {
    try {
      final response = await DioManager.apiRequest(
        url: ApiService.chatHistory,
        method: Methods.get,
      );

      response.fold(
        (error) {
          debugPrint('Chat history error: $error');
          if (mounted && _initialLoading) {
            setState(() => _initialLoading = false);
          }
        },
        (data) {
          if (!mounted) return;
          final chatHistory = ChatHistoryResponse.fromJson(data as Map<String, dynamic>);
          final fetched = chatHistory.results;

          // Sort by createdAt ascending
          fetched.sort((a, b) => a.createdAt.compareTo(b.createdAt));

          // Merge: only add messages whose ID we don't already have.
          final existingIds = _messages.map((m) => m.id).toSet();
          final newMessages =
              fetched.where((m) => !existingIds.contains(m.id)).toList();

          if (newMessages.isNotEmpty || _initialLoading) {
            setState(() {
              _messages.addAll(newMessages);
              _initialLoading = false;
              if (_conversationId == null) {
                for (final m in _messages) {
                  if (m.conversationId != null) {
                    _conversationId = m.conversationId;
                    break;
                  }
                }
              }
            });
            if (newMessages.isNotEmpty) _scrollToBottom();
          }
        },
      );
    } catch (e) {
      debugPrint('Chat history exception: $e');
      if (mounted && _initialLoading) {
        setState(() => _initialLoading = false);
      }
    }

    // Start 30-second polling after initial load
    _startPolling();
  }

  /// Re-fetch every 30 seconds without blocking UI.
  void _startPolling() {
    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      _pollHistory();
    });
  }

  /// Silent background poll – no loading indicator, no full rebuild.
  Future<void> _pollHistory() async {
    try {
      final response = await DioManager.apiRequest(
        url: ApiService.chatHistory,
        method: Methods.get,
      );

      response.fold(
        (error) => debugPrint('Poll error: $error'),
        (data) {
          if (!mounted) return;
          final chatHistory = ChatHistoryResponse.fromJson(data as Map<String, dynamic>);
          final fetched = chatHistory.results;
          fetched.sort((a, b) => a.createdAt.compareTo(b.createdAt));

          final existingIds = _messages.map((m) => m.id).toSet();
          final newMessages =
              fetched.where((m) => !existingIds.contains(m.id)).toList();

          if (newMessages.isNotEmpty) {
            // If any new support message arrived, hide the typing indicator.
            final hasNewSupportMsg = newMessages.any((m) => m.isSupport);
            setState(() {
              _messages.addAll(newMessages);
              if (hasNewSupportMsg) _showTypingIndicator = false;
            });
            _scrollToBottom();
          }
        },
      );
    } catch (e) {
      debugPrint('Poll exception: $e');
    }
  }

  /// Start a new conversation (first message).
  Future<void> _startConversation(String text,
      {List<ChatAttachment>? attachments}) async {
    final body = <String, dynamic>{'body': text};
    if (attachments != null && attachments.isNotEmpty) {
      body['attachments'] = attachments.map((a) => a.toJson()).toList();
    }

    final response = await DioManager.apiRequest(
      url: ApiService.startChat,
      method: Methods.post,
      body: body,
      altCodes: [201],
    );

    response.fold(
      (error) {
        debugPrint('Start chat error: $error');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to start chat: $error'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      (data) {
        if (!mounted) return;
        _conversationId = data['conversation_id'] as int?;
        final msgData = data['message'] as Map<String, dynamic>?;
        if (msgData != null) {
          final msg = ChatMessage.fromJson(msgData);
          final exists = _messages.any((m) => m.id == msg.id);
          if (!exists) {
            setState(() => _messages.add(msg));
            _scrollToBottom();
          }
        }
      },
    );
  }

  /// Send a message in an existing conversation.
  Future<void> _sendApiMessage(String text,
      {List<ChatAttachment>? attachments}) async {
    final body = <String, dynamic>{'body': text};
    if (attachments != null && attachments.isNotEmpty) {
      body['attachments'] = attachments.map((a) => a.toJson()).toList();
    }

    final response = await DioManager.apiRequest(
      url: ApiService.sendMessage,
      method: Methods.post,
      body: body,
      altCodes: [201],
    );

    response.fold(
      (error) {
        debugPrint('Send message error: $error');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to send: $error'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      (data) {
        if (!mounted) return;
        // The API may return the message directly or inside a 'message' key.
        final msgData =
            data is Map<String, dynamic> && data.containsKey('message')
                ? data['message'] as Map<String, dynamic>
                : data as Map<String, dynamic>;
        final msg = ChatMessage.fromJson(msgData);
        final exists = _messages.any((m) => m.id == msg.id);
        if (!exists) {
          setState(() => _messages.add(msg));
          _scrollToBottom();
        }
      },
    );
  }

  // ─── Message Sending Flow ──────────────────────────────────────────────────

  Future<void> _sendTextMessage(String text) async {
    if (text.trim().isEmpty || _isSending) return;
    setState(() => _isSending = true);
    _controller.clear();

    // Optimistic local placeholder
    final placeholder = ChatMessage(
      id: -DateTime.now().millisecondsSinceEpoch,
      body: text,
      messageType: 'text',
      createdAt: DateTime.now(),
      attachments: [],
    );
    setState(() => _messages.add(placeholder));
    _scrollToBottom();

    try {
      if (_conversationId == null && _messages.where((m) => !m.isSupport && m.id > 0).isEmpty) {
        await _startConversation(text);
      } else {
        await _sendApiMessage(text);
      }
      // Remove placeholder after the real message arrives
      setState(() {
        _messages.removeWhere((m) => m.id == placeholder.id);
        _showTypingIndicator = true;
      });
      _scrollToBottom();
      // Quick poll after 2s to catch fast admin replies
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted && _showTypingIndicator) _pollHistory();
      });
    } catch (e) {
      debugPrint('Send failed: $e');
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  Future<void> _pickAndSendImage() async {
    if (_isUploading) return;
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      imageQuality: 80,
    );
    if (image == null) return;

    setState(() => _isUploading = true);

    try {
      final file = File(image.path);
      final fileName = image.name;
      final contentType = mimeTypeFor(image.path);

      // 1. Get presigned URL from chat-specific endpoint
      final urls = await S3UploadHelper.getPresignedUrl(
        contentType: contentType,
        fileName: fileName,
        presignedEndpoint: ApiService.attachmentPreUrl,
      );

      if (urls == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to upload attachment'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      // 2. Upload to S3
      final uploaded = await S3UploadHelper.uploadToS3(
        presignedUrl: urls['presigned_url']!,
        file: file,
        contentType: contentType,
      );

      if (!uploaded) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Upload failed, please try again'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      // 3. Build attachment payload
      final attachment = ChatAttachment(
        objectKey: urls['object_key'] ?? '',
        publicUrl: urls['public_url']!,
        contentType: contentType,
        fileName: fileName,
        sizeBytes: await file.length(),
      );

      // 4. Send message with attachment
      if (_conversationId == null && _messages.where((m) => !m.isSupport && m.id > 0).isEmpty) {
        await _startConversation('', attachments: [attachment]);
      } else {
        await _sendApiMessage('', attachments: [attachment]);
      }
      if (mounted) {
        setState(() => _showTypingIndicator = true);
        _scrollToBottom();
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted && _showTypingIndicator) _pollHistory();
        });
      }
    } catch (e) {
      debugPrint('Image send error: $e');
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  // ─── Helpers ───────────────────────────────────────────────────────────────

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

  String _formatTime(DateTime dt) {
    final hour = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    return '${hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')} $period';
  }

  // ─── Build ─────────────────────────────────────────────────────────────────

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
          child: Divider(
            color: Colors.white.withValues(alpha: 0.05),
            height: 1,
          ),
        ),
      ),
      body: Column(
        children: [
          /// MESSAGE LIST
          Expanded(
            child: _initialLoading
                ? const _ChatShimmer()
                : _messages.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.chat_bubble_outline_rounded,
                              size: 48.sp,
                              color: AppColors.sceGrey99,
                            ),
                            AppSpacing.h16,
                            Text(
                              'Start a conversation',
                              style: FontManager.bodyMedium(
                                color: AppColors.sceGrey99,
                              ),
                            ),
                            AppSpacing.h8,
                            Text(
                              'Send a message to get help from our team',
                              style: FontManager.bodySmall(
                                color: AppColors.sceGrey99,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        controller: _scrollController,
                        padding: EdgeInsets.all(20.w),
                        itemCount: _messages.length + (_showTypingIndicator ? 1 : 0),
                        itemBuilder: (context, index) {
                          // Typing indicator as last item
                          if (index == _messages.length && _showTypingIndicator) {
                            return const _TypingIndicator();
                          }
                          final msg = _messages[index];
                          // Render attachments (images)
                          if (msg.attachments.isNotEmpty &&
                              msg.body.isEmpty) {
                            return _ImageBubble(
                              attachment: msg.attachments.first,
                              time: _formatTime(msg.createdAt),
                              isSupport: msg.isSupport,
                            );
                          }
                          return _ChatBubble(
                            message: msg.body,
                            time: _formatTime(msg.createdAt),
                            isSupport: msg.isSupport,
                            attachments: msg.attachments,
                          );
                        },
                      ),
          ),

          /// SUGGESTION CHIPS (only show when no messages yet)
          if (_messages.isEmpty && !_initialLoading)
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
                  top: BorderSide(
                    color: Colors.white.withValues(alpha: 0.05),
                  ),
                ),
              ),
              child: Row(
                children: [
                  _ChatIconButton(
                    icon: _isUploading
                        ? Icons.hourglass_top_rounded
                        : Icons.image_outlined,
                    onTap: _isUploading ? () {} : _pickAndSendImage,
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
                          color: Colors.white.withValues(alpha: 0.08),
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
                      color: _isSending
                          ? AppColors.sceCardBg
                          : AppColors.sceTeal,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: _isSending
                        ? Center(
                            child: SizedBox(
                              width: 20.sp,
                              height: 20.sp,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.white,
                              ),
                            ),
                          )
                        : IconButton(
                            icon: Icon(
                              Icons.send_rounded,
                              color: AppColors.white,
                              size: 20.sp,
                            ),
                            onPressed: () =>
                                _sendTextMessage(_controller.text),
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
  final List<ChatAttachment> attachments;

  const _ChatBubble({
    required this.message,
    required this.time,
    required this.isSupport,
    this.attachments = const [],
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
              : AppColors.sceTeal.withValues(alpha: 0.1),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.r),
            topRight: Radius.circular(16.r),
            bottomLeft: Radius.circular(isSupport ? 0 : 16.r),
            bottomRight: Radius.circular(isSupport ? 16.r : 0),
          ),
          border: Border.all(
            color: isSupport
                ? Colors.white.withValues(alpha: 0.05)
                : AppColors.sceTeal.withValues(alpha: 0.2),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Inline attachment thumbnails
            if (attachments.isNotEmpty)
              ...attachments.map(
                (a) => Padding(
                  padding: EdgeInsets.only(bottom: 8.h),
                  child: InkWell(
                    onTap: () => _showAttachmentDialog(context, a),
                    child: _isImageType(a.contentType)
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8.r),
                            child: Image.network(
                              a.publicUrl,
                              width: double.infinity,
                              height: 140.h,
                              fit: BoxFit.cover,
                              errorBuilder: (_, e, st) => _filePlaceholder(a),
                            ),
                          )
                        : _filePlaceholder(a),
                  ),
                ),
              ),
            if (message.isNotEmpty)
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

  bool _isImageType(String ct) =>
      ct.startsWith('image/');

  Widget _filePlaceholder(ChatAttachment a) {
    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.attach_file, color: AppColors.sceGrey99, size: 18.sp),
          AppSpacing.w8,
          Flexible(
            child: Text(
              a.fileName,
              style: FontManager.bodySmall(color: AppColors.white),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _ImageBubble extends StatelessWidget {
  final ChatAttachment attachment;
  final String time;
  final bool isSupport;

  const _ImageBubble({
    required this.attachment,
    required this.time,
    required this.isSupport,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSupport ? Alignment.centerLeft : Alignment.centerRight,
      child: InkWell(
        onTap: () => _showAttachmentDialog(context, attachment),
        child: Container(
          margin: EdgeInsets.only(bottom: 16.h),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.65,
          ),
          decoration: BoxDecoration(
            color: isSupport
                ? AppColors.sceCardBg
                : AppColors.sceTeal.withValues(alpha: 0.1),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.r),
              topRight: Radius.circular(16.r),
              bottomLeft: Radius.circular(isSupport ? 0 : 16.r),
              bottomRight: Radius.circular(isSupport ? 16.r : 0),
            ),
            border: Border.all(
              color: isSupport
                  ? Colors.white.withValues(alpha: 0.05)
                  : AppColors.sceTeal.withValues(alpha: 0.2),
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
                child: Image.network(
                  attachment.publicUrl,
                  width: double.infinity,
                  height: 180.h,
                  fit: BoxFit.cover,
                  loadingBuilder: (_, child, progress) {
                    if (progress == null) return child;
                    return SizedBox(
                      height: 180.h,
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.sceTeal,
                          strokeWidth: 2,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (_, e, st) => SizedBox(
                    height: 180.h,
                    child: Center(
                      child: Icon(
                        Icons.broken_image_outlined,
                        color: AppColors.sceGrey99,
                        size: 40.sp,
                      ),
                    ),
                  ),
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
      ),
    );
  }
}

void _showAttachmentDialog(BuildContext context, ChatAttachment a) {
  final isImage = a.contentType.startsWith('image/');
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: AppColors.sceCardBg,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      title: Text(
        isImage ? 'View Image' : 'Download File',
        style: FontManager.bodyMedium(color: AppColors.white).copyWith(fontWeight: FontWeight.bold),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isImage)
            ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: Image.network(
                a.publicUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Icon(Icons.broken_image, color: AppColors.sceGrey99, size: 50.sp),
              ),
            )
          else
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                children: [
                  Icon(Icons.insert_drive_file, color: AppColors.sceTeal, size: 30.sp),
                  AppSpacing.w12,
                  Expanded(
                    child: Text(
                      a.fileName,
                      style: FontManager.bodySmall(color: AppColors.white),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          AppSpacing.h16,
          Text(
            'Size: ${_formatSize(a.sizeBytes)}',
            style: FontManager.bodySmall(color: AppColors.sceGrey99),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Close', style: FontManager.bodySmall(color: AppColors.sceGrey99)),
        ),
        ElevatedButton(
          onPressed: () async {
            Navigator.pop(context);
            final uri = Uri.parse(a.publicUrl);
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.sceTeal,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
          ),
          child: Text('Download', style: FontManager.bodySmall(color: AppColors.white)),
        ),
      ],
    ),
  );
}

String _formatSize(int bytes) {
  if (bytes < 1024) return '$bytes B';
  if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
  return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
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
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
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
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
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

/// Animated three-dot typing indicator aligned to the support (left) side.
class _TypingIndicator extends StatefulWidget {
  const _TypingIndicator();

  @override
  State<_TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<_TypingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: AppColors.sceCardBg,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.r),
            topRight: Radius.circular(16.r),
            bottomRight: Radius.circular(16.r),
          ),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.05),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            return AnimatedBuilder(
              animation: _ctrl,
              builder: (_, child) {
                // Stagger each dot by 0.2
                final delay = i * 0.2;
                final t = (_ctrl.value - delay).clamp(0.0, 1.0);
                // Bounce: go up then back down in first half of the cycle.
                final bounce = (t < 0.5)
                    ? Curves.easeOut.transform(t * 2)
                    : Curves.easeIn.transform(1 - (t - 0.5) * 2);
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 3.w),
                  child: Transform.translate(
                    offset: Offset(0, -4 * bounce),
                    child: Container(
                      width: 8.w,
                      height: 8.w,
                      decoration: BoxDecoration(
                        color: AppColors.sceGrey99
                            .withValues(alpha: 0.4 + 0.6 * bounce),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                );
              },
            );
          }),
        ),
      ),
    );
  }
}

class _ChatShimmer extends StatelessWidget {
  const _ChatShimmer();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.sceCardBg,
      highlightColor: Colors.white.withValues(alpha: 0.05),
      child: ListView.builder(
        padding: EdgeInsets.all(20.w),
        itemCount: 5,
        itemBuilder: (context, index) {
          final isLeft = index % 2 == 0;
          return Align(
            alignment: isLeft ? Alignment.centerLeft : Alignment.centerRight,
            child: Container(
              margin: EdgeInsets.only(bottom: 16.h),
              width: (index == 0 || index == 3) ? 120.w : 200.w,
              height: (index == 1) ? 100.h : 60.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.r),
                  topRight: Radius.circular(16.r),
                  bottomLeft: Radius.circular(isLeft ? 0 : 16.r),
                  bottomRight: Radius.circular(isLeft ? 16.r : 0),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
