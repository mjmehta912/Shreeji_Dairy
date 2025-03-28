import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreeji_dairy/features/order_authorisation/auth_order/models/order_detail_dm.dart';
import 'package:shreeji_dairy/features/order_authorisation/auth_order/repos/auth_order_repo.dart';
import 'package:shreeji_dairy/features/order_authorisation/orders/controllers/orders_controller.dart';
import 'package:shreeji_dairy/utils/dialogs/app_dialogs.dart';

class AuthOrderController extends GetxController {
  var isLoading = false.obs;

  var orderDetails = <OrderDetailDm>[].obs;
  var filteredOrderDetails = <OrderDetailDm>[].obs;
  var approvedQtyController = TextEditingController();
  var searchController = TextEditingController();

  var selectedItems = <String>{}.obs;
  var isSelecting = false.obs;

  Future<void> getOrderDetails({
    required String invNo,
  }) async {
    try {
      isLoading.value = true;

      final fetchedOrderDetails = await AuthOrderRepo.getOrderDetails(
        invNo: invNo,
      );

      orderDetails.assignAll(fetchedOrderDetails);
      filteredOrderDetails.assignAll(fetchedOrderDetails);
      selectedItems.clear();
      isSelecting.value = false;
    } catch (e) {
      showErrorSnackbar(
        'Error',
        e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  void searchOrderDetails(String query) {
    if (query.isEmpty) {
      filteredOrderDetails.assignAll(orderDetails);
    } else {
      filteredOrderDetails.assignAll(
        orderDetails.where(
          (orderDetail) =>
              orderDetail.iName.toLowerCase().contains(query.toLowerCase()),
        ),
      );
    }
  }

  final OrdersController ordersController = Get.find<OrdersController>();

  Future<void> approveOrder({
    required int status,
    required String pCode,
    required String iCodes,
    required String invNo,
    required double approvedQty,
  }) async {
    isLoading.value = true;

    try {
      var response = await AuthOrderRepo.approveOrder(
        status: status,
        pCode: pCode,
        iCodes: iCodes,
        invNo: invNo,
        approvedQty: approvedQty,
      );

      if (response != null && response.containsKey('message')) {
        String message = response['message'];
        getOrderDetails(
          invNo: invNo,
        );
        ordersController.getOrders(
          pCode: '',
        );
        showSuccessSnackbar(
          'Success',
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

  void toggleSelection(String iCode) {
    var orderDetail = filteredOrderDetails.firstWhere(
      (item) => item.iCode == iCode,
    );

    if (orderDetail.status != 0 && orderDetail.status != 2) {
      return;
    }

    if (selectedItems.contains(iCode)) {
      selectedItems.remove(iCode);
    } else {
      selectedItems.add(iCode);
    }

    isSelecting.value = selectedItems.isNotEmpty;
  }

  void selectAll() {
    var eligibleItems = filteredOrderDetails
        .where(
          (item) => item.status == 0 || item.status == 2,
        )
        .map(
          (item) => item.iCode,
        )
        .toSet();

    if (selectedItems.length == eligibleItems.length) {
      selectedItems.clear();
      isSelecting.value = false;
    } else {
      selectedItems.assignAll(eligibleItems);
      isSelecting.value = true;
    }
  }
}
