import 'package:shreeji_dairy/features/user_type_master/user_types/models/user_type_dm.dart';
import 'package:shreeji_dairy/services/api_service.dart';
import 'package:shreeji_dairy/utils/helpers/secure_storage_helper.dart';

class UserTypesRepo {
  static Future<List<UserTypeDm>> getUserTypes() async {
    String? token = await SecureStorageHelper.read(
      'token',
    );

    try {
      final response = await ApiService.getRequest(
        endpoint: '/userType/userType',
        token: token,
      );
      if (response == null) {
        return [];
      }

      if (response['data'] != null) {
        return (response['data'] as List<dynamic>)
            .map(
              (item) => UserTypeDm.fromJson(item),
            )
            .toList();
      }

      return [];
    } catch (e) {
      rethrow;
    }
  }
}
