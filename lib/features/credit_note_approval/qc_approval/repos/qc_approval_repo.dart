import 'package:shreeji_dairy/features/credit_note_approval/qc_approval/models/qc_para_for_approval_dm.dart';
import 'package:shreeji_dairy/services/api_service.dart';
import 'package:shreeji_dairy/utils/helpers/secure_storage_helper.dart';

class QcApprovalRepo {
  static Future<List<QcParaForApprovalDm>> getQcParaForApproval({
    required String iCode,
  }) async {
    String? token = await SecureStorageHelper.read(
      'token',
    );

    try {
      final response = await ApiService.getRequest(
        endpoint: '/CreditNote/qcPara',
        token: token,
        queryParams: {
          'ICODE': iCode,
        },
      );

      if (response == null || response['data'] == null) {
        return [];
      }

      return (response['data'] as List<dynamic>)
          .map(
            (item) => QcParaForApprovalDm.fromJson(item),
          )
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  static Future<dynamic> approveQc({
    required int id,
    required bool qc,
    required String remark,
    required List<Map<String, dynamic>> qcPara,
  }) async {
    String? token = await SecureStorageHelper.read(
      'token',
    );

    final Map<String, dynamic> requestBody = {
      "ID": id,
      "QC": qc,
      "Remark": remark,
      "QCPara": qcPara,
    };

    try {
      var response = await ApiService.postRequest(
        endpoint: '/CreditNote/qcApprove',
        requestBody: requestBody,
        token: token,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
