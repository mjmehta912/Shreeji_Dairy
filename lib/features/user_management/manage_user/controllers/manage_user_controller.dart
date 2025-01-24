import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreeji_dairy/features/auth/select_customer/models/customer_dm.dart';
import 'package:shreeji_dairy/features/user_authorization/authorize_user/models/salesman_dm.dart';
import 'package:shreeji_dairy/features/user_management/all_users/controllers/all_users_controller.dart';
import 'package:shreeji_dairy/features/user_management/manage_user/repositories/manage_user_repo.dart';
import 'package:shreeji_dairy/utils/dialogs/app_dialogs.dart';

class ManageUserController extends GetxController {
  var isLoading = false.obs;

  final manageUserFormKey = GlobalKey<FormState>();

  var obscuredText = true.obs;
  void togglePasswordVisibility() {
    obscuredText.value = !obscuredText.value;
  }

  var hasAttemptedSubmit = false.obs;

  void setupValidationListeners() {
    firstNameController.addListener(validateForm);
    lastNameController.addListener(validateForm);
    mobileNoController.addListener(validateForm);
    passwordController.addListener(validateForm);
  }

  void validateForm() {
    if (hasAttemptedSubmit.value) {
      manageUserFormKey.currentState?.validate();
    }
  }

  var firstNameController = TextEditingController();
  var lastNameController = TextEditingController();
  var mobileNoController = TextEditingController();
  var passwordController = TextEditingController();
  var appAccess = false.obs;

  var customers = <CustomerDm>[].obs;
  var filteredCustomers = <CustomerDm>[].obs;
  var customerNames = <String>[].obs;
  var filteredCustomerNames = <String>[].obs;

  var selectedPNames = <String>{}.obs;
  var selectedPCodes = <String>{}.obs;

  var salesmen = <SalesmanDm>[].obs;
  var salesmanNames = <String>[].obs;
  var selectedSalesman = ''.obs;
  var selectedSalesmanCode = ''.obs;

  var selectedStorePCode = ''.obs;
  var selectedStorePName = ''.obs;

  var userTypes = {
    0: 'Supervisor',
    1: 'Branch Manager',
    2: 'Salesman',
    3: 'Franchise Owner',
    4: 'Customer',
  }.obs;

  var selectedUserType = Rxn<int>();

  void onUserTypeChanged(String selectedValue) {
    final selectedIndex = userTypes.values.toList().indexOf(selectedValue);

    selectedUserType.value = selectedIndex == -1 ? null : selectedIndex;

    selectedPCodes.clear();
    selectedPNames.clear();
    selectedSalesman.value = '';
    selectedSalesmanCode.value = '';
    selectedStorePCode.value = '';
    selectedStorePName.value = '';

    if (selectedUserType.value == 1 ||
        selectedUserType.value == 3 ||
        selectedUserType.value == 4) {
      getCustomers();
    }

    if (selectedUserType.value == 2) {
      getSalesmen();
    }
  }

  Future<void> getCustomers() async {
    try {
      isLoading.value = true;

      final fetchedCustomers = await ManageUserRepo.getCustomers();

      customers.assignAll(fetchedCustomers);
      filteredCustomers.assignAll(fetchedCustomers);
      customerNames.assignAll(
        fetchedCustomers
            .map(
              (customer) => customer.pName,
            )
            .toList(),
      );

      filteredCustomerNames.assignAll(
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

  void filterCustomers(String query) {
    if (query.isEmpty) {
      filteredCustomers.assignAll(customers);
    } else {
      filteredCustomers.assignAll(
        customers.where(
          (cust) {
            return cust.pName.toLowerCase().contains(query.toLowerCase());
          },
        ).toList(),
      );
    }
  }

  Future<void> getSalesmen() async {
    try {
      isLoading.value = true;

      final fetchedSalesmen = await ManageUserRepo.getSalesmen();

      salesmen.assignAll(fetchedSalesmen);
      salesmanNames.assignAll(
        fetchedSalesmen
            .map(
              (se) => se.seName,
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

  void onSalesmanSelected(String salesman) {
    selectedSalesman.value = salesman;

    var salesMenObj = salesmen.firstWhere(
      (se) => se.seName == salesman,
    );

    selectedSalesmanCode.value = salesMenObj.seCode;
  }

  void onStoreSelected(String store) {
    selectedStorePName.value = store;

    var storeObj = customers.firstWhere(
      (st) => st.pName == store,
    );

    selectedStorePCode.value = storeObj.pCode;
  }

  final AllUsersController allUsersController = Get.find<AllUsersController>();

  Future<void> manageUser({
    required int userId,
  }) async {
    isLoading.value = true;

    try {
      var response = await ManageUserRepo.manageUser(
        userId: userId,
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        mobileNo: mobileNoController.text,
        password: passwordController.text,
        userType: selectedUserType.value!,
        pCodes: selectedPCodes.isEmpty ? '' : selectedPCodes.join(','),
        seCode: selectedSalesmanCode.value.isEmpty
            ? ''
            : selectedSalesmanCode.value,
        storePCode:
            selectedStorePCode.value.isEmpty ? '' : selectedStorePCode.value,
      );

      if (response != null && response.containsKey('message')) {
        String message = response['message'];
        await allUsersController.getUsers();
        Get.back();
        showSuccessSnackbar(
          'Success',
          message,
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
}
