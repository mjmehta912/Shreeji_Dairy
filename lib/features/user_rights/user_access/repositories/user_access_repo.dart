import 'package:shreeji_dairy/features/user_rights/user_access/models/user_access_dm.dart';
import 'package:shreeji_dairy/services/api_service.dart';
import 'package:shreeji_dairy/utils/helpers/secure_storage_helper.dart';

class UserAccessRepo {
  static Future<UserAccessDm> getUserAccess({
    required int userId,
  }) async {
    String? token = await SecureStorageHelper.read(
      'token',
    );

    try {
      final response = await ApiService.getRequest(
        endpoint: '/User/userAccess',
        queryParams: {
          'userId': userId.toString(),
        },
        token: token,
      );

      if (response == null) {
        return UserAccessDm(
          ledgerDate: [],
          menuAccess: [],
        );
      }

      return UserAccessDm.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  static Future<dynamic> setAppAccess({
    required int userId,
    required bool appAccess,
  }) async {
    String? token = await SecureStorageHelper.read(
      'token',
    );

    final Map<String, dynamic> requestBody = {
      'UserId': userId,
      'Access': appAccess,
    };

    try {
      var response = await ApiService.postRequest(
        endpoint: '/User/mobileAccess',
        requestBody: requestBody,
        token: token,
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }

  static Future<dynamic> setMenuAccess({
    required int userId,
    required int menuId,
    required bool menuAccess,
  }) async {
    String? token = await SecureStorageHelper.read(
      'token',
    );

    final Map<String, dynamic> requestBody = {
      'UserId': userId,
      'MENUID': menuId,
      'Access': menuAccess,
    };

    try {
      var response = await ApiService.postRequest(
        endpoint: '/User/setAccess',
        requestBody: requestBody,
        token: token,
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }

  static Future<dynamic> setLedger({
    required int userId,
    String? ledgerStart,
    String? ledgerEnd,
  }) async {
    String? token = await SecureStorageHelper.read(
      'token',
    );

    final Map<String, dynamic> requestBody = {
      'UserId': userId,
      'LedgerStart': ledgerStart,
      'LedgerEnd': ledgerEnd,
    };

    try {
      var response = await ApiService.postRequest(
        endpoint: '/User/setLedger',
        requestBody: requestBody,
        token: token,
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }
}
