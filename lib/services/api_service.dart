import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // static const String kBaseUrl = 'http://43.250.164.139:8080/api';

  static const String kBaseUrl = 'http://192.168.0.135:8083/api';

  static Future<dynamic> getRequest({
    required String endpoint,
    Map<String, String>? queryParams,
    Map<String, String>? headers,
    String? token,
  }) async {
    try {
      final url = Uri.parse('$kBaseUrl$endpoint').replace(
        queryParameters: queryParams,
      );

      headers ??= {
        'Content-Type': 'application/json',
      };

      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }

      final response = await http.get(
        url,
        headers: headers,
      );

      // ✅ Handle 204 No Content explicitly
      if (response.statusCode == 204) {
        return null; // Return null or an empty value as per your app's requirement
      }

      final contentType = response.headers['content-type'];
      if (contentType != null && contentType.contains('application/pdf')) {
        return response.bodyBytes;
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        var errorResponse = response.body.isNotEmpty
            ? json.decode(response.body)
            : {'error': 'Unknown error occurred'};
        throw errorResponse['error'] ??
            'Failed to load. Please try again later.';
      }
    } catch (e) {
      throw e.toString();
    }
  }

  static Future<dynamic> postRequest({
    required String endpoint,
    required Map<String, dynamic> requestBody,
    Map<String, String>? queryParams,
    Map<String, String>? headers,
    String? token,
  }) async {
    try {
      Uri url = Uri.parse('$kBaseUrl$endpoint');

      if (queryParams != null && queryParams.isNotEmpty) {
        url = url.replace(queryParameters: queryParams);
      }

      headers ??= {
        'Content-Type': 'application/json',
      };

      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }

      final response = await http.post(
        url,
        headers: headers,
        body: json.encode(requestBody),
      );

      if (response.statusCode == 204) {
        return null;
      }

      final contentType = response.headers['content-type'];
      if (contentType != null && contentType.contains('application/pdf')) {
        return response.bodyBytes;
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      }

      var errorResponse = response.body.isNotEmpty
          ? json.decode(response.body)
          : {'error': 'Unknown error occurred'};

      if (response.statusCode == 403) {
        throw {
          'status': 403,
          'message': errorResponse['error'],
        };
      }

      if (response.statusCode == 402) {
        throw {
          'status': 402,
          'message': errorResponse['error'],
        };
      }

      throw {
        'status': response.statusCode,
        'message': errorResponse['error'] ??
            'Failed to process request. Please try again later.',
      };
    } catch (e) {
      if (e is Map<String, dynamic>) {
        rethrow;
      }
      throw {
        'status': 500,
        'message': e.toString(),
      };
    }
  }
}
