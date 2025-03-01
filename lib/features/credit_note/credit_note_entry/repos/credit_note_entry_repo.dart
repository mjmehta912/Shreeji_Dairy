import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shreeji_dairy/features/credit_note/credit_note_entry/models/all_item_dm.dart';
import 'package:shreeji_dairy/features/credit_note/credit_note_entry/models/item_party_wise_inv_no_dm.dart';
import 'package:shreeji_dairy/services/api_service.dart';
import 'package:shreeji_dairy/utils/helpers/secure_storage_helper.dart';

class CreditNoteEntryRepo {
  static Future<List<AllItemDm>> getAllItems({
    String icCodes = '',
    String igCodes = '',
    String ipackgCodes = '',
    String searchText = '',
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
      };

      final response = await ApiService.postRequest(
        endpoint: '/Product/items',
        requestBody: requestBody,
        token: token,
      );

      if (response['data'] != null) {
        return (response['data'] as List<dynamic>)
            .map(
              (item) => AllItemDm.fromJson(item),
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
      }

      print(fields);

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
}
