import 'package:get/get.dart';
import 'package:shreeji_dairy/features/outstandings/models/outstanding_dm.dart';
import 'package:shreeji_dairy/features/outstandings/repositories/outstandings_repo.dart';
import 'package:shreeji_dairy/features/outstandings/screens/outstandings_pdf_screen.dart';
import 'package:shreeji_dairy/features/select_customer/models/customer_dm.dart';
import 'package:shreeji_dairy/features/select_customer/repositories/select_customer_repo.dart';
import 'package:shreeji_dairy/utils/dialogs/app_dialogs.dart';

class OutstandingsController extends GetxController {
  var isLoading = false.obs;

  var customers = <CustomerDm>[].obs;
  var customerNames = <String>[].obs;
  var selectedCustomer = ''.obs;
  var selectedCustomerCode = ''.obs;
  var outstandings = <OutstandingDataDm>[].obs;
  var outstandingAmount = 0.0.obs;

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

    getOutstandings(pCode: selectedCustomerCode.value);
  }

  Future<void> getOutstandings({
    required String pCode,
  }) async {
    try {
      isLoading.value = true;

      final fetchedOutstandings = await OutstandingsRepo.getOutstandings(
        pCode: pCode,
      );

      // Update both the list and the outstandingAmount
      outstandings.assignAll(fetchedOutstandings.outstandings);
      outstandingAmount.value = fetchedOutstandings.outstandingAmount;
    } catch (e) {
      showErrorSnackbar(
        'Error',
        e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> downloadOutstandings() async {
    try {
      isLoading.value = true;
      final pdfBytes = await OutstandingsRepo.downloadOutstandings(
        pCode: selectedCustomerCode.value,
      );

      if (pdfBytes != null && pdfBytes.isNotEmpty) {
        Get.to(
          () => OutstandingsPdfScreen(
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
