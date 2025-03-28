import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreeji_dairy/features/slot_master/slots/models/category_wise_slot_dm.dart';
import 'package:shreeji_dairy/features/store_order/controllers/store_order_controller.dart';
import 'package:shreeji_dairy/features/store_order/repositories/place_store_order_repo.dart';
import 'package:shreeji_dairy/utils/dialogs/app_dialogs.dart';

class PlaceStoreOrderController extends GetxController {
  var isLoading = false.obs;
  final placeStoreOrderFormKey = GlobalKey<FormState>();

  var deliveryDateController = TextEditingController();
  var slots = <CategoryWiseSlotDm>[].obs;
  var slotTimes = <String>[].obs;
  var selectedDTime = ''.obs;
  var selectedSlotTime = ''.obs;
  var deliveryTimeController = TextEditingController();

  Future<void> getCategoryWiseSlots({
    required String cCode,
  }) async {
    try {
      isLoading.value = true;

      final fetchedSlots = await PlaceStoreOrderRepo.getCategoryWiseSlots(
        cCode: cCode,
      );
      slots.assignAll(fetchedSlots);
      slotTimes.assignAll(
        fetchedSlots.map(
          (sl) => sl.slot,
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

  void onSlotSelected(String? slotTime) {
    selectedSlotTime.value = slotTime!;

    var selectedSlotObj = slots.firstWhere(
      (sl) => sl.slot == slotTime,
    );

    selectedDTime.value = selectedSlotObj.dTime;
  }

  final StoreOrderController storeOrderController =
      Get.find<StoreOrderController>();

  Future<void> placeOrder({
    required String pCode,
    required String dDate,
    required String dTime,
    required String branchPrefix,
  }) async {
    isLoading.value = true;

    try {
      var response = await PlaceStoreOrderRepo.placeOrder(
        pCode: pCode,
        dDate: dDate,
        dTime: dTime,
        branchPrefix: branchPrefix,
      );

      if (response != null && response.containsKey('message')) {
        String message = response['message'];

        Get.back();
        storeOrderController.fetchStoreProducts();
        showSuccessSnackbar(
          'Order Placed!',
          message,
        );
      }
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
