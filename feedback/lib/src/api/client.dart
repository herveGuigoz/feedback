import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

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
  Future<Object?> multipart(
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

    return _decodeResponse(response.bodyBytes, statusCode: response.statusCode);
  }

  @protected
  Future<Object?> get(
    String path, {
    Map<String, Object?>? headers,
    Map<String, String?>? queryParams,
  }) {
    return _send(path: path, method: 'GET', headers: headers, queryParams: queryParams);
  }

  @protected
  Future<Object?> post(
    String path, {
    required Map<String, Object?> body,
    Map<String, Object?>? headers,
    Map<String, String?>? queryParams,
  }) {
    return _send(path: path, method: 'POST', body: body, headers: headers, queryParams: queryParams);
  }

  @protected
  Future<Object?> put(
    String path, {
    required Map<String, Object?> body,
    Map<String, Object?>? headers,
    Map<String, String?>? queryParams,
  }) {
    return _send(path: path, method: 'PUT', body: body, headers: headers, queryParams: queryParams);
  }

  @protected
  Future<Object?> patch(
    String path, {
    required Map<String, Object?> body,
    Map<String, Object?>? headers,
    Map<String, String?>? queryParams,
  }) {
    return _send(path: path, method: 'PATCH', body: body, headers: headers, queryParams: queryParams);
  }

  @protected
  Future<Object?> delete(
    String path, {
    Map<String, Object?>? headers,
    Map<String, String?>? queryParams,
  }) {
    return _send(path: path, method: 'DELETE', headers: headers, queryParams: queryParams);
  }

  /// Sends a request to the server
  Future<Object?> _send({
    required String path,
    required String method,
    Map<String, Object?>? body,
    Map<String, Object?>? headers,
    Map<String, String?>? queryParams,
  }) async {
    final uri = _buildUri(path: path, queryParams: queryParams);
    log('Sending $method request to $uri', name: 'RestClient');
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

    return _decodeResponse(response.bodyBytes, statusCode: response.statusCode);
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
  Future<Object?> _decodeResponse(Object? body, {int? statusCode}) async {
    if (body == null) {
      return null;
    }

    assert(
      body is String || body is Map<String, Object?> || body is List<int>,
      'Unexpected response body type: ${body.runtimeType}',
    );

    try {
      final decodedBody = switch (body) {
        final Map<String, Object?> map => map,
        final String str => await _decodeString(str),
        final List<int> bytes => await _decodeBytes(bytes),
        _ => Error.throwWithStackTrace(
            ApiClientException(message: 'Unexpected response body type: ${body.runtimeType}', statusCode: statusCode),
            StackTrace.current,
          ),
      };

      if (decodedBody case {'error': final Map<String, Object?> error}) {
        throw ApiClientException(message: 'Error response from server', cause: error, statusCode: statusCode);
      }

      if (decodedBody case {'data': final Map<String, Object?> data}) {
        return data;
      }

      return decodedBody;
    } on ApiClientException {
      rethrow;
    } on Object catch (e, stackTrace) {
      Error.throwWithStackTrace(
        ApiClientException(message: 'Error occured during decoding', statusCode: statusCode, cause: e),
        stackTrace,
      );
    }
  }

  /// Decodes a [String] to a [Map<String, Object?>]
  Future<Object?> _decodeString(String str) async {
    if (str.isEmpty) {
      return null;
    }

    if (str.length > 1000 && !kIsWeb) {
      return Isolate.run(() => json.decode(str));
    }

    return json.decode(str) as Object?;
  }

  /// Decodes a [List<int>] to a [Map<String, Object?>]
  Future<Object?> _decodeBytes(List<int> bytes) async {
    if (bytes.isEmpty) {
      return null;
    }

    if (bytes.length > 1000 && !kIsWeb) {
      return Isolate.run(() => _jsonUTF8.decode(bytes)!);
    }

    return _jsonUTF8.decode(bytes);
  }
}
