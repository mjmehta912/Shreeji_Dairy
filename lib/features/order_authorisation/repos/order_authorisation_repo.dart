import 'package:shreeji_dairy/features/auth/select_customer/models/customer_dm.dart';
import 'package:shreeji_dairy/features/order_authorisation/models/order_dm.dart';
import 'package:shreeji_dairy/services/api_service.dart';
import 'package:shreeji_dairy/utils/helpers/secure_storage_helper.dart';

class OrderAuthorisationRepo {
  static Future<List<OrderDm>> getOrders({
    String pCode = '',
    required String status,
    String searchText = '',
  }) async {
    try {
      String? token = await SecureStorageHelper.read(
        'token',
      );

      Map<String, dynamic> requestBody = {
        "PCODE": pCode,
        "Statuses": status,
        "SearchText": searchText,
      };

      final response = await ApiService.postRequest(
        endpoint: '/Order/orders',
        requestBody: requestBody,
        token: token,
      );

      if (response['data'] != null) {
        return (response['data'] as List<dynamic>)
            .map(
              (item) => OrderDm.fromJson(item),
            )
            .toList();
      }

      return [];
    } catch (e) {
      if (e is Map<String, dynamic>) {
        rethrow;
      }
      throw {
        'status': 500,
        'message': e.toString(),
      };
    }
  }

  static Future<List<CustomerDm>> getCustomers() async {
    String? token = await SecureStorageHelper.read(
      'token',
    );

    try {
      final response = await ApiService.getRequest(
        endpoint: '/Master/customer',
        token: token,
      );
      if (response == null) {
        return [];
      }

      if (response['data'] != null) {
        return (response['data'] as List<dynamic>)
            .map(
              (item) => CustomerDm.fromJson(item),
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
    required String iCode,
    required String invNo,
    required double approvedQty,
  }) async {
    String? token = await SecureStorageHelper.read(
      'token',
    );

    final Map<String, dynamic> requestBody = {
      "Status": status,
      "PCODE": pCode,
      "ICODE": iCode,
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
