import 'package:get/get.dart';
import 'package:shreeji_dairy/features/credit_note/credit_note_details/models/credit_note_detail_dm.dart';
import 'package:shreeji_dairy/features/credit_note/credit_note_details/repos/credit_note_details_repo.dart';
import 'package:shreeji_dairy/utils/dialogs/app_dialogs.dart';

class CreditNoteDetailsController extends GetxController {
  var isLoading = false.obs;

  var creditNoteDetails = <CreditNoteDetailDm>[].obs;

  Future<void> getCreditNoteDetails({
    required String invNo,
  }) async {
    try {
      isLoading.value = true;

      final fetchedCreditNoteDetails =
          await CreditNoteDetailsRepo.getCreditNoteDetails(
        invNo: invNo,
      );

      creditNoteDetails.assignAll(fetchedCreditNoteDetails);
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
