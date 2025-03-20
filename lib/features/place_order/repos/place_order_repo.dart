import 'package:shreeji_dairy/features/place_order/models/slot_dm.dart';
import 'package:shreeji_dairy/services/api_service.dart';
import 'package:shreeji_dairy/utils/helpers/secure_storage_helper.dart';

class PlaceOrderRepo {
  static Future<List<SlotDm>> getSlots() async {
    String? token = await SecureStorageHelper.read(
      'token',
    );

    try {
      final response = await ApiService.getRequest(
        endpoint: '/Order/slot',
        token: token,
      );
      if (response == null) {
        return [];
      }

      if (response['data'] != null) {
        return (response['data'] as List<dynamic>)
            .map(
              (item) => SlotDm.fromJson(item),
            )
            .toList();
      }

      return [];
    } catch (e) {
      rethrow;
    }
  }

  static Future<dynamic> placeOrder({
    required String pCode,
    required String dDate,
    required String dTime,
    required String branchPrefix,
  }) async {
    String? token = await SecureStorageHelper.read(
      'token',
    );

    final Map<String, dynamic> requestBody = {
      'PCODE': pCode,
      'DDate': dDate,
      'DTime': dTime,
      "BranchPrefix": branchPrefix,
    };

    try {
      var response = await ApiService.postRequest(
        endpoint: '/Order/placeOrder',
        requestBody: requestBody,
        token: token,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
