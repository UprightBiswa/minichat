import 'package:flutter/material.dart';
import 'dart:math' as math;
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
          titleSpacing: 0,
          title: Row(
            children: [
              Container(
                margin: const EdgeInsets.only(right: 10),
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Color(0xFFAB47BC), Color(0xFF7B1FA2)],
                  ),
                ),
                child: Text(
                  widget.user.name[0].toUpperCase(),
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Column(
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
                      padding: const EdgeInsets.only(bottom: 10),
                      itemCount:
                          state.messages.length + (state.isLoading ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == state.messages.length) {
                          return _buildTypingIndicator();
                        }
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
                  _buildInputArea(context, state),
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

  Widget _buildInputArea(BuildContext context, ChatState state) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                hintText: "Type a message...",
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(
                    color: Theme.of(context).primaryColor.withOpacity(0.5),
                  ),
                ),
              ),
              onSubmitted: (value) => _sendMessage(context),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: state.isLoading ? null : () => _sendMessage(context),
            child: CircleAvatar(
              backgroundColor: state.isLoading
                  ? Colors.grey.shade300
                  : Theme.of(context).primaryColor,
              child: Icon(Icons.send, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage(BuildContext context) {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      context.read<ChatCubit>().sendMessage(text);
      _controller.clear();
    }
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildAvatar(widget.user.name, false),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F1F1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
                bottomRight: Radius.circular(15),
                bottomLeft: Radius.circular(0),
              ),
            ),
            child: const TypingDots(),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Message message) {
    final isSender = message.type == MessageType.sender;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Row(
        mainAxisAlignment: isSender
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isSender) ...[
            _buildAvatar(widget.user.name, false),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: isSender
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    gradient: isSender
                        ? const LinearGradient(
                            colors: [Color(0xFF007BFF), Color(0xFF0056D2)],
                          )
                        : null,
                    color: isSender ? null : const Color(0xFFF1F1F1),
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(15),
                      topRight: const Radius.circular(15),
                      bottomLeft: isSender
                          ? const Radius.circular(15)
                          : const Radius.circular(0),
                      bottomRight: isSender
                          ? const Radius.circular(0)
                          : const Radius.circular(15),
                    ),
                  ),
                  child: _buildMessageText(message.text, isSender),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4, left: 4, right: 4),
                  child: Text(
                    _formatMessageTime(message.timestamp),
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
          if (isSender) ...[const SizedBox(width: 8), _buildAvatar("Me", true)],
        ],
      ),
    );
  }

  Widget _buildAvatar(String name, bool isSender) {
    return Container(
      width: 32,
      height: 32,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: isSender
            ? LinearGradient(
                colors: [Colors.blue.shade400, Colors.blue.shade700],
              )
            : const LinearGradient(
                colors: [Color(0xFFAB47BC), Color(0xFF7B1FA2)],
              ),
      ),
      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : '?',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
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

  Widget _buildMessageText(String text, bool isSender) {
    List<String> words = text.split(RegExp(r'\s+'));
    List<String> spaces = RegExp(
      r'\s+',
    ).allMatches(text).map((m) => m.group(0)!).toList();
    List<TextSpan> spans = [];
    for (int i = 0; i < words.length; i++) {
      spans.add(
        TextSpan(
          text: words[i],
          recognizer: TapGestureRecognizer()
            ..onTap = () => _showWordDefinition(context, words[i]),
        ),
      );
      if (i < spaces.length) {
        spans.add(TextSpan(text: spaces[i]));
      }
    }
    return RichText(
      text: TextSpan(
        children: spans,
        style: isSender
            ? TextStyle(color: Colors.white)
            : TextStyle(color: Colors.black87),
      ),
    );
  }

  void _showWordDefinition(BuildContext context, String word) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Definition",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                word,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              FutureBuilder<String>(
                future: ApiClient().fetchWordMeaning(word),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text(
                      "Could not find definition.",
                      style: TextStyle(color: Colors.grey.shade400),
                    );
                  } else {
                    return Text(
                      snapshot.data ?? "No definition found.",
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.5,
                        color: Colors.black87,
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}

class TypingDots extends StatefulWidget {
  const TypingDots({super.key});
  @override
  State<TypingDots> createState() => _TypingDotsState();
}

class _TypingDotsState extends State<TypingDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final double t = (_controller.value + index * 0.2) % 1.0;
            final double offset = math.sin(t * 2 * math.pi) * 0.5 + 0.5;
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.5 + (offset * 0.5)),
                shape: BoxShape.circle,
              ),
            );
          },
        );
      }),
    );
  }
}
