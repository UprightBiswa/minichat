import 'package:http/http.dart' as http;
import 'dart:convert';
import 'api_exception.dart';

class ApiClient extends http.BaseClient {
  final http.Client _client = http.Client();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    return _client.send(request);
  }

  Future<String> fetchRandomQuote() async {
    try {
      final response = await get(Uri.parse('https://api.quotable.io/random'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return data['content'] as String;
      } else {
        throw ApiException(
          'HTTP ${response.statusCode}: ${response.reasonPhrase}',
        );
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Failed to fetch quote: $e');
    }
  }
}
