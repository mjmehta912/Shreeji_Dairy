import 'package:shreeji_dairy/services/api_service.dart';

class RegisterRepo {
  static Future<dynamic> registerUser({
    required String business,
    required String firstName,
    required String lastName,
    required String mobileNo,
    required String password,
  }) async {
    final Map<String, dynamic> requestBody = {
      'business': business,
      'firstName': firstName,
      'lastName': lastName,
      'mobileNo': mobileNo,
      'password': password,
    };

    try {
      var response = await ApiService.postRequest(
        endpoint: '/Auth/register',
        requestBody: requestBody,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
