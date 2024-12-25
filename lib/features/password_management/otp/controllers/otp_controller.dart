import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
      } else {
        showError(
          'Invalid OTP! Please try again',
        );
      }
    }
  }

  void resendOtp() {
    Get.snackbar(
      'OTP Sent',
      'A new OTP has been sent to your mobile number.',
      backgroundColor: Colors.blue,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void clearError() {
    errorMessage.value = '';
  }
}
