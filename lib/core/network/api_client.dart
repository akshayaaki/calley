import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';
import 'api_exceptions.dart';

class ApiClient {
  final http.Client _client;
  final String _baseUrl;

  ApiClient({http.Client? client, String? baseUrl})
      : _client = client ?? http.Client(),
        _baseUrl = baseUrl ?? ApiConstants.baseUrl;

  Map<String, String> _getHeaders({String? token}) {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  Future<dynamic> get(
    String endpoint, {
    Map<String, String>? queryParams,
    String? token,
  }) async {
    Uri uri = Uri.parse('$_baseUrl$endpoint');
    if (queryParams != null && queryParams.isNotEmpty) {
      uri = uri.replace(queryParameters: queryParams);
    }

    try {
      final response = await _client
          .get(uri, headers: _getHeaders(token: token))
          .timeout(ApiConstants.connectTimeout);
      return _processResponse(response);
    } on SocketException {
      throw NetworkException();
    } on TimeoutException {
      throw NetworkException('Connection timed out. Please try again.');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(e.toString());
    }
  }

  Future<dynamic> post(
    String endpoint, {
    dynamic body,
    String? token,
  }) async {
    final uri = Uri.parse('$_baseUrl$endpoint');

    try {
      final response = await _client
          .post(
            uri,
            headers: _getHeaders(token: token),
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(ApiConstants.connectTimeout);
      return _processResponse(response);
    } on SocketException {
      throw NetworkException();
    } on TimeoutException {
      throw NetworkException('Connection timed out. Please try again.');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(e.toString());
    }
  }

  Future<dynamic> put(
    String endpoint, {
    dynamic body,
    String? token,
  }) async {
    final uri = Uri.parse('$_baseUrl$endpoint');

    try {
      final response = await _client
          .put(
            uri,
            headers: _getHeaders(token: token),
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(ApiConstants.connectTimeout);
      return _processResponse(response);
    } on SocketException {
      throw NetworkException();
    } on TimeoutException {
      throw NetworkException('Connection timed out. Please try again.');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(e.toString());
    }
  }

  Future<dynamic> delete(
    String endpoint, {
    String? token,
  }) async {
    final uri = Uri.parse('$_baseUrl$endpoint');

    try {
      final response = await _client
          .delete(uri, headers: _getHeaders(token: token))
          .timeout(ApiConstants.connectTimeout);
      return _processResponse(response);
    } on SocketException {
      throw NetworkException();
    } on TimeoutException {
      throw NetworkException('Connection timed out. Please try again.');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(e.toString());
    }
  }

  dynamic _processResponse(http.Response response) {
    dynamic decoded;
    try {
      if (response.body.isNotEmpty) {
        decoded = jsonDecode(response.body);
      }
    } catch (_) {
      decoded = null;
    }

    switch (response.statusCode) {
      case 200:
      case 201:
      case 202:
        return decoded;
      case 400:
        final msg = decoded is Map ? (decoded['message'] ?? 'Bad request') : 'Bad request';
        throw ValidationException(msg.toString(), statusCode: 400, details: decoded);
      case 401:
        final msg = decoded is Map ? (decoded['message'] ?? 'Unauthorized') : 'Unauthorized';
        throw UnauthorizedException(msg.toString());
      case 404:
        final msg = decoded is Map ? (decoded['message'] ?? 'Resource not found') : 'Resource not found';
        throw NotFoundException(msg.toString());
      case 500:
      case 502:
      case 503:
      default:
        final msg = decoded is Map ? (decoded['message'] ?? 'Server error') : 'Server error (${response.statusCode})';
        throw ServerException(msg.toString(), response.statusCode);
    }
  }
}

