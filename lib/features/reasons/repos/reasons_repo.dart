import 'package:shreeji_dairy/features/reasons/models/reason_dm.dart';
import 'package:shreeji_dairy/features/reasons/models/use_in_dm.dart';
import 'package:shreeji_dairy/services/api_service.dart';
import 'package:shreeji_dairy/utils/helpers/secure_storage_helper.dart';

class ReasonsRepo {
  static Future<List<ReasonDm>> getReasons() async {
    String? token = await SecureStorageHelper.read(
      'token',
    );

    try {
      final response = await ApiService.getRequest(
        endpoint: '/Reason/data',
        token: token,
      );

      if (response == null || response['data'] == null) {
        return [];
      }

      return (response['data'] as List<dynamic>)
          .map(
            (item) => ReasonDm.fromJson(item),
          )
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<UseInDm>> getUseIn() async {
    String? token = await SecureStorageHelper.read(
      'token',
    );

    try {
      final response = await ApiService.getRequest(
        endpoint: '/Reason/useIn',
        token: token,
      );

      if (response == null || response['data'] == null) {
        return [];
      }

      return (response['data'] as List<dynamic>)
          .map(
            (item) => UseInDm.fromJson(item),
          )
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  static Future<dynamic> addReason({
    required String reason,
    required String useIn,
  }) async {
    String? token = await SecureStorageHelper.read(
      'token',
    );

    final Map<String, dynamic> requestBody = {
      'Reason': reason,
      'UseIn': useIn,
    };

    try {
      var response = await ApiService.postRequest(
        endpoint: '/Reason/add',
        requestBody: requestBody,
        token: token,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> editReason({
    required String reason,
    required String useIn,
    required String id,
  }) async {
    String? token = await SecureStorageHelper.read('token');

    try {
      final response = await ApiService.getRequest(
        endpoint: '/Reason/change',
        queryParams: {
          'ID': id,
          'Reason': reason,
          'UseIn': useIn,
        },
        token: token,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
