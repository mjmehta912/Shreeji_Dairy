import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:shreeji_dairy/features/credit_note_approval/accounting_approval/models/qc_detail_dm.dart';
import 'package:shreeji_dairy/features/credit_note_approval/accounting_approval/repos/accounting_approval_repo.dart';
import 'package:shreeji_dairy/features/credit_note_approval/dock_approval/models/item_for_approval_dm.dart';
import 'package:shreeji_dairy/features/credit_note_approval/dock_approval/repos/dock_approval_repo.dart';
import 'package:shreeji_dairy/utils/dialogs/app_dialogs.dart';

class AccountingApprovalController extends GetxController {
  var isLoading = false.obs;

  final approveAccountingFormKey = GlobalKey<FormState>();

  var itemsForApproval = <ItemForApprovalDm>[].obs;
  var qcDetails = <QcDetailDm>[].obs;
  var showQcDetails = false.obs;

  var rateController = TextEditingController();
  var remarkController = TextEditingController();

  void toggleVisibility() {
    showQcDetails.value = !showQcDetails.value;
  }

  Future<void> getItemsForApproval() async {
    try {
      isLoading.value = true;

      final fetchedItemsForApproval =
          await DockApprovalRepo.getItemsForApproval(
        status: '2',
      );

      itemsForApproval.assignAll(fetchedItemsForApproval);
    } catch (e) {
      showErrorSnackbar(
        'Error',
        e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getQcDetails({
    required String id,
  }) async {
    try {
      isLoading.value = true;

      final fetchedQcDetails = await AccountingApprovalRepo.getQcDetails(
        id: id,
      );

      qcDetails.assignAll(fetchedQcDetails);
    } catch (e) {
      showErrorSnackbar(
        'Error',
        e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> approveAccounting({
    required int id,
  }) async {
    isLoading.value = true;

    try {
      var response = await AccountingApprovalRepo.approveAccounting(
        id: id,
        rate: double.parse(rateController.text),
        remark: remarkController.text,
      );

      if (response != null && response.containsKey('message')) {
        String message = response['message'];
        Get.back();
        getItemsForApproval();
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
