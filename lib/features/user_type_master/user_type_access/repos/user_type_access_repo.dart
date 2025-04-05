import 'package:shreeji_dairy/features/user_type_master/user_type_access/models/user_type_access_dm.dart';
import 'package:shreeji_dairy/services/api_service.dart';
import 'package:shreeji_dairy/utils/helpers/secure_storage_helper.dart';

class UserTypeAccessRepo {
  static Future<UserTypeAccessDm> getUserTypeAccess({
    required int userType,
  }) async {
    String? token = await SecureStorageHelper.read('token');

    try {
      final response = await ApiService.getRequest(
        endpoint: '/userType/userTypeAccess',
        queryParams: {
          'userType': userType.toString(),
        },
        token: token,
      );

      if (response == null) {
        return UserTypeAccessDm(
          menuAccess: [],
          ledgerDate: UserTypeLedgerDateDm(
            ledgerStart: '',
            ledgerEnd: '',
            product: false,
            ledger: false,
            invoice: false,
            productDtl: '',
            invoiceDtl: '',
            ledgerDtl: '',
          ),
        );
      }

      return UserTypeAccessDm.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  static Future<dynamic> setUserTypeAppAccess({
    required int userType,
    required bool appAccess,
  }) async {
    String? token = await SecureStorageHelper.read(
      'token',
    );

    final Map<String, dynamic> requestBody = {
      'UserType': userType,
      'Access': appAccess,
    };

    try {
      var response = await ApiService.postRequest(
        endpoint: '/userType/mobileAccess',
        requestBody: requestBody,
        token: token,
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }

  static Future<dynamic> setUserTypeMenuAccess({
    required int userType,
    required int menuId,
    int? subMenuId,
    required bool menuAccess,
  }) async {
    String? token = await SecureStorageHelper.read(
      'token',
    );

    final Map<String, dynamic> requestBody = {
      'UserType': userType,
      'MENUID': menuId,
      'SUBMENUID': subMenuId,
      'Access': menuAccess,
    };

    try {
      var response = await ApiService.postRequest(
        endpoint: '/userType/setAccess',
        requestBody: requestBody,
        token: token,
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }

  static Future<dynamic> setUserTypeLedger({
    required int userType,
    String? ledgerStart,
    String? ledgerEnd,
    bool? product,
    bool? invoice,
    bool? ledger,
  }) async {
    String? token = await SecureStorageHelper.read(
      'token',
    );

    final Map<String, dynamic> requestBody = {
      'userType': userType,
      'LedgerStart': ledgerStart,
      'LedgerEnd': ledgerEnd,
      'Product': product,
      'Invoice': invoice,
      'Ledger': ledger,
    };

    try {
      var response = await ApiService.postRequest(
        endpoint: '/userType/setLedger',
        requestBody: requestBody,
        token: token,
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }
}
