import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreeji_dairy/features/place_order/models/slot_dm.dart';
import 'package:shreeji_dairy/features/place_order/repos/place_order_repo.dart';
import 'package:shreeji_dairy/utils/dialogs/app_dialogs.dart';

class PlaceOrderController extends GetxController {
  var isLoading = false.obs;
  final placeOrderFormKey = GlobalKey<FormState>();

  var deliveryDateController = TextEditingController();
  var slots = <SlotDm>[].obs;
  var slotTimes = <String>[].obs;
  var selectedDTime = ''.obs;
  var selectedSlotTime = ''.obs;
  var deliveryTimeController = TextEditingController();

  Future<void> getSlots() async {
    try {
      isLoading.value = true;

      final fetchedSlots = await PlaceOrderRepo.getSlots();

      slots.assignAll(fetchedSlots);
      slotTimes.assignAll(
        fetchedSlots
            .map(
              (sl) => sl.slot,
            )
            .toList(),
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

  Future<void> placeOrder({
    required String pCode,
    required String dDate,
    required String dTime,
  }) async {
    isLoading.value = true;

    try {
      var response = await PlaceOrderRepo.placeOrder(
        pCode: pCode,
        dDate: dDate,
        dTime: dTime,
      );

      if (response != null && response.containsKey('message')) {
        String message = response['message'];

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
