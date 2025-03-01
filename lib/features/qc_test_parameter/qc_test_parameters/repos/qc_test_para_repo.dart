import 'package:shreeji_dairy/features/qc_test_parameter/qc_test_parameters/models/group_wise_qc_test_para_dm.dart';
import 'package:shreeji_dairy/features/qc_test_parameter/qc_test_parameters/models/item_wise_qc_test_para_dm.dart';
import 'package:shreeji_dairy/services/api_service.dart';
import 'package:shreeji_dairy/utils/helpers/secure_storage_helper.dart';

class QcTestParaRepo {
  static Future<List<GroupWiseQcTestParaDm>>
      getGroupwiseQcTestingParameters() async {
    String? token = await SecureStorageHelper.read(
      'token',
    );

    try {
      final response = await ApiService.getRequest(
        endpoint: '/QCTest/testGroup',
        token: token,
      );

      if (response == null || response['data'] == null) {
        return [];
      }

      return (response['data'] as List<dynamic>)
          .map(
            (item) => GroupWiseQcTestParaDm.fromJson(item),
          )
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<ItemWiseQcTestParaDm>>
      getItemwiseQcTestingParameters() async {
    String? token = await SecureStorageHelper.read(
      'token',
    );

    try {
      final response = await ApiService.getRequest(
        endpoint: '/QCTest/testItem',
        token: token,
      );

      if (response == null || response['data'] == null) {
        return [];
      }

      return (response['data'] as List<dynamic>)
          .map(
            (item) => ItemWiseQcTestParaDm.fromJson(item),
          )
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}
