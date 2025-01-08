import 'package:shreeji_dairy/features/ledger/ledgers/models/ledger_dm.dart';
import 'package:shreeji_dairy/services/api_service.dart';
import 'package:shreeji_dairy/utils/helpers/secure_storage_helper.dart';

class LedgerRepo {
  static Future<List<LedgerDm>> getLedger({
    required String fromDate,
    required String toDate,
    required String pCode,
    required bool billDtl,
    required bool itemDtl,
    required bool sign,
  }) async {
    try {
      String? token = await SecureStorageHelper.read(
        'token',
      );

      Map<String, dynamic> requestBody = {
        "PCODE": pCode,
        "FromDate": fromDate,
        "ToDate": toDate,
        "BillDtl": billDtl,
        "ItemDtl": itemDtl,
        "Sign": sign,
      };

      final response = await ApiService.postRequest(
        endpoint: '/Ledger/data',
        requestBody: requestBody,
        token: token,
      );

      if (response == null) {
        return [];
      }

      if (response is List) {
        return response
            .map(
              (item) => LedgerDm.fromJson(item as Map<String, dynamic>),
            )
            .toList();
      }

      return [];
    } catch (e) {
      rethrow;
    }
  }
}
