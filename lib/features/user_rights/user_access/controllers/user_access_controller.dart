import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shreeji_dairy/features/profile/controllers/profile_controller.dart';
import 'package:shreeji_dairy/features/user_rights/user_access/models/user_access_dm.dart';
import 'package:shreeji_dairy/features/user_rights/user_access/repositories/user_access_repo.dart';
import 'package:shreeji_dairy/features/user_rights/users/controllers/users_controller.dart';
import 'package:shreeji_dairy/utils/dialogs/app_dialogs.dart';

class UserAccessController extends GetxController {
  var isLoading = false.obs;

  var menuAccess = <MenuAccessDm>[].obs;
  var ledgerDate = LedgerDateDm(
    ledgerStart: '',
    ledgerEnd: '',
  ).obs;

  var ledgerStartDateController = TextEditingController();
  var ledgerEndDateController = TextEditingController();

  Future<void> getUserAccess({required int userId}) async {
    try {
      isLoading.value = true;

      final fetchedUserAccess =
          await UserAccessRepo.getUserAccess(userId: userId);

      menuAccess.assignAll(fetchedUserAccess.menuAccess);
      ledgerDate.value = fetchedUserAccess.ledgerDate;

      ledgerStartDateController.text = fetchedUserAccess.ledgerDate.ledgerStart;
      ledgerEndDateController.text = fetchedUserAccess.ledgerDate.ledgerEnd;
    } catch (e) {
      showErrorSnackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  final UsersController usersController = Get.find<UsersController>();
  final ProfileController profileController = Get.find<ProfileController>();

  Future<void> setAppAccess({
    required int userId,
    required bool appAccess,
  }) async {
    isLoading.value = true;

    try {
      var response = await UserAccessRepo.setAppAccess(
          userId: userId, appAccess: appAccess);

      if (response != null && response.containsKey('message')) {
        String message = response['message'];

        usersController.getUsers();

        showSuccessSnackbar('Success', message);
      }
    } catch (e) {
      showErrorSnackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> setMenuAccess({
    required int userId,
    required int menuId,
    int? subMenuId,
    required bool menuAccess,
  }) async {
    isLoading.value = true;

    try {
      var response = await UserAccessRepo.setMenuAccess(
        userId: userId,
        menuId: menuId,
        subMenuId: subMenuId,
        menuAccess: menuAccess,
      );

      if (response != null && response.containsKey('message')) {
        String message = response['message'];

        getUserAccess(userId: userId);
        profileController.getUserAccess();

        showSuccessSnackbar('Success', message);
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

  // /// **NEW METHOD: Set SubMenu Access**
  // Future<void> setSubMenuAccess({
  //   required int userId,
  //   required int menuId,
  //   required int subMenuId,
  //   required bool subMenuAccess,
  // }) async {
  //   isLoading.value = true;

  //   try {
  //     var response = await UserAccessRepo.setSubMenuAccess(
  //       userId: userId,
  //       menuId: menuId,
  //       subMenuId: subMenuId,
  //       subMenuAccess: subMenuAccess,
  //     );

  //     if (response != null && response.containsKey('message')) {
  //       String message = response['message'];

  //       getUserAccess(userId: userId);
  //       profileController.getUserAccess();

  //       showSuccessSnackbar('Success', message);
  //     }
  //   } catch (e) {
  //     showErrorSnackbar('Error', e.toString());
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  Future<void> setLedger({required int userId}) async {
    isLoading.value = true;

    try {
      var response = await UserAccessRepo.setLedger(
        userId: userId,
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
      );

      if (response != null && response.containsKey('message')) {
        String message = response['message'];

        getUserAccess(userId: userId);
        profileController.getUserAccess();

        showSuccessSnackbar('Success', message);
      }
    } catch (e) {
      showErrorSnackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
