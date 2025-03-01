import 'package:shreeji_dairy/services/api_service.dart';
import 'package:shreeji_dairy/utils/helpers/secure_storage_helper.dart';

class TestingParameterEntryRepo {
  static Future<dynamic> addTestingParameter({
    required String testPara,
    required List<Map<String, dynamic>> options,
  }) async {
    String? token = await SecureStorageHelper.read(
      'token',
    );

    final Map<String, dynamic> requestBody = {
      'TestPara': testPara,
      'Options': options,
    };

    try {
      var response = await ApiService.postRequest(
        endpoint: '/QCTest/addTestpara',
        requestBody: requestBody,
        token: token,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
