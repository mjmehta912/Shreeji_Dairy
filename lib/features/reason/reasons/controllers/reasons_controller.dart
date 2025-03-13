import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreeji_dairy/features/reason/reasons/models/reason_dm.dart';
import 'package:shreeji_dairy/features/reason/reasons/repos/reasons_repo.dart';
import 'package:shreeji_dairy/utils/dialogs/app_dialogs.dart';

class ReasonsController extends GetxController {
  var isLoading = false.obs;
  var reasons = <ReasonDm>[].obs;
  var filteredReasons = <ReasonDm>[].obs;
  var searchController = TextEditingController();

  @override
  void onInit() async {
    super.onInit();
    await getReasons();
  }

  Future<void> getReasons() async {
    try {
      isLoading.value = true;
      final fetchedReasons = await ReasonsRepo.getReasons();
      reasons.assignAll(fetchedReasons);
      filteredReasons.assignAll(fetchedReasons); // Initialize filtered list
    } catch (e) {
      showErrorSnackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void searchReasons(String query) {
    if (query.isEmpty) {
      filteredReasons.assignAll(reasons);
    } else {
      filteredReasons.assignAll(
        reasons.where(
          (reason) =>
              reason.rName.toLowerCase().contains(query.toLowerCase()) ||
              reason.label.toLowerCase().contains(query.toLowerCase()),
        ),
      );
    }
  }
}
