import 'package:shreeji_dairy/features/select_customer/models/customer_dm.dart';
import 'package:shreeji_dairy/features/user_authorization/authorize_user/models/salesman_dm.dart';
import 'package:shreeji_dairy/services/api_service.dart';
import 'package:shreeji_dairy/utils/helpers/secure_storage_helper.dart';

class ManageUserRepo {
  static Future<List<CustomerDm>> getCustomers() async {
    String? token = await SecureStorageHelper.read(
      'token',
    );

    try {
      final response = await ApiService.getRequest(
        endpoint: '/Master/customer',
        token: token,
      );
      if (response == null) {
        return [];
      }

      if (response['data'] != null) {
        return (response['data'] as List<dynamic>)
            .map(
              (item) => CustomerDm.fromJson(item),
            )
            .toList();
      }

      return [];
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<SalesmanDm>> getSalesmen() async {
    String? token = await SecureStorageHelper.read(
      'token',
    );

    try {
      final response = await ApiService.getRequest(
        endpoint: '/Master/salesmen',
        token: token,
      );
      if (response == null) {
        return [];
      }

      if (response['data'] != null) {
        return (response['data'] as List<dynamic>)
            .map(
              (item) => SalesmanDm.fromJson(item),
            )
            .toList();
      }

      return [];
    } catch (e) {
      rethrow;
    }
  }

  static Future<dynamic> manageUser({
    required int userId,
    required String firstName,
    required String lastName,
    required String mobileNo,
    required String password,
    required int userType,
    required String pCodes,
    required String seCode,
    required String storePCode,
  }) async {
    String? token = await SecureStorageHelper.read('token');

    final Map<String, dynamic> requestBody = {
      "userId": userId,
      "firstName": firstName,
      "lastName": lastName,
      "mobileNo": mobileNo,
      "password": password,
      "userType": userType,
      "PCODEs": pCodes,
      "SECODEs": seCode,
      "StorePCode": storePCode,
    };

    try {
      var response = await ApiService.postRequest(
        endpoint: '/User/manageUser',
        requestBody: requestBody,
        token: token,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
