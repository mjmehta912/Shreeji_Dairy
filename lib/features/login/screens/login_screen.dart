import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreeji_dairy/constants/color_constants.dart';
import 'package:shreeji_dairy/features/login/controllers/login_controller.dart';
import 'package:shreeji_dairy/features/password_management/forgot_password/screens/forgot_password_screen.dart';
import 'package:shreeji_dairy/features/registration/screens/registration_screen.dart';
import 'package:shreeji_dairy/features/select_branch/screens/select_branch_screen.dart';
import 'package:shreeji_dairy/styles/font_sizes.dart';
import 'package:shreeji_dairy/styles/text_styles.dart';
import 'package:shreeji_dairy/utils/app_paddings.dart';
import 'package:shreeji_dairy/utils/app_spacings.dart';
import 'package:shreeji_dairy/widgets/app_button.dart';
import 'package:shreeji_dairy/widgets/app_text_form_field.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({
    super.key,
  });

  final LoginController _controller = Get.put(
    LoginController(),
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
              key: _controller.loginFormKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Login',
                    style: TextStyles.kMediumFredoka(
                      color: kColorTextPrimary,
                      fontSize: FontSizes.k36FontSize,
                    ),
                  ),
                  Text(
                    'Please login to continue',
                    style: TextStyles.kRegularFredoka(
                      color: kColorGrey,
                      fontSize: FontSizes.k16FontSize,
                    ).copyWith(
                      height: 1.25,
                    ),
                  ),
                  AppSpaces.v20,
                  AppTextFormField(
                    controller: _controller.usernameController,
                    hintText: 'Username',
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a username';
                      }
                      return null;
                    },
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
                      isObscure: _controller.obscuredText.value,
                      suffixIcon: IconButton(
                        onPressed: () {
                          _controller.togglePasswordVisibility();
                        },
                        icon: Icon(
                          _controller.obscuredText.value
                              ? Icons.visibility
                              : Icons.visibility_off,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Get.to(
                            () => ForgotPasswordScreen(),
                            transition: Transition.fadeIn,
                            duration: const Duration(
                              milliseconds: 500,
                            ),
                          );
                        },
                        child: Text(
                          'Forgot Password?',
                          style: TextStyles.kRegularFredoka(
                            color: kColorSecondary,
                            fontSize: FontSizes.k16FontSize,
                          ),
                        ),
                      ),
                    ],
                  ),
                  AppSpaces.v40,
                  AppButton(
                    title: 'Login',
                    titleColor: kColorTextPrimary,
                    buttonColor: kColorPrimary,
                    onPressed: () {
                      _controller.hasAttemptedLogin.value = true;
                      if (_controller.loginFormKey.currentState!.validate()) {
                        FocusManager.instance.primaryFocus?.unfocus();
                        Get.to(
                          () => SelectBranchScreen(),
                          transition: Transition.fadeIn,
                          duration: const Duration(
                            milliseconds: 500,
                          ),
                        );
                      }
                    },
                  ),
                  AppSpaces.v10,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Don\'t have an account?',
                        style: TextStyles.kLightFredoka(
                          color: kColorTextPrimary,
                          fontSize: FontSizes.k16FontSize,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Get.to(
                            () => RegistrationScreen(),
                            transition: Transition.fadeIn,
                            duration: const Duration(
                              milliseconds: 500,
                            ),
                          );
                        },
                        child: Text(
                          'Register',
                          style: TextStyles.kRegularFredoka(
                            color: kColorSecondary,
                            fontSize: FontSizes.k16FontSize,
                          ),
                        ),
                      ),
                    ],
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
