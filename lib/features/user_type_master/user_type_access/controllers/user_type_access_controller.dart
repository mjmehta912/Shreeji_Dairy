import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shreeji_dairy/features/profile/controllers/profile_controller.dart';
import 'package:shreeji_dairy/features/user_type_master/user_type_access/models/user_type_access_dm.dart';
import 'package:shreeji_dairy/features/user_type_master/user_type_access/repos/user_type_access_repo.dart';
import 'package:shreeji_dairy/utils/dialogs/app_dialogs.dart';

class UserTypeAccessController extends GetxController {
  var isLoading = false.obs;

  var menuAccess = <UserTypeMenuAccessDm>[].obs;
  var ledgerDate = UserTypeLedgerDateDm(
    ledgerStart: '',
    ledgerEnd: '',
    product: false,
    ledger: false,
    invoice: false,
    productDtl: '',
    invoiceDtl: '',
    ledgerDtl: '',
  ).obs;

  var ledgerStartDateController = TextEditingController();
  var ledgerEndDateController = TextEditingController();

  Future<void> getUserTypeAccess({
    required int userType,
  }) async {
    try {
      isLoading.value = true;

      final fetchedUserTypeAccess = await UserTypeAccessRepo.getUserTypeAccess(
        userType: userType,
      );

      menuAccess.assignAll(fetchedUserTypeAccess.menuAccess);
      ledgerDate.value = fetchedUserTypeAccess.ledgerDate;

      ledgerStartDateController.text =
          fetchedUserTypeAccess.ledgerDate.ledgerStart;
      ledgerEndDateController.text = fetchedUserTypeAccess.ledgerDate.ledgerEnd;
    } catch (e) {
      showErrorSnackbar(
        'Error',
        e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  final ProfileController profileController = Get.find<ProfileController>();

  Future<void> setUserTypeAppAccess({
    required int userType,
    required bool appAccess,
  }) async {
    isLoading.value = true;

    try {
      var response = await UserTypeAccessRepo.setUserTypeAppAccess(
        userType: userType,
        appAccess: appAccess,
      );

      if (response != null && response.containsKey('message')) {
        String message = response['message'];

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

  Future<void> setUserTypeMenuAccess({
    required int userType,
    required int menuId,
    int? subMenuId,
    required bool menuAccess,
  }) async {
    isLoading.value = true;

    try {
      var response = await UserTypeAccessRepo.setUserTypeMenuAccess(
        userType: userType,
        menuId: menuId,
        subMenuId: subMenuId,
        menuAccess: menuAccess,
      );

      if (response != null && response.containsKey('message')) {
        String message = response['message'];

        getUserTypeAccess(
          userType: userType,
        );
        profileController.getUserAccess();

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

  Future<void> setUserTypeLedger({
    required int userType,
    bool? product,
    bool? invoice,
    bool? ledger,
  }) async {
    isLoading.value = true;

    try {
      var response = await UserTypeAccessRepo.setUserTypeLedger(
        userType: userType,
        ledgerStart: ledgerStartDateController.text.isNotEmpty
            ? DateFormat('yyyy-MM-dd').format(
                DateFormat('dd-MM-yyyy').parse(ledgerStartDateController.text),
              )
            : null,
        ledgerEnd: ledgerEndDateController.text.isNotEmpty
            ? DateFormat('yyyy-MM-dd').format(
                DateFormat('dd-MM-yyyy').parse(ledgerEndDateController.text),
              )
            : null,
        product: product,
        invoice: invoice,
        ledger: ledger,
      );

      if (response != null && response.containsKey('message')) {
        String message = response['message'];

        getUserTypeAccess(userType: userType);
        profileController.getUserAccess();

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
