import 'package:shreeji_dairy/features/qc_test_parameter/add_item_wise_test_para/models/item_for_test_para_dm.dart';
import 'package:shreeji_dairy/features/testing_parmeter/testing_parameters/models/testing_parameter_dm.dart';
import 'package:shreeji_dairy/services/api_service.dart';
import 'package:shreeji_dairy/utils/helpers/secure_storage_helper.dart';

class AddItemWiseTestParaRepo {
  static Future<List<ItemForTestParaDm>> getItems() async {
    String? token = await SecureStorageHelper.read(
      'token',
    );

    try {
      final response = await ApiService.getRequest(
        endpoint: '/Master/items',
        token: token,
      );
      if (response == null) {
        return [];
      }

      if (response['data'] != null) {
        return (response['data'] as List<dynamic>)
            .map(
              (item) => ItemForTestParaDm.fromJson(item),
            )
            .toList();
      }

      return [];
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<TestingParameterDm>> getTestingParameters() async {
    String? token = await SecureStorageHelper.read(
      'token',
    );

    try {
      final response = await ApiService.getRequest(
        endpoint: '/QCTest/testPara',
        token: token,
      );

      if (response == null || response['data'] == null) {
        return [];
      }

      return (response['data'] as List<dynamic>)
          .map(
            (item) => TestingParameterDm.fromJson(item),
          )
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  static Future<dynamic> addItemwiseQcTestPara({
    required List<Map<String, dynamic>> data,
  }) async {
    String? token = await SecureStorageHelper.read(
      'token',
    );

    final Map<String, dynamic> requestBody = {
      'data': data,
    };

    try {
      var response = await ApiService.postRequest(
        endpoint: '/QCTest/addQCTest',
        requestBody: requestBody,
        token: token,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
