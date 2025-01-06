import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreeji_dairy/features/auth/forgot_password/repositories/forgot_password_repo.dart';
import 'package:shreeji_dairy/features/auth/otp/screens/otp_screen.dart';
import 'package:shreeji_dairy/utils/dialogs/app_dialogs.dart';

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

  Future<void> forgotPassword() async {
    isLoading.value = true;

    try {
      var response = await ForgotPasswordRepo.forgotPassword(
        mobileNo: mobileNumberController.text,
      );

      if (response != null && response.containsKey('message')) {
        String message = response['message'];
        Get.offAll(
          () => OtpScreen(
            mobileNumber: mobileNumberController.text,
          ),
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
