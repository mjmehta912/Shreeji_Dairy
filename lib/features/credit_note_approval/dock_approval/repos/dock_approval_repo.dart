import 'package:shreeji_dairy/features/credit_note_approval/dock_approval/models/item_for_approval_dm.dart';
import 'package:shreeji_dairy/services/api_service.dart';
import 'package:shreeji_dairy/utils/helpers/secure_storage_helper.dart';

class DockApprovalRepo {
  static Future<List<ItemForApprovalDm>> getItemsForApproval({
    String pCode = '',
    String status = '',
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
}
