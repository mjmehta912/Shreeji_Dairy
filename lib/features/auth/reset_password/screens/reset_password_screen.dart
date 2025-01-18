import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreeji_dairy/constants/color_constants.dart';
import 'package:shreeji_dairy/features/auth/reset_password/controllers/reset_password_controller.dart';
import 'package:shreeji_dairy/styles/font_sizes.dart';
import 'package:shreeji_dairy/styles/text_styles.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_paddings.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_spacings.dart';
import 'package:shreeji_dairy/widgets/app_button.dart';
import 'package:shreeji_dairy/widgets/app_loading_overlay.dart';
import 'package:shreeji_dairy/widgets/app_text_form_field.dart';

class ResetPasswordScreen extends StatelessWidget {
  ResetPasswordScreen({
    super.key,
    required this.mobileNumber,
  });

  final String mobileNumber;

  final ResetPasswordController _controller = Get.put(
    ResetPasswordController(),
  );

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            backgroundColor: kColorWhite,
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
                              _controller.obscuredNewPassword.value
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
                            if (value !=
                                _controller.newPasswordController.text) {
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

                            _controller.resetPassword(
                              mobileNumber: mobileNumber,
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
        ),
        Obx(
          () => AppLoadingOverlay(
            isLoading: _controller.isLoading.value,
          ),
        ),
      ],
    );
  }
}
