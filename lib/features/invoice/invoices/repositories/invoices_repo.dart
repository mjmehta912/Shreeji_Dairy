import 'package:shreeji_dairy/features/invoice/invoices/models/invoice_dm.dart';
import 'package:shreeji_dairy/services/api_service.dart';
import 'package:shreeji_dairy/utils/helpers/secure_storage_helper.dart';

class InvoicesRepo {
  static Future<List<InvoiceDm>> getInvoices({
    required String fromDate,
    required String toDate,
    required String status,
    String invNo = '',
    required String pCode,
  }) async {
    try {
      String? token = await SecureStorageHelper.read(
        'token',
      );

      Map<String, dynamic> requestBody = {
        "FromDate": fromDate,
        "ToDate": toDate,
        "Status": status,
        "INVNo": invNo,
        "PCODE": pCode,
      };

      final response = await ApiService.postRequest(
        endpoint: '/Invoice/getInvoice',
        requestBody: requestBody,
        token: token,
      );

      if (response == null) {
        return [];
      }

      if (response['data'] != null) {
        return (response['data'] as List<dynamic>)
            .map(
              (item) => InvoiceDm.fromJson(item),
            )
            .toList();
      }

      return [];
    } catch (e) {
      rethrow;
    }
  }
}
