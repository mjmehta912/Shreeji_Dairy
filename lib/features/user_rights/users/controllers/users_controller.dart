import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreeji_dairy/features/user_rights/users/models/user_dm.dart';
import 'package:shreeji_dairy/features/user_rights/users/repositories/users_repo.dart';
import 'package:shreeji_dairy/utils/dialogs/app_dialogs.dart';

class UsersController extends GetxController {
  var isLoading = false.obs;

  var users = <UserDm>[].obs;
  var filteredUsers = <UserDm>[].obs;
  var searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    getUsers();
  }

  Future<void> getUsers() async {
    try {
      isLoading.value = true;

      final fetchedUsers = await UsersRepo.getUsers();

      users.assignAll(fetchedUsers);
      filteredUsers.assignAll(fetchedUsers);
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
    filteredUsers.assignAll(
      users.where(
        (user) {
          return user.firstName.toLowerCase().contains(
                    query.toLowerCase(),
                  ) ||
              user.lastName.toLowerCase().contains(
                    query.toLowerCase(),
                  );
        },
      ).toList(),
    );
  }

  String getUserDesignation(int userType) {
    switch (userType) {
      case 0:
        return 'Supervisor';
      case 1:
        return 'Branch Manager';
      case 2:
        return 'Salesman';
      case 3:
        return 'Franchise Owner';
      case 4:
        return 'Customer';
      default:
        return 'Unknown role';
    }
  }
}
