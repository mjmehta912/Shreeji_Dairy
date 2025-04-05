import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreeji_dairy/features/user_type_master/user_types/models/user_type_dm.dart';
import 'package:shreeji_dairy/features/user_type_master/user_types/repos/user_types_repo.dart';
import 'package:shreeji_dairy/utils/dialogs/app_dialogs.dart';

class UserTypesController extends GetxController {
  var isLoading = false.obs;

  var userTypes = <UserTypeDm>[].obs;
  var filteredUserTypes = <UserTypeDm>[].obs;
  var searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    getUserTypes();
  }

  Future<void> getUserTypes() async {
    try {
      isLoading.value = true;

      final fetchedUserTypes = await UserTypesRepo.getUserTypes();

      userTypes.assignAll(fetchedUserTypes);
      filteredUserTypes.assignAll(fetchedUserTypes);
    } catch (e) {
      showErrorSnackbar(
        'Error',
        e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  void filterUserTypes(String query) {
    filteredUserTypes.assignAll(
      userTypes.where(
        (userType) {
          return getUserDesignation(
            userType.userType,
          ).toLowerCase().contains(
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
      case 5:
        return 'Staff';
      default:
        return 'Unknown role';
    }
  }
}
