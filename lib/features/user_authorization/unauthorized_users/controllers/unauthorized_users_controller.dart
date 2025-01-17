import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreeji_dairy/features/user_authorization/unauthorized_users/models/unauthorized_user_dm.dart';
import 'package:shreeji_dairy/features/user_authorization/unauthorized_users/repositories/unauthorized_users_repo.dart';
import 'package:shreeji_dairy/utils/dialogs/app_dialogs.dart';

class UnauthorizedUsersController extends GetxController {
  var isLoading = false.obs;

  var unAuthorizedUsers = <UnauthorizedUserDm>[].obs;
  var filteredUnAuthorizedUsers = <UnauthorizedUserDm>[].obs;
  var searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    getUnauthorizedUsers();
  }

  Future<void> getUnauthorizedUsers() async {
    try {
      isLoading.value = true;

      final fetchedUsers = await UnauthorizedUsersRepo.getUnauthorizedUsers();

      unAuthorizedUsers.assignAll(fetchedUsers);
      filteredUnAuthorizedUsers.assignAll(fetchedUsers);
    } catch (e) {
      showErrorSnackbar(
        'Error',
        e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  void filterUsers(String query) {
    filteredUnAuthorizedUsers.assignAll(
      unAuthorizedUsers.where(
        (user) {
          return user.businessName
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              user.firstName.toLowerCase().contains(query.toLowerCase()) ||
              user.lastName.toLowerCase().contains(query.toLowerCase()) ||
              user.mobileNo.toLowerCase().contains(query.toLowerCase());
        },
      ).toList(),
    );
  }
}
