import 'package:shreeji_dairy/services/api_service.dart';

class ForgotPasswordRepo {
  static Future<dynamic> forgotPassword({
    required String mobileNo,
  }) async {
    try {
      final response = await ApiService.getRequest(
        endpoint: '/Auth/forgot',
        queryParams: {
          'MobileNo': mobileNo,
        },
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }
}
