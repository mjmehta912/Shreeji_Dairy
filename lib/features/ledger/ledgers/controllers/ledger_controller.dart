import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shreeji_dairy/features/ledger/ledgers/models/ledger_dm.dart';
import 'package:shreeji_dairy/features/ledger/ledgers/repositories/ledger_repo.dart';
import 'package:shreeji_dairy/features/select_customer/models/customer_dm.dart';
import 'package:shreeji_dairy/features/select_customer/repositories/select_customer_repo.dart';
import 'package:shreeji_dairy/utils/dialogs/app_dialogs.dart';

class LedgerController extends GetxController {
  var isLoading = false.obs;

  var customers = <CustomerDm>[].obs;
  var customerNames = <String>[].obs;
  var selectedCustomer = ''.obs;
  var selectedCustomerCode = ''.obs;
  var fromDateController = TextEditingController();
  var toDateController = TextEditingController();
  var showBillDtl = false.obs;
  var showItemDtl = false.obs;
  var showSign = true.obs;

  var ledgerData = <LedgerDm>[].obs;

  Future<void> getCustomers() async {
    try {
      isLoading.value = true;

      final fetchedCustomers = await SelectCustomerRepo.getCustomers();

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

    getLedger();
  }

  Future<void> getLedger() async {
    try {
      isLoading.value = true;

      final fetchedLedger = await LedgerRepo.getLedger(
        fromDate: DateFormat('yyyy-MM-dd').format(
          DateFormat('dd-MM-yyyy').parse(fromDateController.text),
        ),
        toDate: DateFormat('yyyy-MM-dd').format(
          DateFormat('dd-MM-yyyy').parse(toDateController.text),
        ),
        pCode: selectedCustomerCode.value,
        billDtl: showBillDtl.value,
        itemDtl: showItemDtl.value,
        sign: showSign.value,
      );

      ledgerData.assignAll(fetchedLedger);
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
