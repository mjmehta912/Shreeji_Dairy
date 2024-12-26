import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreeji_dairy/constants/color_constants.dart';
import 'package:shreeji_dairy/features/password_management/forgot_password/controllers/forgot_password_controller.dart';
import 'package:shreeji_dairy/features/password_management/otp/screens/otp_screen.dart';
import 'package:shreeji_dairy/styles/font_sizes.dart';
import 'package:shreeji_dairy/styles/text_styles.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_paddings.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_spacings.dart';
import 'package:shreeji_dairy/widgets/app_button.dart';
import 'package:shreeji_dairy/widgets/app_text_form_field.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({
    super.key,
  });

  final ForgotPasswordController _controller = Get.put(
    ForgotPasswordController(),
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
              key: _controller.forgotPasswordFormKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Forgot Password',
                    style: TextStyles.kMediumFredoka(
                      color: kColorTextPrimary,
                      fontSize: FontSizes.k36FontSize,
                    ),
                  ),
                  Text(
                    'Please enter your mobile number to continue',
                    style: TextStyles.kRegularFredoka(
                      color: kColorGrey,
                      fontSize: FontSizes.k16FontSize,
                    ).copyWith(
                      height: 1.25,
                    ),
                  ),
                  AppSpaces.v20,
                  AppTextFormField(
                    controller: _controller.mobileNumberController,
                    hintText: 'Mobile Number',
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your mobile number';
                      }
                      if (value.length != 10) {
                        return 'Please enter a valid mobile number';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.phone,
                  ),
                  AppSpaces.v40,
                  AppButton(
                    title: 'Get OTP',
                    titleColor: kColorTextPrimary,
                    buttonColor: kColorPrimary,
                    onPressed: () {
                      _controller.hasAttemptedSubmit.value = true;
                      if (_controller.forgotPasswordFormKey.currentState!
                          .validate()) {
                        FocusManager.instance.primaryFocus?.unfocus();
                        Get.to(
                          () => OtpScreen(),
                          transition: Transition.fadeIn,
                          duration: Duration(
                            milliseconds: 500,
                          ),
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
