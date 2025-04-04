import 'package:shreeji_dairy/features/products/models/group_dm.dart';
import 'package:shreeji_dairy/features/products/models/product_dm.dart';
import 'package:shreeji_dairy/features/products/models/subgroup2_dm.dart';
import 'package:shreeji_dairy/features/products/models/subgroup_dm.dart';
import 'package:shreeji_dairy/services/api_service.dart';
import 'package:shreeji_dairy/utils/helpers/secure_storage_helper.dart';

class ProductsRepo {
  static Future<List<ProductDm>> searchProduct({
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

  static Future<dynamic> addOrUpdateCart({
    required String pCode,
    required String iCode,
    required String oldICode,
    required double qty,
    required double rate,
  }) async {
    String? token = await SecureStorageHelper.read(
      'token',
    );

    final Map<String, dynamic> requestBody = {
      'PCODE': pCode,
      'ICODE': iCode,
      "Old_Icode": oldICode,
      'QTY': qty,
      'Rate': rate,
    };

    try {
      var response = await ApiService.postRequest(
        endpoint: '/Order/addItem',
        requestBody: requestBody,
        token: token,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<GroupDm>> getGroups({
    required String cCode,
  }) async {
    String? token = await SecureStorageHelper.read(
      'token',
    );

    try {
      final response = await ApiService.getRequest(
        endpoint: '/Master/itemgroup',
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
              (item) => GroupDm.fromJson(item),
            )
            .toList();
      }

      return [];
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<SubgroupDm>> getSubGroups({
    String igCodes = '',
    required String cCode,
  }) async {
    String? token = await SecureStorageHelper.read(
      'token',
    );

    try {
      final response = await ApiService.getRequest(
        endpoint: '/Master/itemcompany',
        queryParams: {
          'IGCODES': igCodes,
          'CCODE': cCode,
        },
        token: token,
      );
      if (response == null) {
        return [];
      }

      if (response['data'] != null) {
        return (response['data'] as List<dynamic>)
            .map(
              (item) => SubgroupDm.fromJson(item),
            )
            .toList();
      }

      return [];
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<Subgroup2Dm>> getSubGroups2({
    String igCodes = '',
    String icCodes = '',
    required String cCode,
  }) async {
    String? token = await SecureStorageHelper.read(
      'token',
    );

    try {
      final response = await ApiService.getRequest(
        endpoint: '/Master/itempackgroup',
        queryParams: {
          'IGCODES': igCodes,
          'ICCODES': icCodes,
          'CCODE': cCode,
        },
        token: token,
      );
      if (response == null) {
        return [];
      }

      if (response['data'] != null) {
        return (response['data'] as List<dynamic>)
            .map(
              (item) => Subgroup2Dm.fromJson(item),
            )
            .toList();
      }

      return [];
    } catch (e) {
      rethrow;
    }
  }
}
