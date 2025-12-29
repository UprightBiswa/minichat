import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/api_client.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../users/bloc/users_cubit.dart';
import '../../users/models/user_model.dart';
import '../bloc/chat_cubit.dart';
import '../data/chat_repository.dart';
import '../models/message_model.dart';

class ChatScreen extends StatefulWidget {
  final User user;

  const ChatScreen({required this.user, super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatCubit(
        ChatRepository(ApiClient()),
        widget.user,
        context.read<UsersCubit>(),
      ),
      child: Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Stack(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.primary,
                  child: Text(
                    widget.user.name[0].toUpperCase(),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: widget.user.isOnline ? Colors.green : Colors.grey,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.user.name, style: TextStyle(fontSize: 16)),
              Text(
                widget.user.isOnline ? 'Online' : 'Offline',
                style: TextStyle(
                  fontSize: 12,
                  color: widget.user.isOnline ? Colors.green : Colors.grey,
                ),
              ),
            ],
          ),
        ),
        body: BlocListener<ChatCubit, ChatState>(
          listenWhen: (previous, current) =>
              previous.error == null && current.error != null,
          listener: (context, state) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${state.error}'),
                action: SnackBarAction(
                  label: 'Retry',
                  onPressed: () => context.read<ChatCubit>().retryFetch(),
                ),
              ),
            );
          },
          child: BlocBuilder<ChatCubit, ChatState>(
            builder: (context, state) {
              final column = Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: state.messages.length,
                      itemBuilder: (context, index) {
                        final message = state.messages[index];
                        return _buildMessageBubble(message);
                      },
                    ),
                  ),
                  if (state.error != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ElevatedButton(
                        onPressed: () => context.read<ChatCubit>().retryFetch(),
                        child: const Text('Retry'),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(child: TextField(controller: _controller)),
                        state.isLoading
                            ? const CircularProgressIndicator()
                            : IconButton(
                                icon: const Icon(Icons.send),
                                onPressed: () {
                                  final text = _controller.text.trim();
                                  if (text.isNotEmpty) {
                                    context.read<ChatCubit>().sendMessage(text);
                                    _controller.clear();
                                  }
                                },
                              ),
                      ],
                    ),
                  ),
                ],
              );
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (_scrollController.hasClients) {
                  _scrollController.animateTo(
                    _scrollController.position.maxScrollExtent,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                  );
                }
              });
              return column;
            },
          ),
        ),
      ),
    );
  }

  Widget _buildMessageBubble(Message message) {
    final isSender = message.type == MessageType.sender;
    final borderRadius = isSender
        ? BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(4),
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          )
        : BorderRadius.only(
            topLeft: Radius.circular(4),
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          );
    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: isSender
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isSender
                  ? AppColors.senderBubble
                  : AppColors.receiverBubble,
              borderRadius: borderRadius,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: isSender
                  ? [
                      Flexible(child: _buildMessageText(message.text)),
                      const SizedBox(width: 8),
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: AppColors.primary,
                        child: Text(
                          widget.user.name[0].toUpperCase(),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ]
                  : [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: AppColors.primary,
                        child: Text('B', style: TextStyle(color: Colors.white)),
                      ),
                      const SizedBox(width: 8),
                      Flexible(child: _buildMessageText(message.text)),
                    ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              _formatMessageTime(message.timestamp),
              style: TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  String _formatMessageTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);
    if (difference.inDays == 0) {
      return '${time.hour}:${time.minute.toString().padLeft(2, '0')} ${time.hour >= 12 ? 'PM' : 'AM'}';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else {
      return '${difference.inDays} days ago';
    }
  }

  Widget _buildMessageText(String text) {
    List<String> words = text.split(RegExp(r'\s+'));
    List<String> spaces = RegExp(
      r'\s+',
    ).allMatches(text).map((m) => m.group(0)!).toList();
    List<TextSpan> spans = [];
    for (int i = 0; i < words.length; i++) {
      spans.add(
        TextSpan(
          text: words[i],
          recognizer: LongPressGestureRecognizer()
            ..onLongPress = () async {
              final apiClient = ApiClient();
              String meaning;
              try {
                meaning = await apiClient.fetchWordMeaning(words[i]);
              } catch (e) {
                meaning = 'Error: $e';
              }
              if (mounted) {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => Container(
                    padding: const EdgeInsets.all(16),
                    child: Text(meaning),
                  ),
                );
              }
            },
        ),
      );
      if (i < spaces.length) {
        spans.add(TextSpan(text: spaces[i]));
      }
    }
    return RichText(
      text: TextSpan(children: spans, style: AppTextStyles.body),
    );
  }
}
