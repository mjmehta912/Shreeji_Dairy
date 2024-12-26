import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreeji_dairy/constants/color_constants.dart';
import 'package:shreeji_dairy/features/password_management/otp/controllers/otp_controller.dart';
import 'package:shreeji_dairy/styles/font_sizes.dart';
import 'package:shreeji_dairy/styles/text_styles.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_paddings.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_spacings.dart';
import 'package:shreeji_dairy/widgets/app_button.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpScreen extends StatelessWidget {
  OtpScreen({super.key});

  final OtpController _controller = Get.put(OtpController());

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
              key: _controller.otpFormKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'OTP Verification',
                    style: TextStyles.kMediumFredoka(
                      color: kColorTextPrimary,
                      fontSize: FontSizes.k36FontSize,
                    ),
                  ),
                  Text(
                    'Enter the 6-digit OTP sent to your mobile number.',
                    style: TextStyles.kRegularFredoka(
                      color: kColorGrey,
                      fontSize: FontSizes.k16FontSize,
                    ).copyWith(height: 1.25),
                  ),
                  AppSpaces.v30,
                  PinCodeTextField(
                    appContext: context,
                    length: 6,
                    controller: _controller.otpController,
                    keyboardType: TextInputType.number,
                    textStyle: TextStyles.kRegularFredoka(
                      fontSize: FontSizes.k20FontSize,
                      color: kColorTextPrimary,
                    ),
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(10),
                      fieldHeight: 50,
                      fieldWidth: 40,
                      activeFillColor: kColorLightGrey,
                      activeColor: kColorTextPrimary,
                      inactiveColor: kColorLightGrey,
                      selectedColor: kColorTextPrimary,
                    ),
                    validator: (_) => null,
                    onChanged: (value) {
                      _controller.clearError();
                    },
                  ),
                  Obx(
                    () {
                      return _controller.errorMessage.value.isNotEmpty
                          ? Padding(
                              padding: AppPaddings.pv4,
                              child: Text(
                                _controller.errorMessage.value,
                                style: TextStyles.kRegularFredoka(
                                  fontSize: FontSizes.k16FontSize,
                                  color: kColorRed,
                                ),
                              ),
                            )
                          : SizedBox.shrink();
                    },
                  ),
                  AppSpaces.v30,
                  AppButton(
                    title: 'Verify OTP',
                    titleColor: kColorTextPrimary,
                    buttonColor: kColorPrimary,
                    onPressed: () {
                      _controller.hasAttemptedSubmit.value = true;

                      if (_controller.otpController.text.length != 6) {
                        _controller.showError(
                          'Please enter a valid 6-digit OTP',
                        );
                      } else {
                        FocusManager.instance.primaryFocus?.unfocus();
                        _controller.verifyOtp();
                      }
                    },
                  ),
                  AppSpaces.v20,
                  Center(
                    child: TextButton(
                      onPressed: _controller.resendOtp,
                      child: Text(
                        'Resend OTP',
                        style: TextStyles.kRegularFredoka(
                          color: kColorSecondary,
                          fontSize: FontSizes.k16FontSize,
                        ),
                      ),
                    ),
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
