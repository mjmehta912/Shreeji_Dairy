import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreeji_dairy/constants/color_constants.dart';
import 'package:shreeji_dairy/features/testing_parmeter/testing_parameter_entry/screens/testing_parameter_entry_screen.dart';
import 'package:shreeji_dairy/features/testing_parmeter/testing_parameters/controllers/testing_parameters_controller.dart';
import 'package:shreeji_dairy/styles/font_sizes.dart';
import 'package:shreeji_dairy/styles/text_styles.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_paddings.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_spacings.dart';
import 'package:shreeji_dairy/widgets/app_appbar.dart';
import 'package:shreeji_dairy/widgets/app_card1.dart';
import 'package:shreeji_dairy/widgets/app_loading_overlay.dart';

class TestingParametersScreen extends StatelessWidget {
  TestingParametersScreen({
    super.key,
  });

  final TestingParametersController _controller = Get.put(
    TestingParametersController(),
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
              title: 'Testing Parameters',
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
                  Obx(
                    () {
                      if (_controller.testingParameters.isEmpty &&
                          !_controller.isLoading.value) {
                        return Expanded(
                          child: Center(
                            child: Text(
                              'No testing parameters found.',
                              style: TextStyles.kRegularFredoka(),
                            ),
                          ),
                        );
                      }
                      return Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: _controller.testingParameters.length,
                          itemBuilder: (context, index) {
                            final testPara =
                                _controller.testingParameters[index];

                            return AppCard1(
                              child: Padding(
                                padding: AppPaddings.p10,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      testPara.testPara,
                                      style: TextStyles.kRegularFredoka(
                                        color: kColorTextPrimary,
                                      ),
                                    ),
                                    AppSpaces.v10,
                                    Wrap(
                                      spacing: 10,
                                      runSpacing: 10,
                                      children: testPara.testResult
                                          .map(
                                            (result) => Chip(
                                              label: Text(
                                                result.testResult,
                                                style:
                                                    TextStyles.kRegularFredoka(
                                                  fontSize:
                                                      FontSizes.k16FontSize,
                                                  color: kColorTextPrimary,
                                                ),
                                              ),
                                              backgroundColor: kColorWhite,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                side: BorderSide(
                                                  color: kColorSecondary,
                                                  width: 1,
                                                ),
                                              ),
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Get.to(
                  () => TestingParameterEntryScreen(),
                );
              },
              shape: const CircleBorder(),
              backgroundColor: kColorPrimary,
              child: Icon(
                Icons.add,
                color: kColorTextPrimary,
                size: 25,
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
