import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String kBaseUrl = 'http://mmapp.jineecs.in/api';

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

      if (response.statusCode == 200) {
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
    Map<String, String>? headers,
    String? token,
  }) async {
    try {
      final url = Uri.parse('$kBaseUrl$endpoint');

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

      // ✅ Handle 204 No Content explicitly
      if (response.statusCode == 204) {
        return null; // Return null or handle gracefully
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        var errorResponse = response.body.isNotEmpty
            ? json.decode(response.body)
            : {'error': 'Unknown error occurred'};
        throw errorResponse['error'] ??
            'Failed to process request. Please try again later.';
      }
    } catch (e) {
      throw e.toString();
    }
  }
}
