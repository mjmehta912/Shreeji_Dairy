import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreeji_dairy/features/auth/login/screens/login_screen.dart';
import 'package:shreeji_dairy/features/auth/reset_password/repositories/reset_password_repo.dart';
import 'package:shreeji_dairy/utils/dialogs/app_dialogs.dart';

class ResetPasswordController extends GetxController {
  var isLoading = false.obs;
  final resetPasswordFormKey = GlobalKey<FormState>();

  var obscuredNewPassword = true.obs;
  void toggleNewPasswordVisibility() {
    obscuredNewPassword.value = !obscuredNewPassword.value;
  }

  var obscuredConfirmPassword = true.obs;
  void toggleConfirmPasswordVisibility() {
    obscuredConfirmPassword.value = !obscuredConfirmPassword.value;
  }

  var hasAttemptedSubmit = false.obs;

  var newPasswordController = TextEditingController();
  var confirmPasswordController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    setupValidationListeners();
  }

  void setupValidationListeners() {
    newPasswordController.addListener(validateForm);
    confirmPasswordController.addListener(validateForm);
  }

  void validateForm() {
    if (hasAttemptedSubmit.value) {
      resetPasswordFormKey.currentState?.validate();
    }
  }

  Future<void> resetPassword({
    required String mobileNumber,
  }) async {
    isLoading.value = true;

    try {
      var response = await ResetPasswordRepo.resetPassword(
        mobileNo: mobileNumber,
        password: newPasswordController.text,
      );

      if (response != null && response.containsKey('message')) {
        String message = response['message'];
        Get.offAll(
          () => LoginScreen(),
        );
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
