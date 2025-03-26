import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreeji_dairy/features/auth/select_customer/models/customer_dm.dart';
import 'package:shreeji_dairy/features/order_authorisation/models/order_dm.dart';
import 'package:shreeji_dairy/features/order_authorisation/repos/order_authorisation_repo.dart';
import 'package:shreeji_dairy/utils/dialogs/app_dialogs.dart';

class OrderAuthorisationController extends GetxController {
  var isLoading = false.obs;

  var orders = <OrderDm>[].obs;
  var customers = <CustomerDm>[].obs;
  var customerNames = <String>[].obs;
  var selectedCustomer = ''.obs;
  var selectedCustomerCode = ''.obs;
  var approvedQtyController = TextEditingController();
  var searchController = TextEditingController();

  Future<void> getOrders({
    required String pCode,
  }) async {
    isLoading.value = true;

    try {
      final fetchedOrders = await OrderAuthorisationRepo.getOrders(
        pCode: pCode,
        status: '0,2',
        searchText:
            searchController.text.isNotEmpty ? searchController.text : '',
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

  Future<void> getCustomers() async {
    try {
      isLoading.value = true;

      final fetchedCustomers = await OrderAuthorisationRepo.getCustomers();

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

  Future<void> approveOrder({
    required int status,
    required String pCode,
    required String iCode,
    required String invNo,
    required double approvedQty,
  }) async {
    isLoading.value = true;

    try {
      var response = await OrderAuthorisationRepo.approveOrder(
        status: status,
        pCode: pCode,
        iCode: iCode,
        invNo: invNo,
        approvedQty: approvedQty,
      );

      if (response != null && response.containsKey('message')) {
        String message = response['message'];

        Get.back();

        await getOrders(
          pCode: selectedCustomerCode.value,
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
}
