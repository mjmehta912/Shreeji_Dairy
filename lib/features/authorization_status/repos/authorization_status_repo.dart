import 'package:shreeji_dairy/features/auth/select_customer/models/customer_dm.dart';
import 'package:shreeji_dairy/features/authorization_status/models/order_item_dm.dart';
import 'package:shreeji_dairy/services/api_service.dart';
import 'package:shreeji_dairy/utils/helpers/secure_storage_helper.dart';

class AuthorizationStatusRepo {
  static Future<List<OrderItemDm>> getOrderItems({
    String pCode = '',
    String icCodes = '',
    required String status,
    String searchText = '',
    required String fromDate,
    required String toDate,
  }) async {
    try {
      String? token = await SecureStorageHelper.read(
        'token',
      );

      Map<String, dynamic> requestBody = {
        "PCODE": pCode,
        "ICCODEs": icCodes,
        "Statuses": status,
        "SearchText": searchText,
        "FromDate": fromDate,
        "ToDate": toDate,
      };

      final response = await ApiService.postRequest(
        endpoint: '/Order/orderItems',
        requestBody: requestBody,
        token: token,
      );

      if (response['data'] != null) {
        return (response['data'] as List<dynamic>)
            .map(
              (item) => OrderItemDm.fromJson(item),
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
}
