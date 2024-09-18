part of 'api.dart';

typedef ReadToken = String? Function();

final class ApiClient extends RestClient {
  ApiClient({
    required super.baseUrl,
    required this.projectId,
    required this.storage,
    super.client,
  });

  final String projectId;

  final Storage storage;

  String? get _accessToken => storage.read('accessToken');

  Future<User> authenticate({required String username, required String password}) async {
    final response = await post(
      '/api/auth',
      body: {'username': username, 'password': password},
    );

    if (response == null) {
      throw ApiClientException(message: 'Invalid response: $response');
    }

    final token = response['token'] as String?;

    if (token == null) {
      throw ApiClientException(message: 'Invalid response: $response');
    }

    final user = await getUserInfo(accessToken: token);

    await storage.write(key: 'accessToken', value: token);

    return User.fromJson({...user, 'accessToken': token});
  }

  Future<Map<String, dynamic>> getUserInfo({required String accessToken}) async {
    final response = await get(
      '/api/auth/user',
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response == null) {
      throw ApiClientException(message: 'Invalid response: $response');
    }

    return response;
  }

  Future<List<FeedbackEvent>> findIssues(String url) async {
    final response = await get(
      '/api/issues',
      headers: {'Authorization': 'Bearer $_accessToken'},
      queryParams: {'path': Uri.encodeComponent(url)},
    );

    final events = response!['data'] as List<dynamic>;

    return [
      for (final event in events) FeedbackEvent.fromJson(event as Map<String, dynamic>),
    ];
  }

  Future<FeedbackEvent> postIssue({
    required Uint8List image,
    required String body,
    required String url,
  }) async {
    try {
      final response = await multipart(
        '/api/issues',
        file: image,
        headers: {'Authorization': 'Bearer $_accessToken'},
        data: {
          'path': Uri.encodeComponent(url),
          'body': body,
          'project': '/api/projects/$projectId',
        },
      );

      if (response == null) {
        throw Exception('Invalid response: $response');
      }

      return FeedbackEvent.fromJson(response);
    } on ApiClientException catch (e) {
      throw Exception('Failed to post feedback: ${e.message}');
    }
  }
}
