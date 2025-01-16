import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreeji_dairy/features/bottom_nav/screens/bottom_nav_screen.dart';
import 'package:shreeji_dairy/features/select_customer/models/branch_dm.dart';
import 'package:shreeji_dairy/features/select_customer/models/customer_dm.dart';
import 'package:shreeji_dairy/features/select_customer/repositories/select_customer_branch_repo.dart';
import 'package:shreeji_dairy/utils/dialogs/app_dialogs.dart';
import 'package:shreeji_dairy/utils/helpers/secure_storage_helper.dart';

class SelectCustomerBranchController extends GetxController {
  var isLoading = false.obs;
  var customers = <CustomerDm>[].obs;
  var customerNames = <String>[].obs;
  var selectedCustomer = ''.obs;
  var selectedCustomerCode = ''.obs;
  var branches = <BranchDm>[].obs;
  var branchNames = <String>[].obs;
  var selectedBranch = ''.obs;
  var selectedBranchCode = ''.obs;
  final selectCustomerBranchFormKey = GlobalKey<FormState>();

  var firstName = ''.obs;
  var lastName = ''.obs;
  var userType = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserInfo();
    getCustomers();
    getBranches();
  }

  Future<void> loadUserInfo() async {
    try {
      firstName.value =
          await SecureStorageHelper.read('firstName') ?? 'Unknown';
      lastName.value = await SecureStorageHelper.read('lastName') ?? 'User';
      userType.value = await SecureStorageHelper.read('userType') ?? 'guest';
    } catch (e) {
      showErrorSnackbar(
        'Failed to Load User Info',
        'There was an issue loading your profile data. Please try again.',
      );
    }
  }

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

      if (userType.value == '3' || userType.value == '4') {
        if (customers.length == 1) {
          selectedCustomer.value = customers.first.pName;
          selectedCustomerCode.value = customers.first.pCode;

          Get.offAll(
            () => BottomNavScreen(
              pCode: selectedCustomerCode.value,
              pName: selectedCustomer.value,
              branchCode: selectedBranchCode.value.isNotEmpty
                  ? selectedBranchCode.value
                  : 'HO',
              branchName:
                  selectedBranch.value.isNotEmpty ? selectedBranch.value : '',
            ),
          );
        }
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

  void onCustomerSelected(String customer) {
    selectedCustomer.value = customer;

    var customerObj = customers.firstWhere(
      (cust) => cust.pName == customer,
    );

    selectedCustomerCode.value = customerObj.pCode;
  }

  Future<void> getBranches() async {
    try {
      isLoading.value = true;

      final fetchedBranches = await SelectCustomerBranchRepo.getBranches();

      branches.assignAll(fetchedBranches);
      branchNames.assignAll(
        fetchedBranches
            .map(
              (branch) => branch.gdName,
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

  void onBranchSelected(String branch) {
    selectedBranch.value = branch;

    var branchObj = branches.firstWhere(
      (bra) => bra.gdName == branch,
    );

    selectedBranchCode.value = branchObj.gdCode;
  }
}
