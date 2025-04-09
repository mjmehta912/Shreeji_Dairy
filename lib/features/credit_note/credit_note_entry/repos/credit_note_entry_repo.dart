import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shreeji_dairy/features/credit_note/credit_note_entry/models/credit_note_reason_dm.dart';
import 'package:shreeji_dairy/features/credit_note/credit_note_entry/models/item_party_wise_inv_no_dm.dart';
import 'package:shreeji_dairy/features/products/models/product_dm.dart';
import 'package:shreeji_dairy/services/api_service.dart';
import 'package:shreeji_dairy/utils/helpers/secure_storage_helper.dart';

class CreditNoteEntryRepo {
  static Future<List<ItemPartyWiseInvNoDm>> getInvNos({
    required String iCode,
    required String pCode,
  }) async {
    String? token = await SecureStorageHelper.read(
      'token',
    );

    try {
      final response = await ApiService.getRequest(
        endpoint: '/CreditNote/invno',
        token: token,
        queryParams: {
          'ICODE': iCode,
          'PCODE': pCode,
        },
      );
      if (response == null) {
        return [];
      }

      if (response['data'] != null) {
        return (response['data'] as List<dynamic>)
            .map(
              (item) => ItemPartyWiseInvNoDm.fromJson(item),
            )
            .toList();
      }

      return [];
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<CreditNoteReasonDm>> getReasons() async {
    String? token = await SecureStorageHelper.read(
      'token',
    );

    try {
      final response = await ApiService.getRequest(
        endpoint: '/CreditNote/reason',
        token: token,
      );
      if (response == null) {
        return [];
      }

      if (response['data'] != null) {
        return (response['data'] as List<dynamic>)
            .map(
              (item) => CreditNoteReasonDm.fromJson(item),
            )
            .toList();
      }

      return [];
    } catch (e) {
      rethrow;
    }
  }

  static Future<dynamic> saveCreditNote({
    required String pcode,
    required String remark,
    required List<Map<String, dynamic>> details,
  }) async {
    try {
      String? token = await SecureStorageHelper.read(
        'token',
      );

      Map<String, String> fields = {
        'PCODE': pcode,
        'Remark': remark,
      };

      List<http.MultipartFile> files = [];

      for (var i = 0; i < details.length; i++) {
        var detail = details[i];
        var imageFile = detail['Image'] as File;

        files.add(
          await http.MultipartFile.fromPath(
            'Details[$i].Image',
            imageFile.path,
          ),
        );

        fields['Details[$i].SRNO'] = detail['SRNO'];
        fields['Details[$i].ICODE'] = detail['ICODE'];
        fields['Details[$i].QTY'] = detail['QTY'];
        fields['Details[$i].ExpDate'] = detail['ExpDate'];
        fields['Details[$i].INVNO'] = detail['INVNO'];
        fields['Details[$i].Reason'] = detail['Reason'];
      }

      var response = await ApiService.postFormData(
        endpoint: '/CreditNote/entry',
        fields: fields,
        files: files,
        token: token,
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<ProductDm>> getItems({
    String icCodes = '',
    String igCodes = '',
    String ipackgCodes = '',
    String searchText = '',
    String pCode = '',
    String deviceId = '',
    String version = '',
  }) async {
    try {
      String? token = await SecureStorageHelper.read(
        'token',
      );

      Map<String, dynamic> requestBody = {
        "ICCODEs": icCodes,
        "IGCODEs": igCodes,
        "IPACKGCODEs": ipackgCodes,
        "SearchText": searchText,
        "PCODE": pCode,
        "DeviceID": deviceId,
        "Version": version,
        "Suggestion": false,
      };

      final response = await ApiService.postRequest(
        endpoint: '/Product/searchProduct',
        requestBody: requestBody,
        token: token,
      );

      if (response['data'] != null) {
        return (response['data'] as List<dynamic>)
            .map(
              (item) => ProductDm.fromJson(item),
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
}
