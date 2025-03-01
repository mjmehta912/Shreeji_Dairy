import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreeji_dairy/constants/color_constants.dart';
import 'package:shreeji_dairy/features/testing_parmeter/testing_parameter_entry/controllers/testing_parameter_entry_controller.dart';
import 'package:shreeji_dairy/styles/font_sizes.dart';
import 'package:shreeji_dairy/styles/text_styles.dart';
import 'package:shreeji_dairy/utils/dialogs/app_dialogs.dart';
import 'package:shreeji_dairy/utils/formatters/text_input_formatters.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_paddings.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_spacings.dart';
import 'package:shreeji_dairy/widgets/app_appbar.dart';
import 'package:shreeji_dairy/widgets/app_button.dart';
import 'package:shreeji_dairy/widgets/app_loading_overlay.dart';
import 'package:shreeji_dairy/widgets/app_text_form_field.dart';

class TestingParameterEntryScreen extends StatelessWidget {
  TestingParameterEntryScreen({
    super.key,
  });

  final TestingParameterEntryController _controller = Get.put(
    TestingParameterEntryController(),
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
            appBar: AppAppbar(
              title: 'Add Testing Parameter',
              leading: IconButton(
                onPressed: () => Get.back(),
                icon: Icon(
                  Icons.arrow_back_ios,
                  size: 25,
                  color: kColorTextPrimary,
                ),
              ),
            ),
            body: Padding(
              padding: AppPaddings.p10,
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Form(
                        key: _controller.testingParameterEntryFormKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppTextFormField(
                              controller: _controller.testParaController,
                              hintText: 'Testing Parameter',
                              inputFormatters: [
                                TitleCaseTextInputFormatter(),
                              ],
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a testing parameter';
                                }
                                return null;
                              },
                            ),
                            AppSpaces.v20,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: AppTextFormField(
                                    controller:
                                        _controller.testResultController,
                                    hintText: 'Add Test Result',
                                    inputFormatters: [
                                      TitleCaseTextInputFormatter(),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.add,
                                    color: kColorSecondary,
                                  ),
                                  onPressed: () {
                                    _controller.addOption(
                                        _controller.testResultController.text);
                                  },
                                ),
                              ],
                            ),
                            AppSpaces.v20,
                            Obx(
                              () => Wrap(
                                crossAxisAlignment: WrapCrossAlignment.start,
                                spacing: 10,
                                runSpacing: 10,
                                children: _controller.options
                                    .map(
                                      (option) => Chip(
                                        backgroundColor: kColorPrimary,
                                        label: Text(
                                          option["TestResult"]!,
                                          style: TextStyles.kRegularFredoka(
                                            color: kColorTextPrimary,
                                            fontSize: FontSizes.k18FontSize,
                                          ),
                                        ),
                                        deleteIcon: Icon(
                                          Icons.close,
                                          size: 20,
                                          color: kColorTextPrimary,
                                        ),
                                        onDeleted: () {
                                          _controller.removeOption(
                                            _controller.options.indexOf(option),
                                          );
                                        },
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  AppButton(
                    title: 'Save',
                    onPressed: () {
                      if (_controller.testingParameterEntryFormKey.currentState!
                          .validate()) {
                        if (_controller.options.isEmpty) {
                          showErrorSnackbar(
                            'Oops!',
                            'Please add test results to continue',
                          );
                        } else {
                          _controller.addtestingParameter();
                        }
                      }
                    },
                  ),
                  AppSpaces.v20,
                ],
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
