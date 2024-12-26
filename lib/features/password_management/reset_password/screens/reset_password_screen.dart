import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreeji_dairy/constants/color_constants.dart';
import 'package:shreeji_dairy/features/login/screens/login_screen.dart';
import 'package:shreeji_dairy/features/password_management/reset_password/controllers/reset_password_controller.dart';
import 'package:shreeji_dairy/styles/font_sizes.dart';
import 'package:shreeji_dairy/styles/text_styles.dart';
import 'package:shreeji_dairy/utils/dialogs/app_dialogs.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_paddings.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_spacings.dart';
import 'package:shreeji_dairy/widgets/app_button.dart';
import 'package:shreeji_dairy/widgets/app_text_form_field.dart';

class ResetPasswordScreen extends StatelessWidget {
  ResetPasswordScreen({
    super.key,
  });

  final ResetPasswordController _controller = Get.put(
    ResetPasswordController(),
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Center(
          child: SingleChildScrollView(
            padding: AppPaddings.ph30,
            child: Form(
              key: _controller.resetPasswordFormKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Reset Password',
                    style: TextStyles.kMediumFredoka(
                      color: kColorTextPrimary,
                      fontSize: FontSizes.k36FontSize,
                    ),
                  ),
                  Text(
                    'Please reset your password and login again',
                    style: TextStyles.kRegularFredoka(
                      color: kColorGrey,
                      fontSize: FontSizes.k16FontSize,
                    ).copyWith(
                      height: 1.25,
                    ),
                  ),
                  AppSpaces.v20,
                  Obx(
                    () => AppTextFormField(
                      controller: _controller.newPasswordController,
                      hintText: 'New Password',
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a valid new password';
                        }
                        return null;
                      },
                      isObscure: _controller.obscuredNewPassword.value,
                      suffixIcon: IconButton(
                        onPressed: () {
                          _controller.toggleNewPasswordVisibility();
                        },
                        icon: Icon(
                          _controller.obscuredConfirmPassword.value
                              ? Icons.visibility
                              : Icons.visibility_off,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                  AppSpaces.v20,
                  Obx(
                    () => AppTextFormField(
                      controller: _controller.confirmPasswordController,
                      hintText: 'Confirm Password',
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please confirm your password';
                        }
                        if (value != _controller.newPasswordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                      isObscure: _controller.obscuredConfirmPassword.value,
                      suffixIcon: IconButton(
                        onPressed: () {
                          _controller.toggleConfirmPasswordVisibility();
                        },
                        icon: Icon(
                          _controller.obscuredConfirmPassword.value
                              ? Icons.visibility
                              : Icons.visibility_off,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                  AppSpaces.v40,
                  AppButton(
                    title: 'Reset Password',
                    titleColor: kColorTextPrimary,
                    buttonColor: kColorPrimary,
                    onPressed: () {
                      _controller.hasAttemptedSubmit.value = true;
                      if (_controller.resetPasswordFormKey.currentState!
                          .validate()) {
                        FocusManager.instance.primaryFocus?.unfocus();
                        Get.offAll(
                          () => LoginScreen(),
                          transition: Transition.fadeIn,
                          duration: Duration(
                            milliseconds: 500,
                          ),
                        );
                        showSuccessSnackbar(
                          'Password changed',
                          'Your password has been reset successfully',
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
