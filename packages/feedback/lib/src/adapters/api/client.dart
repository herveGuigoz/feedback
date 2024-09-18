part of 'api.dart';

enum AuthStatus { authenticated, unauthenticated }

typedef ReadToken = String? Function();

abstract class ApiClientInterface {
  /// Authenticates the user with the given [username] and [password].
  Future<User> authenticate({required String username, required String password});

  /// Finds issues for the given [url].
  Future<List<FeedbackEvent>> findIssues(String url);

  /// Posts an issue.
  Future<FeedbackEvent> createIssue({
    required Uint8List image,
    required String body,
    required String url,
    required String device,
    required Size screenSize,
  });
}

final class ApiClient extends RestClient implements ApiClientInterface {
  ApiClient({
    required super.baseUrl,
    required this.projectId,
    required this.storage,
    super.client,
  });

  final String projectId;

  final StorageInterface storage;

  String? get _accessToken => storage.read('accessToken');

  @override
  Future<User> authenticate({required String username, required String password}) async {
    final response = await post(
      '/api/auth',
      body: {'username': username, 'password': password},
    );

    if (response case {'token': final String token}) {
      final user = await findUserInfo(accessToken: token);
      await storage.write(key: 'accessToken', value: token);
      return User.fromJson({...user, 'accessToken': token});
    }

    Error.throwWithStackTrace(ApiClientException(message: 'Invalid response: $response'), StackTrace.current);
  }

  Future<Map<String, dynamic>> findUserInfo({required String accessToken}) async {
    final response = await get(
      '/api/auth/user',
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response == null) {
      Error.throwWithStackTrace(ApiClientException(message: 'Invalid response: $response'), StackTrace.current);
    }

    return response;
  }

  @override
  Future<List<FeedbackEvent>> findIssues(String url) async {
    final response = await get(
      '/api/issues',
      headers: {'Authorization': 'Bearer $_accessToken'},
      queryParams: {'url': url},
    );

    if (response case {'data': final List<dynamic> events}) {
      return [for (final event in events) FeedbackEvent.fromJson(event as Map<String, dynamic>)];
    }

    Error.throwWithStackTrace(ApiClientException(message: 'Invalid response: $response'), StackTrace.current);
  }

  @override
  Future<FeedbackEvent> createIssue({
    required Uint8List image,
    required String body,
    required String url,
    required String device,
    required Size screenSize,
  }) async {
    final response = await multipart(
      '/api/issues',
      file: image,
      headers: {'Authorization': 'Bearer $_accessToken'},
      data: {
        'url': Uri.encodeComponent(url),
        'body': body,
        'project': '/api/projects/$projectId',
      },
    );

    if (response != null) {
      return FeedbackEvent.fromJson(response);
    }

    Error.throwWithStackTrace(ApiClientException(message: 'Invalid response: $response'), StackTrace.current);
  }
}
