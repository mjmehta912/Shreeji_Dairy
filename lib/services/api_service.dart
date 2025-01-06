import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String kBaseUrl = 'http://mmapp.jineecs.in/api';

  static Future<dynamic> getRequest({
    required String endpoint,
    Map<String, String>? queryParams,
    Map<String, String>? headers,
  }) async {
    try {
      final url = Uri.parse('$kBaseUrl$endpoint').replace(
        queryParameters: queryParams,
      );

      headers ??= {
        'Content-Type': 'application/json',
      };

      final response = await http.get(
        url,
        headers: headers,
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        var errorResponse = json.decode(response.body);
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
  }) async {
    try {
      final url = Uri.parse('$kBaseUrl$endpoint');

      headers ??= {
        'Content-Type': 'application/json',
      };

      final response = await http.post(
        url,
        headers: headers,
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        return json.decode(
          response.body,
        );
      } else {
        var errorResponse = json.decode(response.body);
        throw errorResponse['error'] ??
            'Failed to load. Please try again later.';
      }
    } catch (e) {
      throw e.toString();
    }
  }
}
