import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shreeji_dairy/constants/color_constants.dart';
import 'package:shreeji_dairy/features/auth/login/screens/login_screen.dart';
import 'package:shreeji_dairy/features/profile/repositories/profile_repo.dart';
import 'package:shreeji_dairy/features/user_rights/user_access/models/user_access_dm.dart';
import 'package:shreeji_dairy/styles/font_sizes.dart';
import 'package:shreeji_dairy/styles/text_styles.dart';
import 'package:shreeji_dairy/utils/dialogs/app_dialogs.dart';
import 'package:shreeji_dairy/utils/helpers/device_helper.dart';
import 'package:shreeji_dairy/utils/helpers/secure_storage_helper.dart';
import 'package:shreeji_dairy/utils/helpers/version_info_service.dart';

class ProfileController extends GetxController {
  var isLoading = false.obs;

  var firstName = ''.obs;
  var lastName = ''.obs;
  var userType = ''.obs;
  var mobileNumber = ''.obs;
  var menuAccess = <MenuAccessDm>[].obs;

  String getDynamicGreeting(String userType) {
    switch (userType) {
      case '0':
        return 'Hello, Visionary Leader!';
      case '1':
        return 'Greetings, Branch Chief!';
      case '2':
        return 'Welcome, Sales Pro!';
      case '3':
        return 'Hi, Business Partner!';
      case '4':
        return 'Hello, Valued Guest!';
      default:
        return 'Welcome, Esteemed User!';
    }
  }

  Future<void> loadUserInfo() async {
    try {
      firstName.value =
          await SecureStorageHelper.read('firstName') ?? 'Unknown';
      lastName.value = await SecureStorageHelper.read('lastName') ?? 'User';
      userType.value = await SecureStorageHelper.read('userType') ?? 'guest';
      mobileNumber.value = await SecureStorageHelper.read('mobileNo') ?? '';
    } catch (e) {
      showErrorSnackbar(
        'Failed to Load User Info',
        'There was an issue loading your profile data. Please try again.',
      );
    }
  }

  Future<void> logoutUser() async {
    isLoading.value = true;
    try {
      await SecureStorageHelper.clearAll();

      Get.offAll(() => LoginScreen());

      showSuccessSnackbar(
        'Logged Out',
        'You have been successfully logged out.',
      );
    } catch (e) {
      showErrorSnackbar(
        'Logout Failed',
        'Something went wrong. Please try again.',
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getUserAccess() async {
    isLoading.value = true;
    String? userId = await SecureStorageHelper.read(
      'userId',
    );

    try {
      final fetchedUserAccess = await ProfileRepo.getUserAccess(
        userId: int.parse(userId!),
      );

      menuAccess.assignAll(
        fetchedUserAccess.menuAccess,
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

  Future<void> checkVersion() async {
    isLoading.value = true;
    String? version = await VersionService.getVersion();
    String? deviceId = await DeviceHelper().getDeviceId();

    if (deviceId == null) {
      showErrorSnackbar(
        'Login Failed',
        'Unable to fetch device ID.',
      );
      isLoading.value = false;
      return;
    }

    try {
      // ignore: unused_local_variable
      final response = await ProfileRepo.checkVersion(
        deviceId: deviceId,
        version: version,
      );
    } catch (e) {
      if (e is Map<String, dynamic>) {
        if (e['status'] == 403) {
          await SecureStorageHelper.clearAll();
          Get.offAll(
            () => LoginScreen(),
          );
          showErrorSnackbar(
            'Session Expired',
            e['message'] ?? 'Unauthorized access. Device ID is invalid.',
          );
        } else if (e['status'] == 402) {
          showDialog(
            context: Get.context!,
            barrierDismissible: false,
            // ignore: deprecated_member_use
            builder: (context) => WillPopScope(
              onWillPop: () async {
                return false;
              },
              child: AlertDialog(
                title: Text(
                  e['message'],
                  style: TextStyles.kMediumFredoka(
                    fontSize: FontSizes.k18FontSize,
                    color: kColorTextPrimary,
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      SystemNavigator.pop();
                    },
                    child: Text(
                      'Close App',
                      style: TextStyles.kMediumFredoka(
                        fontSize: FontSizes.k18FontSize,
                        color: kColorSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
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
