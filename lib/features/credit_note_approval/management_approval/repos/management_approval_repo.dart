import 'package:shreeji_dairy/features/credit_note_approval/accounting_approval/models/qc_detail_dm.dart';
import 'package:shreeji_dairy/services/api_service.dart';
import 'package:shreeji_dairy/utils/helpers/secure_storage_helper.dart';

class ManagementApprovalRepo {
  static Future<List<QcDetailDm>> getQcDetails({
    required String id,
  }) async {
    String? token = await SecureStorageHelper.read(
      'token',
    );

    try {
      final response = await ApiService.getRequest(
        endpoint: '/CreditNote/qcTestPara',
        token: token,
        queryParams: {
          'ID': id,
        },
      );

      if (response == null || response['data'] == null) {
        return [];
      }

      return (response['data'] as List<dynamic>)
          .map(
            (item) => QcDetailDm.fromJson(item),
          )
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  static Future<dynamic> approveManagement({
    required int id,
    required bool approve,
    required String remark,
  }) async {
    String? token = await SecureStorageHelper.read(
      'token',
    );

    final Map<String, dynamic> requestBody = {
      "ID": id,
      "Approve": approve,
      "Remark": remark,
    };

    try {
      var response = await ApiService.postRequest(
        endpoint: '/CreditNote/manageApprove',
        requestBody: requestBody,
        token: token,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
