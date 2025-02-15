import 'package:get/get.dart';
import 'package:shreeji_dairy/features/credit_note_approval/dock_approval/models/item_for_approval_dm.dart';
import 'package:shreeji_dairy/features/credit_note_approval/dock_approval/repos/dock_approval_repo.dart';
import 'package:shreeji_dairy/utils/dialogs/app_dialogs.dart';

class AccountingApprovalController extends GetxController {
  var isLoading = false.obs;

  var itemsForApproval = <ItemForApprovalDm>[].obs;

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
}
