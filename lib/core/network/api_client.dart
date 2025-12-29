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

  Future<String> fetchWordMeaning(String word) async {
    try {
      final response = await get(
        Uri.parse('https://api.dictionaryapi.dev/api/v2/entries/en/$word'),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        if (data.isNotEmpty) {
          final entry = data[0] as Map<String, dynamic>;
          final meanings = entry['meanings'] as List?;
          if (meanings != null && meanings.isNotEmpty) {
            final definitions = meanings[0]['definitions'] as List?;
            if (definitions != null && definitions.isNotEmpty) {
              return definitions[0]['definition'] as String;
            }
          }
          final phonetics = entry['phonetics'] as List?;
          if (phonetics != null && phonetics.isNotEmpty) {
            final phonetic = phonetics[0] as Map<String, dynamic>;
            return phonetic['text'] ?? 'No phonetic available';
          }
        }
        return 'No meaning found';
      } else {
        throw ApiException(
          'HTTP ${response.statusCode}: ${response.reasonPhrase}',
        );
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Failed to fetch word meaning: $e');
    }
  }
}
