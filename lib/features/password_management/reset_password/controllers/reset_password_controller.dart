import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
}
