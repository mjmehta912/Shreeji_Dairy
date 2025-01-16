import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreeji_dairy/features/auth/login/repositories/login_repo.dart';
import 'package:shreeji_dairy/features/select_customer/screens/select_customer_branch_screen.dart';
import 'package:shreeji_dairy/utils/dialogs/app_dialogs.dart';
import 'package:shreeji_dairy/utils/helpers/device_helper.dart';
import 'package:shreeji_dairy/utils/helpers/secure_storage_helper.dart';

class LoginController extends GetxController {
  var isLoading = false.obs;

  var obscuredText = true.obs;
  void togglePasswordVisibility() {
    obscuredText.value = !obscuredText.value;
  }

  var mobileNumberController = TextEditingController();
  var passwordController = TextEditingController();
  var hasAttemptedLogin = false.obs;
  final loginFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    setupValidationListeners();
  }

  void setupValidationListeners() {
    mobileNumberController.addListener(validateForm);
    passwordController.addListener(validateForm);
  }

  void validateForm() {
    if (hasAttemptedLogin.value) {
      loginFormKey.currentState?.validate();
    }
  }

  Future<void> loginUser() async {
    isLoading.value = true;
    String? deviceId = await DeviceHelper().getDeviceId();
    if (deviceId == null) {
      showErrorSnackbar(
        'Login Failed',
        'Unable to fetch device ID.',
      );
      isLoading.value = false;
      return;
    }

    String? fcmToken;
    if (Platform.isAndroid) {
      // Fetch FCM Token only on Android
      fcmToken = await FirebaseMessaging.instance.getToken();

      if (fcmToken == null) {
        showErrorSnackbar(
          'Login Failed',
          'Unable to fetch FCM Token.',
        );
        isLoading.value = false;
        return;
      }
    } else {
      // Pass blank token for iOS
      fcmToken = '';
    }

    try {
      var response = await LoginRepo.loginUser(
        mobileNo: mobileNumberController.text,
        password: passwordController.text,
        fcmToken: fcmToken,
        deviceId: deviceId,
      );

      await SecureStorageHelper.write(
        'token',
        response['token'],
      );
      await SecureStorageHelper.write(
        'firstName',
        response['firstName'],
      );
      await SecureStorageHelper.write(
        'lastName',
        response['lastName'],
      );
      await SecureStorageHelper.write(
        'userType',
        response['userType'].toString(),
      );
      await SecureStorageHelper.write(
        'mobileNo',
        response['mobileNo'],
      );
      await SecureStorageHelper.write(
        'userId',
        response['userId'].toString(),
      );

      await SecureStorageHelper.write(
        'ledgerStart',
        response['ledgerStart'] ?? '',
      );
      await SecureStorageHelper.write(
        'ledgerEnd',
        response['ledgerEnd'] ?? '',
      );
      await SecureStorageHelper.write(
        'storePCode',
        response['storePCode'] ?? '',
      );

      Get.offAll(
        () => SelectCustomerBranchScreen(),
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
}
