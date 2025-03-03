import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:shreeji_dairy/features/credit_note_approval/accounting_approval/models/qc_detail_dm.dart';
import 'package:shreeji_dairy/features/credit_note_approval/dock_approval/models/item_for_approval_dm.dart';
import 'package:shreeji_dairy/features/credit_note_approval/dock_approval/repos/dock_approval_repo.dart';
import 'package:shreeji_dairy/features/credit_note_approval/management_approval/repos/management_approval_repo.dart';
import 'package:shreeji_dairy/utils/dialogs/app_dialogs.dart';

class ManagementApprovalController extends GetxController {
  var isLoading = false.obs;

  var itemsForApproval = <ItemForApprovalDm>[].obs;
  var qcDetails = <QcDetailDm>[].obs;
  var showQcDetails = false.obs;
  var remarkController = TextEditingController();

  void toggleVisibility() {
    showQcDetails.value = !showQcDetails.value;
  }

  @override
  void onInit() async {
    super.onInit();
    await getItemsForApproval();
  }

  Future<void> getItemsForApproval() async {
    try {
      isLoading.value = true;

      final fetchedItemsForApproval =
          await DockApprovalRepo.getItemsForApproval(
        status: '3',
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

      final fetchedQcDetails = await ManagementApprovalRepo.getQcDetails(
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

  Future<void> approveManagement({
    required int id,
    required bool approve,
  }) async {
    isLoading.value = true;

    try {
      var response = await ManagementApprovalRepo.approveManagement(
        id: id,
        approve: approve,
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
