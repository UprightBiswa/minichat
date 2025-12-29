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
        appBar: AppBar(title: Text(widget.user.name)),
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
    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSender ? AppColors.senderBubble : AppColors.receiverBubble,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(child: Text(isSender ? widget.user.name[0] : 'B')),
            const SizedBox(width: 8),
            Expanded(child: _buildMessageText(message.text)),
          ],
        ),
      ),
    );
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
