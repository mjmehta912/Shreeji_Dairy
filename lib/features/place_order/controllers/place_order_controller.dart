import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreeji_dairy/features/cart/controllers/cart_controller.dart';
import 'package:shreeji_dairy/features/place_order/repos/place_order_repo.dart';
import 'package:shreeji_dairy/features/products/controllers/products_controller.dart';
import 'package:shreeji_dairy/features/slot_master/slots/models/category_wise_slot_dm.dart';
import 'package:shreeji_dairy/utils/dialogs/app_dialogs.dart';
import 'package:shreeji_dairy/utils/helpers/device_helper.dart';

class PlaceOrderController extends GetxController {
  var isLoading = false.obs;
  final placeOrderFormKey = GlobalKey<FormState>();

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

      final fetchedSlots = await PlaceOrderRepo.getCategoryWiseSlots(
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

  final CartController cartController = Get.find<CartController>();
  final ProductsController productsController = Get.find<ProductsController>();

  Future<void> placeOrder({
    required String pCode,
    required String dDate,
    required String dTime,
    required String branchPrefix,
  }) async {
    isLoading.value = true;

    String? deviceId = await DeviceHelper().getDeviceId();
    if (deviceId == null) {
      showErrorSnackbar(
        'Login Failed',
        'Unable to fetch device ID.',
      );
      isLoading.value = false;
      return;
    }
    try {
      var response = await PlaceOrderRepo.placeOrder(
        pCode: pCode,
        dDate: dDate,
        dTime: dTime,
        branchPrefix: branchPrefix,
        deviceId: deviceId,
      );

      if (response != null && response.containsKey('message')) {
        String message = response['message'];

        Get.back();

        cartController.getCartProducts(
          pCode: pCode,
        );

        productsController.searchProduct(
          pCode: pCode,
        );

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
