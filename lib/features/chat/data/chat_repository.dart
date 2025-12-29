import '../../../core/network/api_client.dart';

class ChatRepository {
  final ApiClient apiClient;

  ChatRepository(this.apiClient);

  Future<String> fetchReceiverMessage() async {
    return await apiClient.fetchRandomQuote();
  }
}
