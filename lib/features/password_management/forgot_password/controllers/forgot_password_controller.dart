import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordController extends GetxController {
  var isLoading = false.obs;
  final forgotPasswordFormKey = GlobalKey<FormState>();

  var mobileNumberController = TextEditingController();

  var hasAttemptedSubmit = false.obs;

  @override
  void onInit() {
    super.onInit();
    setupValidationListeners();
  }

  void setupValidationListeners() {
    mobileNumberController.addListener(validateForm);
  }

  void validateForm() {
    if (hasAttemptedSubmit.value) {
      forgotPasswordFormKey.currentState?.validate();
    }
  }
}
