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
    Map<String, String>?
        queryParams, // New parameter to handle query parameters
    Map<String, String>? headers,
    String? token,
  }) async {
    try {
      // Prepare the URL with query parameters if provided
      Uri url = Uri.parse('$kBaseUrl$endpoint');

      // Add query parameters if they exist
      if (queryParams != null && queryParams.isNotEmpty) {
        url = url.replace(queryParameters: queryParams);
      }

      // Set default headers and add authorization token if available
      headers ??= {
        'Content-Type': 'application/json',
      };

      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }

      // Send the POST request with the provided body and headers
      final response = await http.post(
        url,
        headers: headers,
        body: json.encode(requestBody),
      );

      // Handle 204 No Content response explicitly
      if (response.statusCode == 204) {
        return null; // No content to return
      }

      // Check if the response is PDF (binary data)
      final contentType = response.headers['content-type'];
      if (contentType != null && contentType.contains('application/pdf')) {
        // Return raw binary bytes for PDF
        return response.bodyBytes;
      }

      // Handle JSON responses (200 or 201 status)
      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      }

      // Handle errors (non-200 responses)
      var errorResponse = response.body.isNotEmpty
          ? json.decode(response.body)
          : {'error': 'Unknown error occurred'};
      throw errorResponse['error'] ??
          'Failed to process request. Please try again later.';
    } catch (e) {
      throw e.toString();
    }
  }
}
