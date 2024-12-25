import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreeji_dairy/constants/color_constants.dart';
import 'package:shreeji_dairy/extensions/app_size_extensions.dart';
import 'package:shreeji_dairy/features/login/screens/login_screen.dart';
import 'package:shreeji_dairy/features/registration/controllers/registration_controller.dart';
import 'package:shreeji_dairy/formatters/text_input_formatters.dart';
import 'package:shreeji_dairy/styles/font_sizes.dart';
import 'package:shreeji_dairy/styles/text_styles.dart';
import 'package:shreeji_dairy/utils/app_paddings.dart';
import 'package:shreeji_dairy/utils/app_spacings.dart';
import 'package:shreeji_dairy/widgets/app_button.dart';
import 'package:shreeji_dairy/widgets/app_text_form_field.dart';

class RegistrationScreen extends StatelessWidget {
  RegistrationScreen({
    super.key,
  });

  final RegistrationController _controller = Get.put(
    RegistrationController(),
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Center(
          child: SingleChildScrollView(
            padding: AppPaddings.ph30,
            child: Form(
              key: _controller.registerFormKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Register',
                    style: TextStyles.kMediumFredoka(
                      color: kColorTextPrimary,
                      fontSize: FontSizes.k36FontSize,
                    ),
                  ),
                  Text(
                    'Please create an account to continue',
                    style: TextStyles.kRegularFredoka(
                      color: kColorGrey,
                      fontSize: FontSizes.k16FontSize,
                    ).copyWith(
                      height: 1.25,
                    ),
                  ),
                  AppSpaces.v20,
                  AppTextFormField(
                    controller: _controller.businessNameController,
                    hintText: 'Business Name',
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a business name';
                      }
                      return null;
                    },
                    inputFormatters: [
                      TitleCaseTextInputFormatter(),
                    ],
                  ),
                  AppSpaces.v20,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 0.4.screenWidth,
                        child: AppTextFormField(
                          controller: _controller.firstNameController,
                          hintText: 'First Name',
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your first name';
                            }
                            return null;
                          },
                          inputFormatters: [
                            TitleCaseTextInputFormatter(),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 0.4.screenWidth,
                        child: AppTextFormField(
                          controller: _controller.lastNameController,
                          hintText: 'Last Name',
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your last name';
                            }
                            return null;
                          },
                          inputFormatters: [
                            TitleCaseTextInputFormatter(),
                          ],
                        ),
                      ),
                    ],
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
                  AppSpaces.v20,
                  Obx(
                    () => AppTextFormField(
                      controller: _controller.passwordController,
                      hintText: 'Password',
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a password';
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
                        if (value != _controller.passwordController.text) {
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
                    title: 'Register',
                    titleColor: kColorTextPrimary,
                    buttonColor: kColorPrimary,
                    onPressed: () {
                      _controller.hasAttemptedSubmit.value = true;
                      if (_controller.registerFormKey.currentState!
                          .validate()) {
                        Get.offAll(
                          () => LoginScreen(),
                          transition: Transition.fadeIn,
                          duration: const Duration(
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
