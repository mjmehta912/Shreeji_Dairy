import 'package:shreeji_dairy/features/order_authorisation/auth_order/models/order_detail_dm.dart';
import 'package:shreeji_dairy/services/api_service.dart';
import 'package:shreeji_dairy/utils/helpers/secure_storage_helper.dart';

class AuthOrderRepo {
  static Future<List<OrderDetailDm>> getOrderDetails({
    required String invNo,
  }) async {
    String? token = await SecureStorageHelper.read(
      'token',
    );

    try {
      final response = await ApiService.getRequest(
        endpoint: '/Order/orderDtl',
        token: token,
        queryParams: {
          'INVNO': invNo,
        },
      );
      if (response == null) {
        return [];
      }

      if (response['data'] != null) {
        return (response['data'] as List<dynamic>)
            .map(
              (item) => OrderDetailDm.fromJson(item),
            )
            .toList();
      }

      return [];
    } catch (e) {
      rethrow;
    }
  }

  static Future<dynamic> approveOrder({
    required int status,
    required String pCode,
    required String iCodes,
    required String invNo,
    required double approvedQty,
  }) async {
    String? token = await SecureStorageHelper.read(
      'token',
    );

    final Map<String, dynamic> requestBody = {
      "Status": status,
      "PCODE": pCode,
      "ICODEs": iCodes,
      "INVNO": invNo,
      "QTY": approvedQty,
    };

    try {
      var response = await ApiService.postRequest(
        endpoint: '/Order/approval',
        requestBody: requestBody,
        token: token,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
