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
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Scaffold(
            backgroundColor: kColorWhite,
            appBar: AppAppbar(
              title: 'Testing Parameters',
              leading: IconButton(
                onPressed: () => Get.back(),
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 22,
                  color: kColorTextPrimary,
                ),
              ),
            ),
            body: Padding(
              padding: AppPaddings.p10,
              child: Obx(
                () {
                  if (_controller.testingParameters.isEmpty &&
                      !_controller.isLoading.value) {
                    return Center(
                      child: Text(
                        'No testing parameters found.',
                        style: TextStyles.kRegularFredoka(
                          fontSize: FontSizes.k18FontSize,
                          color: kColorSecondary,
                        ),
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: _controller.testingParameters.length,
                    itemBuilder: (context, index) {
                      final testPara = _controller.testingParameters[index];

                      return _buildStandardCard(
                          testPara.testPara, testPara.testResult);
                    },
                  );
                },
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () => Get.to(
                () => TestingParameterEntryScreen(),
              ),
              backgroundColor: kColorPrimary,
              elevation: 3,
              shape: const CircleBorder(),
              child: Icon(
                Icons.add_rounded,
                color: kColorTextPrimary,
                size: 28,
              ),
            ),
          ),
        ),
        Obx(
          () => AppLoadingOverlay(isLoading: _controller.isLoading.value),
        ),
      ],
    );
  }

  Widget _buildStandardCard(
    String title,
    List<dynamic> results,
  ) {
    return AppCard1(
      child: Padding(
        padding: AppPaddings.p10,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyles.kMediumFredoka(
                fontSize: FontSizes.k18FontSize,
                color: kColorTextPrimary,
              ),
            ),
            AppSpaces.v10,
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: results
                  .map(
                    (result) => Chip(
                      label: Text(
                        result.testResult,
                        style: TextStyles.kRegularFredoka(
                          fontSize: FontSizes.k16FontSize,
                          color: kColorTextPrimary,
                        ),
                      ),
                      backgroundColor: kColorLightGrey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                          color: kColorSecondary,
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
  }
}
