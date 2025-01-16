import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreeji_dairy/constants/color_constants.dart';
import 'package:shreeji_dairy/features/bottom_nav/screens/bottom_nav_screen.dart';
import 'package:shreeji_dairy/features/select_customer/controllers/select_customer_branch_controller.dart';
import 'package:shreeji_dairy/styles/font_sizes.dart';
import 'package:shreeji_dairy/styles/text_styles.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_paddings.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_spacings.dart';
import 'package:shreeji_dairy/widgets/app_button.dart';
import 'package:shreeji_dairy/widgets/app_dropdown.dart';
import 'package:shreeji_dairy/widgets/app_loading_overlay.dart';

class SelectCustomerBranchScreen extends StatelessWidget {
  SelectCustomerBranchScreen({
    super.key,
  });

  final SelectCustomerBranchController _controller = Get.put(
    SelectCustomerBranchController(),
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
                  key: _controller.selectCustomerBranchFormKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(
                        () => Text(
                          'Welcome, ${_controller.firstName.value}!',
                          style: TextStyles.kMediumFredoka(
                            color: kColorTextPrimary,
                            fontSize: FontSizes.k36FontSize,
                          ),
                        ),
                      ),
                      AppSpaces.v20,
                      Obx(
                        () => AppDropdown(
                          items: _controller.customerNames,
                          hintText: 'Select Customer',
                          onChanged: (value) =>
                              _controller.onCustomerSelected(value!),
                          selectedItem:
                              _controller.selectedCustomer.value.isNotEmpty
                                  ? _controller.selectedCustomer.value
                                  : null,
                          validatorText: 'Please select a customer.',
                        ),
                      ),
                      AppSpaces.v20,
                      Obx(
                        () => Visibility(
                          visible: _controller.userType.value == '0' ||
                              _controller.userType.value == '2',
                          child: AppDropdown(
                            items: _controller.branchNames,
                            hintText: 'Select Branch',
                            onChanged: (value) =>
                                _controller.onBranchSelected(value!),
                            selectedItem:
                                _controller.selectedBranch.value.isNotEmpty
                                    ? _controller.selectedBranch.value
                                    : null,
                          ),
                        ),
                      ),
                      AppSpaces.v40,
                      AppButton(
                        title: 'Let\'s shop',
                        titleColor: kColorTextPrimary,
                        buttonColor: kColorPrimary,
                        onPressed: () {
                          if (_controller
                              .selectCustomerBranchFormKey.currentState!
                              .validate()) {
                            FocusManager.instance.primaryFocus?.unfocus();
                            Get.offAll(
                              () => BottomNavScreen(
                                pCode: _controller.selectedCustomerCode.value,
                                pName: _controller.selectedCustomer.value,
                                branchCode: _controller
                                        .selectedBranchCode.value.isNotEmpty
                                    ? _controller.selectedBranchCode.value
                                    : 'HO',
                                branchName:
                                    _controller.selectedBranch.value.isNotEmpty
                                        ? _controller.selectedBranch.value
                                        : '',
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
