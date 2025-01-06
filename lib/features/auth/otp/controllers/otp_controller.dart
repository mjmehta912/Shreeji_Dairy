import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreeji_dairy/features/auth/forgot_password/repositories/forgot_password_repo.dart';
import 'package:shreeji_dairy/features/auth/otp/repositories/otp_repo.dart';
import 'package:shreeji_dairy/features/auth/reset_password/screens/reset_password_screen.dart';
import 'package:shreeji_dairy/utils/dialogs/app_dialogs.dart';

class OtpController extends GetxController {
  var isLoading = false.obs;

  final TextEditingController otpController = TextEditingController();

  var hasAttemptedSubmit = false.obs;

  var resendEnabled = false.obs;
  var timerValue = 60.obs;
  Timer? _timer;

  @override
  void onInit() {
    startResendTimer();
    super.onInit();
  }

  @override
  void onClose() {
    _timer?.cancel();
    otpController.dispose();
    super.onClose();
  }

  void startResendTimer() {
    resendEnabled.value = false;
    timerValue.value = 60;

    _timer?.cancel();
    _timer = Timer.periodic(
      const Duration(
        seconds: 1,
      ),
      (timer) {
        if (timerValue.value > 0) {
          timerValue.value--;
        } else {
          resendEnabled.value = true;
          timer.cancel();
        }
      },
    );
  }

  Future<void> verifyOtp({
    required String mobileNumber,
  }) async {
    isLoading.value = true;

    try {
      var response = await OtpRepo.verifyOtp(
        mobileNumber: mobileNumber,
        otp: otpController.text,
      );

      if (response != null && response.containsKey('message')) {
        String message = response['message'];
        Get.offAll(
          () => ResetPasswordScreen(
            mobileNumber: mobileNumber,
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

  Future<void> resendOtp({
    required String mobileNumber,
  }) async {
    if (!resendEnabled.value) return;

    isLoading.value = true;
    try {
      var response = await ForgotPasswordRepo.forgotPassword(
        mobileNo: mobileNumber,
      );

      showSuccessSnackbar(
        'Success',
        response['message'] ?? 'OTP resent successfully.',
      );
      startResendTimer();
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
