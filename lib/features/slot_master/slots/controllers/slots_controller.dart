import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreeji_dairy/features/slot_master/slots/models/category_wise_slot_dm.dart';
import 'package:shreeji_dairy/features/slot_master/slots/repos/slots_repo.dart';
import 'package:shreeji_dairy/utils/dialogs/app_dialogs.dart';

class SlotsController extends GetxController {
  var isLoading = false.obs;
  final slotFormKey = GlobalKey<FormState>();

  var slots = <CategoryWiseSlotDm>[].obs;
  var filteredSlots = <CategoryWiseSlotDm>[].obs;
  var searchController = TextEditingController();

  var slotFromController = TextEditingController();
  var slotToController = TextEditingController();

  Future<void> getCategoryWiseSlots({
    required String cCode,
  }) async {
    try {
      isLoading.value = true;

      final fetchedSlots = await SlotsRepo.getCategoryWiseSlots(
        cCode: cCode,
      );
      slots.assignAll(fetchedSlots);
      filteredSlots.assignAll(fetchedSlots);
    } catch (e) {
      showErrorSnackbar(
        'Error',
        e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  void searchSlots(String query) {
    if (query.isEmpty) {
      filteredSlots.assignAll(slots);
    } else {
      filteredSlots.assignAll(
        slots.where(
          (sl) => sl.slot.toLowerCase().contains(
                query.toLowerCase(),
              ),
        ),
      );
    }
  }

  Future<void> removeSlot({
    required String id,
    required String cCode,
  }) async {
    isLoading.value = true;

    try {
      var response = await SlotsRepo.removeSlot(
        id: id,
      );

      if (response.containsKey('message')) {
        String message = response['message'];

        await getCategoryWiseSlots(
          cCode: cCode,
        );
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

  Future<void> addSlot({
    required String cCode,
  }) async {
    isLoading.value = true;

    try {
      var response = await SlotsRepo.addSlot(
        slot: '${slotFromController.text} - ${slotToController.text}',
        dTime: slotFromController.text,
        cCode: cCode,
      );

      if (response != null && response.containsKey('message')) {
        String message = response['message'];
        Get.back();
        await getCategoryWiseSlots(
          cCode: cCode,
        );
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
