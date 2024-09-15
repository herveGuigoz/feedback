import 'package:feedback/src/api/client.dart';
import 'package:feedback/src/core/models.dart';

final class ApiClient extends RestClient {
  ApiClient({
    required super.baseUrl,
    required String token,
    super.client,
  }) : _token = token;

  final String _token;

  Future<List<FeedbackEvent>> getFeedbacks(String path) async {
    final events = await get(
      '/api/feedbacks',
      headers: {'X-AUTH-TOKEN': _token},
      queryParams: {'path': Uri.encodeComponent(path)},
    );

    if (events is! List<dynamic>) {
      throw Exception('Invalid resonse: $events');
    }

    return [
      for (final event in events) FeedbackEvent.fromJson(event as Map<String, dynamic>),
    ];
  }

  Future<FeedbackEvent> postFeedback(FeedbackData data) async {
    try {
      final response = await multipart(
        '/api/feedbacks',
        file: data.screenshot.image,
        headers: {'X-AUTH-TOKEN': _token},
        data: data.toJson(),
      );

      if (response == null) {
        throw Exception('Invalid response: $response');
      }

      return FeedbackEvent.fromJson(response as Map<String, dynamic>);
    } on ApiClientException catch (e) {
      throw Exception('Failed to post feedback: ${e.message}');
    }
  }
}
