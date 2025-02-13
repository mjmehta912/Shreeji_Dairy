import 'package:shreeji_dairy/features/credit_note/credit_note_details/models/credit_note_detail_dm.dart';
import 'package:shreeji_dairy/services/api_service.dart';
import 'package:shreeji_dairy/utils/helpers/secure_storage_helper.dart';

class CreditNoteDetailsRepo {
  static Future<List<CreditNoteDetailDm>> getCreditNoteDetails({
    required String invNo,
  }) async {
    String? token = await SecureStorageHelper.read(
      'token',
    );

    try {
      final response = await ApiService.getRequest(
        endpoint: '/CreditNote/detail',
        queryParams: {
          'INVNo': invNo,
        },
        token: token,
      );
      if (response == null) {
        return [];
      }

      if (response['data'] != null) {
        return (response['data'] as List<dynamic>)
            .map(
              (item) => CreditNoteDetailDm.fromJson(item),
            )
            .toList();
      }

      return [];
    } catch (e) {
      rethrow;
    }
  }
}
