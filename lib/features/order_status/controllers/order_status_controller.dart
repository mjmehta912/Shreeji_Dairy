import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreeji_dairy/features/auth/select_customer/models/customer_dm.dart';
import 'package:shreeji_dairy/features/order_authorisation/models/order_dm.dart';
import 'package:shreeji_dairy/features/order_status/repos/order_status_repo.dart';
import 'package:shreeji_dairy/utils/dialogs/app_dialogs.dart';

class OrderStatusController extends GetxController {
  var isLoading = false.obs;

  var orders = <OrderDm>[].obs;
  var customers = <CustomerDm>[].obs;
  var customerNames = <String>[].obs;
  var selectedCustomer = ''.obs;
  var selectedCustomerCode = ''.obs;

  var searchController = TextEditingController();
  var selectedStatus = ''.obs;
  final statusOptions = [
    {
      'label': 'All',
      'value': '',
    },
    {
      'label': 'Pending',
      'value': '0',
    },
    {
      'label': 'Approved',
      'value': '1',
    },
    {
      'label': 'Hold',
      'value': '2',
    },
    {
      'label': 'Rejected',
      'value': '3',
    },
  ];

  Future<void> getOrders({
    required String pCode,
  }) async {
    isLoading.value = true;

    try {
      final fetchedOrders = await OrderStatusRepo.getOrders(
        pCode: pCode,
        icCodes: '',
        status: selectedStatus.value,
        searchText: searchController.text,
      );

      orders.assignAll(fetchedOrders);
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

  void onStatusSelected(String status) async {
    selectedStatus.value = status;
    await getOrders(pCode: selectedCustomerCode.value);
  }

  Future<void> getCustomers() async {
    try {
      isLoading.value = true;

      final fetchedCustomers = await OrderStatusRepo.getCustomers();

      customers.assignAll(fetchedCustomers);
      customerNames.assignAll(
        fetchedCustomers
            .map(
              (customer) => customer.pName,
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

  void onCustomerSelected(String? customer) async {
    selectedCustomer.value = customer!;

    var customerObj = customers.firstWhere(
      (cust) => cust.pName == customer,
    );

    selectedCustomerCode.value = customerObj.pCode;

    await getOrders(
      pCode: selectedCustomerCode.value,
    );
  }
}
