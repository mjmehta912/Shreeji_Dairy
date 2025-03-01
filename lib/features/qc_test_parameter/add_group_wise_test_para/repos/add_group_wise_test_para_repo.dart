import 'package:shreeji_dairy/features/products/models/subgroup_dm.dart';
import 'package:shreeji_dairy/features/testing_parmeter/testing_parameters/models/testing_parameter_dm.dart';
import 'package:shreeji_dairy/services/api_service.dart';
import 'package:shreeji_dairy/utils/helpers/secure_storage_helper.dart';

class AddGroupWiseTestParaRepo {
  static Future<List<SubgroupDm>> getSubGroups({
    String igCodes = '',
  }) async {
    String? token = await SecureStorageHelper.read(
      'token',
    );

    try {
      final response = await ApiService.getRequest(
        endpoint: '/Master/itemcompany',
        queryParams: {
          'IGCODES': igCodes,
        },
        token: token,
      );
      if (response == null) {
        return [];
      }

      if (response['data'] != null) {
        return (response['data'] as List<dynamic>)
            .map(
              (item) => SubgroupDm.fromJson(item),
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

  static Future<dynamic> addGroupwiseQcTestPara({
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
