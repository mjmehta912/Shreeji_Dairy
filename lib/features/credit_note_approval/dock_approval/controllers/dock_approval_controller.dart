import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreeji_dairy/features/credit_note_approval/dock_approval/models/item_for_approval_dm.dart';
import 'package:shreeji_dairy/features/credit_note_approval/dock_approval/repos/dock_approval_repo.dart';
import 'package:shreeji_dairy/utils/dialogs/app_dialogs.dart';

class DockApprovalController extends GetxController {
  var isLoading = false.obs;
  final dockApprovalFormKey = GlobalKey<FormState>();

  var itemsForApproval = <ItemForApprovalDm>[].obs;

  var qtyController = TextEditingController();
  var weightController = TextEditingController();
  var remarkController = TextEditingController();
  var selectedImage = Rx<File?>(null);

  Future<void> getItemsForApproval() async {
    try {
      isLoading.value = true;

      final fetchedItemsForApproval =
          await DockApprovalRepo.getItemsForApproval(
        status: '0',
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

  Future<void> approveDock({
    required String id,
  }) async {
    isLoading.value = true;

    try {
      var response = await DockApprovalRepo.approveDock(
        id: id,
        qty: qtyController.text.isNotEmpty ? qtyController.text : '',
        weight: weightController.text.isNotEmpty ? weightController.text : '',
        remark: remarkController.text.isNotEmpty ? remarkController.text : '',
        image: selectedImage.value!,
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
          e['message'],
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
