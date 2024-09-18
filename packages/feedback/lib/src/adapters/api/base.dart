part of 'api.dart';

class ApiClientException implements Exception {
  ApiClientException({required this.message, this.statusCode, this.cause});

  final String message;

  final int? statusCode;

  final Object? cause;

  @override
  String toString() {
    return 'RestClientException: $message';
  }
}

/// {@macro rest_client}
abstract base class RestClient {
  /// {@macro rest_client}
  RestClient({required String baseUrl, http.Client? client})
      : baseUri = Uri.parse(baseUrl),
        _client = client ?? http.Client();

  /// The base url for the client
  final Uri baseUri;

  final http.Client _client;

  static final _jsonUTF8 = json.fuse(utf8);

  @protected
  Future<Map<String, dynamic>?> multipart(
    String path, {
    required Uint8List file,
    String? filename,
    Map<String, Object?>? headers,
    Map<String, String>? data,
  }) async {
    final uri = _buildUri(path: path);

    final request = http.MultipartRequest('POST', uri);

    final name = filename ?? '${DateTime.now().millisecondsSinceEpoch}.png';

    request.files.add(
      http.MultipartFile.fromBytes('file', file, filename: name),
    );

    if (headers != null) {
      request.headers.addAll(
        headers.map((key, value) => MapEntry(key, value.toString())),
      );
    }

    if (data != null) {
      request.fields.addAll(data);
    }

    final response = await _client.send(request).then(http.Response.fromStream);

    return _decodeResponse(response.body, statusCode: response.statusCode);
  }

  @protected
  Future<Map<String, dynamic>?> get(
    String path, {
    Map<String, Object?>? headers,
    Map<String, String?>? queryParams,
  }) {
    return _send(path: path, method: 'GET', headers: headers, queryParams: queryParams);
  }

  @protected
  Future<Map<String, dynamic>?> post(
    String path, {
    required Map<String, Object?> body,
    Map<String, Object?>? headers,
    Map<String, String?>? queryParams,
  }) {
    return _send(path: path, method: 'POST', body: body, headers: headers, queryParams: queryParams);
  }

  @protected
  Future<Map<String, dynamic>?> put(
    String path, {
    required Map<String, Object?> body,
    Map<String, Object?>? headers,
    Map<String, String?>? queryParams,
  }) {
    return _send(path: path, method: 'PUT', body: body, headers: headers, queryParams: queryParams);
  }

  @protected
  Future<Map<String, dynamic>?> patch(
    String path, {
    required Map<String, Object?> body,
    Map<String, Object?>? headers,
    Map<String, String?>? queryParams,
  }) {
    return _send(path: path, method: 'PATCH', body: body, headers: headers, queryParams: queryParams);
  }

  @protected
  Future<Map<String, dynamic>?> delete(
    String path, {
    Map<String, Object?>? headers,
    Map<String, String?>? queryParams,
  }) {
    return _send(path: path, method: 'DELETE', headers: headers, queryParams: queryParams);
  }

  /// Sends a request to the server
  Future<Map<String, dynamic>?> _send({
    required String path,
    required String method,
    Map<String, Object?>? body,
    Map<String, Object?>? headers,
    Map<String, String?>? queryParams,
  }) async {
    final uri = _buildUri(path: path, queryParams: queryParams);
    final request = http.Request(method, uri);

    if (body != null) {
      request.bodyBytes = _encodeBody(body);
      request.headers['content-type'] = 'application/json;charset=utf-8';
    }

    if (headers != null) {
      request.headers.addAll(
        headers.map((key, value) => MapEntry(key, value.toString())),
      );
    }

    final response = await _client.send(request).then(http.Response.fromStream);

    return _decodeResponse(response.body, statusCode: response.statusCode);
  }

  /// Encodes [body] to JSON and then to UTF8
  List<int> _encodeBody(Map<String, Object?> body) {
    try {
      return _jsonUTF8.encode(body);
    } on Object catch (e, stackTrace) {
      Error.throwWithStackTrace(ApiClientException(message: 'Error occurred during encoding', cause: e), stackTrace);
    }
  }

  /// Builds [Uri] from [path], [queryParams] and [baseUri]
  Uri _buildUri({required String path, Map<String, String?>? queryParams}) {
    return baseUri.replace(
      path: path,
      queryParameters: queryParams?.map((key, value) => MapEntry(key, value.toString())),
    );
  }

  /// Decodes the response [body]
  Future<Map<String, dynamic>?> _decodeResponse(String body, {int? statusCode}) async {
    try {
      final decodedBody = jsonDecode(body);

      final value = switch (decodedBody) {
        final Map<String, Object?> map => map,
        final List<dynamic> list => {'data': list},
        _ => null,
      };

      if (value case {'error': final Map<String, Object?> error}) {
        throw ApiClientException(message: 'Error response from server', cause: error, statusCode: statusCode);
      }

      return value;
    } on ApiClientException catch (_) {
      rethrow;
    } on Object catch (e, stackTrace) {
      Error.throwWithStackTrace(
        ApiClientException(message: 'Error occured during decoding response', statusCode: statusCode, cause: e),
        stackTrace,
      );
    }
  }
}
