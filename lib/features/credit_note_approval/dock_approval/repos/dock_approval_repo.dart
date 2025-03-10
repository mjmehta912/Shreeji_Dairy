import 'dart:io';

import 'package:shreeji_dairy/features/credit_note_approval/dock_approval/models/item_for_approval_dm.dart';
import 'package:shreeji_dairy/services/api_service.dart';
import 'package:shreeji_dairy/utils/helpers/secure_storage_helper.dart';
import 'package:http/http.dart' as http;

class DockApprovalRepo {
  static Future<List<ItemForApprovalDm>> getItemsForApproval({
    String pCode = '',
    String status = '',
    String searchText = '',
  }) async {
    String? token = await SecureStorageHelper.read(
      'token',
    );

    try {
      final response = await ApiService.getRequest(
        endpoint: '/CreditNote/items',
        queryParams: {
          'Status': status,
          'PCODE': pCode,
          'Searchtext': searchText,
        },
        token: token,
      );
      if (response == null) {
        return [];
      }

      if (response['data'] != null) {
        return (response['data'] as List<dynamic>)
            .map(
              (item) => ItemForApprovalDm.fromJson(item),
            )
            .toList();
      }

      return [];
    } catch (e) {
      rethrow;
    }
  }

  static Future<dynamic> approveDock({
    required String id,
    required File image,
    required String remark,
    required String qty,
    required String weight,
  }) async {
    try {
      String? token = await SecureStorageHelper.read('token');

      Map<String, String> fields = {
        'ID': id,
        'Remark': remark,
        'QTY': qty,
        'Weight': weight,
      };

      List<http.MultipartFile> files = [];

      files.add(
        await http.MultipartFile.fromPath(
          'Image',
          image.path,
        ),
      );

      var response = await ApiService.postFormData(
        endpoint: '/CreditNote/docApprove',
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
