import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreeji_dairy/constants/color_constants.dart';
import 'package:shreeji_dairy/features/select_branch/controllers/select_branch_controller.dart';
import 'package:shreeji_dairy/styles/font_sizes.dart';
import 'package:shreeji_dairy/styles/text_styles.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_paddings.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_spacings.dart';
import 'package:shreeji_dairy/widgets/app_button.dart';
import 'package:shreeji_dairy/widgets/app_dropdown.dart';

class SelectBranchScreen extends StatelessWidget {
  SelectBranchScreen({
    super.key,
  });

  final SelectBranchController _controller = Get.put(
    SelectBranchController(),
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
              key: _controller.selectBranchFormKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select Branch',
                    style: TextStyles.kMediumFredoka(
                      color: kColorTextPrimary,
                      fontSize: FontSizes.k36FontSize,
                    ),
                  ),
                  AppSpaces.v20,
                  Obx(
                    () => AppDropdown(
                      items: _controller.branches,
                      selectedItem: _controller.selectedBranch.value.isNotEmpty
                          ? _controller.selectedBranch.value
                          : null,
                      hintText: 'Select Branch',
                      searchHintText: 'Search Branch',
                      onChanged: (value) {},
                      validatorText: 'Please select a branch',
                    ),
                  ),
                  AppSpaces.v40,
                  AppButton(
                    title: 'Let\'s Go',
                    titleColor: kColorTextPrimary,
                    buttonColor: kColorPrimary,
                    onPressed: () {
                      if (_controller.selectBranchFormKey.currentState!
                          .validate()) {}
                    },
                  ),
                  AppSpaces.v10,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
