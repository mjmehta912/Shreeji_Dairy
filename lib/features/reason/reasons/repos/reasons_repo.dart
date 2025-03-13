import 'package:shreeji_dairy/features/reason/reasons/models/reason_dm.dart';
import 'package:shreeji_dairy/services/api_service.dart';
import 'package:shreeji_dairy/utils/helpers/secure_storage_helper.dart';

class ReasonsRepo {
  static Future<List<ReasonDm>> getReasons() async {
    String? token = await SecureStorageHelper.read(
      'token',
    );

    try {
      final response = await ApiService.getRequest(
        endpoint: '/Reason/data',
        token: token,
      );

      if (response == null || response['data'] == null) {
        return [];
      }

      return (response['data'] as List<dynamic>)
          .map(
            (item) => ReasonDm.fromJson(item),
          )
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}
