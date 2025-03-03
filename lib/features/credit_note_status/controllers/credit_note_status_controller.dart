import 'package:get/get.dart';
import 'package:shreeji_dairy/features/credit_note_approval/accounting_approval/models/qc_detail_dm.dart';
import 'package:shreeji_dairy/features/credit_note_approval/dock_approval/models/item_for_approval_dm.dart';
import 'package:shreeji_dairy/features/credit_note_approval/dock_approval/repos/dock_approval_repo.dart';
import 'package:shreeji_dairy/features/credit_note_status/repos/credit_note_status_repo.dart';
import 'package:shreeji_dairy/utils/dialogs/app_dialogs.dart';

class CreditNoteStatusController extends GetxController {
  var isLoading = false.obs;

  var itemsForApproval = <ItemForApprovalDm>[].obs;
  var qcDetails = <QcDetailDm>[].obs;
  var showQcDetails = false.obs;

  void toggleVisibility() {
    showQcDetails.value = !showQcDetails.value;
  }

  Future<void> getItemsForApproval({
    required String pCode,
  }) async {
    try {
      isLoading.value = true;

      final fetchedItemsForApproval =
          await DockApprovalRepo.getItemsForApproval(
        pCode: pCode,
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

      final fetchedQcDetails = await CreditNoteStatusRepo.getQcDetails(
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
}
