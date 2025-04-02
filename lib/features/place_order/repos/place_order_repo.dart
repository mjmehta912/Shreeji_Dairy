import 'package:shreeji_dairy/features/slot_master/slots/models/category_wise_slot_dm.dart';
import 'package:shreeji_dairy/services/api_service.dart';
import 'package:shreeji_dairy/utils/helpers/secure_storage_helper.dart';

class PlaceOrderRepo {
  static Future<List<CategoryWiseSlotDm>> getCategoryWiseSlots({
    required String cCode,
  }) async {
    String? token = await SecureStorageHelper.read(
      'token',
    );

    try {
      final response = await ApiService.getRequest(
        endpoint: '/Slot/slot',
        token: token,
        queryParams: {
          'CCODE': cCode,
        },
      );
      if (response == null) {
        return [];
      }

      if (response['data'] != null) {
        return (response['data'] as List<dynamic>)
            .map(
              (item) => CategoryWiseSlotDm.fromJson(item),
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
    required String deviceId,
  }) async {
    String? token = await SecureStorageHelper.read(
      'token',
    );

    final Map<String, dynamic> requestBody = {
      'PCODE': pCode,
      'DDate': dDate,
      'DTime': dTime,
      "BranchPrefix": branchPrefix,
      'DeviceId': deviceId,
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
