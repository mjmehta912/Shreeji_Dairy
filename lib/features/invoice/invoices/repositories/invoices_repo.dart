import 'dart:typed_data';

import 'package:shreeji_dairy/features/invoice/invoices/models/invoice_dm.dart';
import 'package:shreeji_dairy/services/api_service.dart';
import 'package:shreeji_dairy/utils/helpers/secure_storage_helper.dart';

class InvoicesRepo {
  static Future<List<InvoiceDm>> getInvoices({
    required String fromDate,
    required String toDate,
    required String status,
    required String orderBy,
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
        "ORDERBY": orderBy,
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

  static Future<Uint8List?> downloadInvoice({
    required String invNo,
    required String financialYear,
  }) async {
    try {
      String? token = await SecureStorageHelper.read('token');

      Map<String, String> queryParams = {
        'INVNO': invNo,
        'FINYEAR': financialYear,
      };

      final response = await ApiService.getRequest(
        endpoint: '/Invoice/pdf',
        queryParams: queryParams,
        token: token,
      );

      if (response is Uint8List) {
        return response;
      } else {
        throw 'Failed to generate PDF. Unexpected response format.';
      }
    } catch (e) {
      throw '$e';
    }
  }
}
