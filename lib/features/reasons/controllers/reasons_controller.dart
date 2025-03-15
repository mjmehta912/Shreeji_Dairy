import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreeji_dairy/features/reasons/models/reason_dm.dart';
import 'package:shreeji_dairy/features/reasons/models/use_in_dm.dart';
import 'package:shreeji_dairy/features/reasons/repos/reasons_repo.dart';
import 'package:shreeji_dairy/utils/dialogs/app_dialogs.dart';

class ReasonsController extends GetxController {
  var isLoading = false.obs;
  final reasonFormKey = GlobalKey<FormState>();

  var searchController = TextEditingController();
  var reasons = <ReasonDm>[].obs;
  var filteredReasons = <ReasonDm>[].obs;

  var useIn = <UseInDm>[].obs;
  var useInLabels = <String>[].obs;
  var reasonController = TextEditingController();
  var selectedUseIn = ''.obs;
  var selectedUseInLabel = ''.obs;

  @override
  void onInit() async {
    super.onInit();
    await getReasons();
    await getUseIn();
  }

  Future<void> getReasons() async {
    try {
      isLoading.value = true;
      final fetchedReasons = await ReasonsRepo.getReasons();
      reasons.assignAll(fetchedReasons);
      filteredReasons.assignAll(fetchedReasons); // Initialize filtered list
    } catch (e) {
      showErrorSnackbar(
        'Error',
        e.toString(),
      );
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

  Future<void> getUseIn() async {
    try {
      isLoading.value = true;
      final fetchedUseIn = await ReasonsRepo.getUseIn();

      useIn.assignAll(fetchedUseIn);
      useInLabels.assignAll(
        fetchedUseIn.map(
          (ui) => ui.label,
        ),
      );
    } catch (e) {
      showErrorSnackbar(
        'Error',
        e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  void onUseInSelected(String? useInLabel) {
    selectedUseInLabel.value = useInLabel!;

    final selectedUseInObj = useIn.firstWhere(
      (ui) => ui.label == useInLabel,
    );

    selectedUseIn.value = selectedUseInObj.useIn;
  }

  Future<void> addReason() async {
    isLoading.value = true;

    try {
      var response = await ReasonsRepo.addReason(
        reason: reasonController.text,
        useIn: selectedUseIn.value,
      );

      if (response != null && response.containsKey('message')) {
        String message = response['message'];
        Get.back();
        await getReasons();
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

  Future<void> editReason({
    required String id,
  }) async {
    isLoading.value = true;

    try {
      var response = await ReasonsRepo.editReason(
        id: id,
        reason: reasonController.text,
        useIn: selectedUseIn.value,
      );

      if (response.containsKey('message')) {
        String message = response['message'];
        Get.back();
        await getReasons();
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
