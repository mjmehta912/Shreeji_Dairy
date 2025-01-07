import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreeji_dairy/features/auth/login/repositories/login_repo.dart';
import 'package:shreeji_dairy/features/select_customer/screens/select_customer_screen.dart';
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

    try {
      var response = await LoginRepo.loginUser(
        mobileNo: mobileNumberController.text,
        password: passwordController.text,
        fcmToken: '',
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

      Get.offAll(
        () => SelectCustomerScreen(),
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
