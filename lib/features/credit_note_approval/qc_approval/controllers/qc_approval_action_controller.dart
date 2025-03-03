import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:shreeji_dairy/features/credit_note_approval/qc_approval/controllers/qc_approval_controller.dart';
import 'package:shreeji_dairy/features/credit_note_approval/qc_approval/models/qc_para_for_approval_dm.dart';
import 'package:shreeji_dairy/features/credit_note_approval/qc_approval/repos/qc_approval_repo.dart';
import 'package:shreeji_dairy/utils/dialogs/app_dialogs.dart';

class QcApprovalActionController extends GetxController {
  var isLoading = false.obs;
  var qcParaForApproval = <QcParaForApprovalDm>[].obs;
  var selectedResults = <Map<String, dynamic>>[].obs;
  var remarkController = TextEditingController();

  Future<void> getQcParaForApproval({
    required String iCode,
  }) async {
    try {
      isLoading.value = true;
      final fetchedQcParaForApproval =
          await QcApprovalRepo.getQcParaForApproval(
        iCode: iCode,
      );
      qcParaForApproval.assignAll(fetchedQcParaForApproval);
    } catch (e) {
      showErrorSnackbar(
        'Error',
        e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  void selectTestResult(
    String tpcode,
    String testResult,
  ) {
    selectedResults.removeWhere(
      (result) => result['TPCODE'] == tpcode,
    );

    selectedResults.add(
      {
        'TPCODE': tpcode,
        'TestResult': testResult,
      },
    );
  }

  final QcApprovalController qcApprovalController =
      Get.find<QcApprovalController>();

  Future<void> approveQc({
    required int id,
    required bool qc,
  }) async {
    isLoading.value = true;

    try {
      var response = await QcApprovalRepo.approveQc(
        id: id,
        qc: qc,
        remark: remarkController.text,
        qcPara: selectedResults,
      );

      if (response != null && response.containsKey('message')) {
        String message = response['message'];
        qcApprovalController.getItemsForApproval();
        Get.back();
        showSuccessSnackbar(
          'Success',
          message,
        );
      }
    } catch (e) {
      if (e is Map<String, dynamic>) {
        showErrorSnackbar(
          'Error',
          e['message'] ?? 'An unknown error occurred.',
        );
      } else {
        showErrorSnackbar(
          'Error',
          e.toString(),
        );
      }
    } finally {
      isLoading.value = false;
    }
  }
}
