import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreeji_dairy/features/order_authorisation/auth_order/models/order_detail_dm.dart';
import 'package:shreeji_dairy/features/order_status/order_status_detail/repos/order_status_detail_repo.dart';
import 'package:shreeji_dairy/utils/dialogs/app_dialogs.dart';

enum OrderFilterType {
  all,
  pending,
  delivered,
}

class OrderStatusDetailController extends GetxController {
  var isLoading = false.obs;
  var orderDetails = <OrderDetailDm>[].obs;
  var filteredOrderDetails = <OrderDetailDm>[].obs;
  var searchController = TextEditingController();

  var selectedFilter = OrderFilterType.all.obs;

  Future<void> getOrderDetails({
    required String invNo,
  }) async {
    try {
      isLoading.value = true;

      final fetchedOrderDetails = await OrderStatusDetailRepo.getOrderDetails(
        invNo: invNo,
      );

      orderDetails.assignAll(fetchedOrderDetails);
      applyFilters(); // Initial filtering
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
    applyFilters(query: query);
  }

  void changeFilter(OrderFilterType type) {
    selectedFilter.value = type;
    applyFilters(query: searchController.text);
  }

  void applyFilters({String query = ''}) {
    final lowerQuery = query.toLowerCase();

    filteredOrderDetails.assignAll(
      orderDetails.where((orderDetail) {
        final matchesSearch =
            orderDetail.iName.toLowerCase().contains(lowerQuery);

        final matchesStatus = selectedFilter.value == OrderFilterType.all ||
            (selectedFilter.value == OrderFilterType.pending &&
                orderDetail.orderStatus.toLowerCase() == 'pending') ||
            (selectedFilter.value == OrderFilterType.delivered &&
                orderDetail.orderStatus.toLowerCase() == 'delivered');

        return matchesSearch && matchesStatus;
      }),
    );
  }
}
