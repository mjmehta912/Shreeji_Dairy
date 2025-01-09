import 'dart:typed_data';

import 'package:shreeji_dairy/features/outstandings/models/outstanding_dm.dart';
import 'package:shreeji_dairy/services/api_service.dart';
import 'package:shreeji_dairy/utils/helpers/secure_storage_helper.dart';

class OutstandingsRepo {
  static Future<OutstandingDm> getOutstandings({
    required String pCode,
  }) async {
    String? token = await SecureStorageHelper.read('token');

    try {
      final response = await ApiService.getRequest(
        endpoint: '/Invoice/getOutstanding',
        queryParams: {
          'PCODE': pCode,
        },
        token: token,
      );

      if (response == null) {
        return OutstandingDm(
          outstandings: [],
          outstandingAmount: 0.0,
        );
      }

      return OutstandingDm.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  static Future<Uint8List?> downloadOutstandings({
    required String pCode,
  }) async {
    try {
      String? token = await SecureStorageHelper.read('token');

      Map<String, String> queryParams = {
        'PCODE': pCode,
      };

      final response = await ApiService.postRequest(
        endpoint: '/Invoice/getOutstandingPDF',
        queryParams: queryParams,
        token: token,
        requestBody: {},
      );

      if (response is Uint8List) {
        return response;
      } else {
        throw 'Failed to generate PDF. Unexpected response format.';
      }
    } catch (e) {
      throw 'Error downloading ledger: $e';
    }
  }
}
