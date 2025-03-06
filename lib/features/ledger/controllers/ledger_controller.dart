import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shreeji_dairy/features/invoice/invoices/repositories/invoices_repo.dart';
import 'package:shreeji_dairy/features/invoice/invoices/screens/invoice_pdf_screen.dart';
import 'package:shreeji_dairy/features/ledger/models/ledger_dm.dart';
import 'package:shreeji_dairy/features/ledger/repositories/ledger_repo.dart';
import 'package:shreeji_dairy/features/ledger/screens/ledger_pdf_screen.dart';
import 'package:shreeji_dairy/features/auth/select_customer/models/customer_dm.dart';
import 'package:shreeji_dairy/features/auth/select_customer/repositories/select_customer_branch_repo.dart';
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

  Future<void> downloadLedger() async {
    try {
      isLoading.value = true;
      final pdfBytes = await LedgerRepo.downloadLedger(
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

      if (pdfBytes != null && pdfBytes.isNotEmpty) {
        Get.to(
          () => LedgerPdfScreen(
            pdfBytes: pdfBytes,
            title: selectedCustomerCode.value,
          ),
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

  Future<void> downloadInvoice({
    required String invNo,
    required String financialYear,
  }) async {
    try {
      isLoading.value = true;
      final pdfBytes = await InvoicesRepo.downloadInvoice(
        invNo: invNo,
        financialYear: financialYear,
      );

      if (pdfBytes != null && pdfBytes.isNotEmpty) {
        Get.to(
          () => InvoicePdfScreen(
            pdfBytes: pdfBytes,
            title: selectedCustomerCode.value,
          ),
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
