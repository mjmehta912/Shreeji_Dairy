import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shreeji_dairy/features/invoice/invoices/models/invoice_dm.dart';
import 'package:shreeji_dairy/features/invoice/invoices/repositories/invoices_repo.dart';
import 'package:shreeji_dairy/features/select_customer/models/customer_dm.dart';
import 'package:shreeji_dairy/features/select_customer/repositories/select_customer_branch_repo.dart';
import 'package:shreeji_dairy/utils/dialogs/app_dialogs.dart';

class InvoicesController extends GetxController {
  var isLoading = false.obs;

  var customers = <CustomerDm>[].obs;
  var customerNames = <String>[].obs;
  var selectedCustomer = ''.obs;
  var selectedCustomerCode = ''.obs;
  var fromDateController = TextEditingController();
  var toDateController = TextEditingController();
  var searchController = TextEditingController();
  var selectedStatus = 'ALL'.obs;

  var invoices = <InvoiceDm>[].obs;

  Future<void> getCustomers() async {
    try {
      isLoading.value = true;

      final fetchedCustomers = await SelectCustomerBranchRepo.getCustomers();

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

  void onCustomerSelected(String customer) {
    selectedCustomer.value = customer;

    var customerObj = customers.firstWhere(
      (cust) => cust.pName == customer,
    );

    selectedCustomerCode.value = customerObj.pCode;
    getInvoices();
  }

  Future<void> getInvoices() async {
    try {
      isLoading.value = true;

      final fetchedInvoices = await InvoicesRepo.getInvoices(
        fromDate: DateFormat('yyyy-MM-dd').format(
          DateFormat('dd-MM-yyyy').parse(fromDateController.text),
        ),
        toDate: DateFormat('yyyy-MM-dd').format(
          DateFormat('dd-MM-yyyy').parse(toDateController.text),
        ),
        status: selectedStatus.value,
        invNo: searchController.text,
        pCode: selectedCustomerCode.value,
      );

      invoices.assignAll(fetchedInvoices);
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
