import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreeji_dairy/features/password_management/reset_password/screens/reset_password_screen.dart';
import 'package:shreeji_dairy/utils/dialogs/app_dialogs.dart';

class OtpController extends GetxController {
  final TextEditingController otpController = TextEditingController();
  final GlobalKey<FormState> otpFormKey = GlobalKey<FormState>();

  var errorMessage = ''.obs;
  var hasAttemptedSubmit = false.obs;

  void showError(String message) {
    errorMessage.value = message;
    Future.delayed(
      Duration(
        seconds: 3,
      ),
      () {
        errorMessage.value = '';
      },
    );
  }

  void verifyOtp() {
    if (otpFormKey.currentState!.validate()) {
      if (otpController.text == '123456') {
        Get.to(
          () => ResetPasswordScreen(),
          transition: Transition.fadeIn,
          duration: Duration(
            milliseconds: 500,
          ),
        );
      } else {
        showError(
          'Invalid OTP! Please try again',
        );
      }
    }
  }

  void resendOtp() {
    showSuccessSnackbar(
      'OTP Sent',
      'A new OTP has been sent to your mobile number.',
    );
  }

  void clearError() {
    errorMessage.value = '';
  }
}
