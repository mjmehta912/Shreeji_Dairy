import 'package:shreeji_dairy/features/user_rights/user_access/models/user_access_dm.dart';
import 'package:shreeji_dairy/services/api_service.dart';
import 'package:shreeji_dairy/utils/helpers/secure_storage_helper.dart';

class BottomNavRepo {
  static Future<UserAccessDm> getUserAccess({
    required int userId,
  }) async {
    String? token = await SecureStorageHelper.read('token');

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
          menuAccess: [],
          ledgerDate: LedgerDateDm(
            ledgerStart: '',
            ledgerEnd: '',
            product: false,
            invoice: false,
            ledger: false,
          ),
        );
      }

      return UserAccessDm.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }
}
