import 'package:flutter/material.dart';
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
  var searchController = TextEditingController();
  var selectedStatus = ''.obs;

  List<Map<String, dynamic>> statusOptions = [
    {
      "label": "All",
      "value": "",
    },
    {
      "label": "DOCK Pending",
      "value": "0",
    },
    {
      "label": "DOCK Checked",
      "value": "1",
    },
    {
      "label": "QC Done",
      "value": "2",
    },
    {
      "label": "Passed by Accounting",
      "value": "3",
    },
    {
      "label": "Approved",
      "value": "4",
    },
  ];

  void setStatus(String value) {
    selectedStatus.value = value;
    getItemsForApproval(pCode: ''); // Fetch updated list
  }

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
        status: selectedStatus.value,
        searchText: searchController.text,
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
