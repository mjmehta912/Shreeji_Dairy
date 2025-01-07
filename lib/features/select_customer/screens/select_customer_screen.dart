import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreeji_dairy/constants/color_constants.dart';
import 'package:shreeji_dairy/features/bottom_nav/screens/bottom_nav_screen.dart';
import 'package:shreeji_dairy/features/select_customer/controllers/select_customer_controller.dart';
import 'package:shreeji_dairy/styles/font_sizes.dart';
import 'package:shreeji_dairy/styles/text_styles.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_paddings.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_spacings.dart';
import 'package:shreeji_dairy/widgets/app_button.dart';
import 'package:shreeji_dairy/widgets/app_dropdown.dart';
import 'package:shreeji_dairy/widgets/app_loading_overlay.dart';

class SelectCustomerScreen extends StatelessWidget {
  SelectCustomerScreen({
    super.key,
  });

  final SelectCustomerController _controller = Get.put(
    SelectCustomerController(),
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
            resizeToAvoidBottomInset: true,
            backgroundColor: kColorWhite,
            body: Center(
              child: SingleChildScrollView(
                padding: AppPaddings.ph30,
                child: Form(
                  key: _controller.selectCustomerFormKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Select Customer',
                        style: TextStyles.kMediumFredoka(
                          color: kColorTextPrimary,
                          fontSize: FontSizes.k36FontSize,
                        ),
                      ),
                      AppSpaces.v20,
                      AppDropdown(
                        items: _controller.customerNames,
                        hintText: 'Select Customer',
                        onChanged: (value) =>
                            _controller.onCustomerSelected(value!),
                        selectedItem:
                            _controller.selectedCustomer.value.isNotEmpty
                                ? _controller.selectedCustomer.value
                                : null,
                        validatorText: 'Please select a customer to continue.',
                      ),
                      AppSpaces.v40,
                      AppButton(
                        title: 'Let\'s shop',
                        titleColor: kColorTextPrimary,
                        buttonColor: kColorPrimary,
                        onPressed: () {
                          if (_controller.selectCustomerFormKey.currentState!
                              .validate()) {
                            FocusManager.instance.primaryFocus?.unfocus();
                            Get.offAll(
                              () => BottomNavScreen(
                                pCode: _controller.selectedCustomerCode.value,
                                pName: _controller.selectedCustomer.value,
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
