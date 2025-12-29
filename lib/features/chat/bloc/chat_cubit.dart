import 'package:flutter_bloc/flutter_bloc.dart';

import '../../users/bloc/users_cubit.dart';
import '../../users/models/user_model.dart';
import '../data/chat_repository.dart';
import '../models/message_model.dart';

class ChatState {
  final List<Message> messages;
  final bool isLoading;
  final String? error;

  ChatState(this.messages, this.isLoading, this.error);

  ChatState copyWith({
    List<Message>? messages,
    bool? isLoading,
    String? error,
  }) {
    return ChatState(
      messages ?? this.messages,
      isLoading ?? this.isLoading,
      error ?? this.error,
    );
  }
}

class ChatCubit extends Cubit<ChatState> {
  final ChatRepository repository;
  final User user;
  final UsersCubit usersCubit;

  ChatCubit(this.repository, this.user, this.usersCubit)
    : super(ChatState([], false, null));

  void sendMessage(String text) {
    final senderMessage = Message(text, MessageType.sender);
    final updatedMessages = List<Message>.from(state.messages)
      ..add(senderMessage);
    emit(ChatState(updatedMessages, true, null));
    usersCubit.updateUser(
      user.copyWith(lastMessage: text, lastTime: DateTime.now()),
    );
    _fetchReceiverMessage();
  }

  Future<void> _fetchReceiverMessage() async {
    try {
      final response = await repository.fetchReceiverMessage();
      final receiverMessage = Message(response, MessageType.receiver);
      final newMessages = List<Message>.from(state.messages)
        ..add(receiverMessage);
      emit(ChatState(newMessages, false, null));
    } catch (e) {
      emit(ChatState(state.messages, false, e.toString()));
    }
  }

  void retryFetch() {
    if (state.messages.isNotEmpty &&
        state.messages.last.type == MessageType.sender) {
      emit(state.copyWith(isLoading: true, error: null));
      _fetchReceiverMessage();
    }
  }
}
