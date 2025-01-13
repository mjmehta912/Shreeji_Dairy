import 'package:get/get.dart';
import 'package:shreeji_dairy/features/user_rights/user_access/models/user_access_dm.dart';
import 'package:shreeji_dairy/features/user_rights/user_access/repositories/user_access_repo.dart';
import 'package:shreeji_dairy/features/user_rights/users/controllers/users_controller.dart';
import 'package:shreeji_dairy/utils/dialogs/app_dialogs.dart';

class UserAccessController extends GetxController {
  var isLoading = false.obs;

  var menuAccess = <MenuAccessDm>[].obs;
  var ledgerDate = <LedgerDateDm>[].obs;

  Future<void> getUserAccess({
    required int userId,
  }) async {
    try {
      isLoading.value = true;

      final fetchedUserAccess = await UserAccessRepo.getUserAccess(
        userId: userId,
      );

      menuAccess.assignAll(fetchedUserAccess.menuAccess);
      ledgerDate.assignAll(fetchedUserAccess.ledgerDate);
    } catch (e) {
      showErrorSnackbar(
        'Error',
        e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  final UsersController usersController = Get.find<UsersController>();

  Future<void> setAppAccess({
    required int userId,
    required bool appAccess,
  }) async {
    isLoading.value = true;

    try {
      var response = await UserAccessRepo.setAppAccess(
        userId: userId,
        appAccess: appAccess,
      );

      if (response != null && response.containsKey('message')) {
        String message = response['message'];

        usersController.getUsers();

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
