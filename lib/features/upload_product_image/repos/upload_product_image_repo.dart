import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shreeji_dairy/features/credit_note/credit_note_entry/models/all_item_dm.dart';
import 'package:shreeji_dairy/services/api_service.dart';
import 'package:shreeji_dairy/utils/helpers/secure_storage_helper.dart';

class UploadProductImageRepo {
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

  static Future<dynamic> uploadProductImage({
    required String iCode,
    required File imageFile,
  }) async {
    try {
      String? token = await SecureStorageHelper.read('token');

      Map<String, String> fields = {
        'ICODE': iCode,
      };

      List<http.MultipartFile> files = [
        await http.MultipartFile.fromPath(
          'Image',
          imageFile.path,
        ),
      ];

      var response = await ApiService.postFormData(
        endpoint: '/Product/uploadImage',
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
