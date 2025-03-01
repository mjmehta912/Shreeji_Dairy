import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreeji_dairy/constants/color_constants.dart';
import 'package:shreeji_dairy/features/qc_test_parameter/add_group_wise_test_para/screens/add_group_wise_test_para_screen.dart';
import 'package:shreeji_dairy/features/qc_test_parameter/add_item_wise_test_para/screens/add_item_wise_test_para_screen.dart';
import 'package:shreeji_dairy/features/qc_test_parameter/qc_test_parameters/controllers/qc_test_para_controller.dart';
import 'package:shreeji_dairy/styles/font_sizes.dart';
import 'package:shreeji_dairy/styles/text_styles.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_paddings.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_spacings.dart';
import 'package:shreeji_dairy/widgets/app_button.dart';
import 'package:shreeji_dairy/widgets/app_card1.dart';
import 'package:shreeji_dairy/widgets/app_loading_overlay.dart';

class QcTestParaScreen extends StatelessWidget {
  QcTestParaScreen({
    super.key,
  });

  final QcTestParaController _controller = Get.put(
    QcTestParaController(),
  );

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Stack(
        children: [
          GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: Scaffold(
              backgroundColor: kColorWhite,
              appBar: AppBar(
                backgroundColor: kColorWhite,
                title: Text(
                  'QC Testing Parameter',
                  style: TextStyles.kRegularFredoka(
                    fontSize: FontSizes.k24FontSize,
                    color: kColorTextPrimary,
                  ),
                ),
                leading: IconButton(
                  onPressed: () => Get.back(),
                  icon: Icon(
                    Icons.arrow_back_ios,
                    size: 25,
                    color: kColorTextPrimary,
                  ),
                ),
                bottom: TabBar(
                  dividerColor: kColorWhite,
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelStyle: TextStyles.kRegularFredoka(
                    fontSize: FontSizes.k18FontSize,
                    color: kColorSecondary,
                  ),
                  unselectedLabelStyle: TextStyles.kRegularFredoka(
                    fontSize: FontSizes.k18FontSize,
                    color: kColorTextPrimary,
                  ),
                  tabs: [
                    Tab(
                      text: 'Group Wise',
                    ),
                    Tab(
                      text: 'Item Wise',
                    ),
                  ],
                  indicatorColor: kColorSecondary,
                ),
              ),
              body: TabBarView(
                children: [
                  Padding(
                    padding: AppPaddings.p10,
                    child: Column(
                      children: [
                        Obx(
                          () {
                            return Expanded(
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: _controller
                                    .groupwiseQcTestingParameters.length,
                                itemBuilder: (context, index) {
                                  final testPara = _controller
                                      .groupwiseQcTestingParameters[index];

                                  return AppCard1(
                                    child: Padding(
                                      padding: AppPaddings.p10,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            testPara.icname,
                                            style: TextStyles.kMediumFredoka(
                                              color: kColorSecondary,
                                              fontSize: FontSizes.k18FontSize,
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
                                                      result.testPara,
                                                      style: TextStyles
                                                          .kRegularFredoka(
                                                        fontSize: FontSizes
                                                            .k16FontSize,
                                                        color:
                                                            kColorTextPrimary,
                                                      ),
                                                    ),
                                                    backgroundColor:
                                                        kColorWhite,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
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
                        AppButton(
                          title: 'Add Test Para',
                          onPressed: () {
                            Get.to(
                              () => AddGroupWiseTestParaScreen(),
                            );
                          },
                        ),
                        AppSpaces.v10,
                      ],
                    ),
                  ),
                  Padding(
                    padding: AppPaddings.p10,
                    child: Column(
                      children: [
                        Obx(
                          () {
                            return Expanded(
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: _controller
                                    .itemwiseQcTestingParameters.length,
                                itemBuilder: (context, index) {
                                  final testPara = _controller
                                      .itemwiseQcTestingParameters[index];

                                  return AppCard1(
                                    child: Padding(
                                      padding: AppPaddings.p10,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            testPara.iname,
                                            style: TextStyles.kMediumFredoka(
                                              color: kColorSecondary,
                                              fontSize: FontSizes.k18FontSize,
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
                                                      result.testPara,
                                                      style: TextStyles
                                                          .kRegularFredoka(
                                                        fontSize: FontSizes
                                                            .k16FontSize,
                                                        color:
                                                            kColorTextPrimary,
                                                      ),
                                                    ),
                                                    backgroundColor:
                                                        kColorWhite,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
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
                        AppButton(
                          title: 'Add Test Para',
                          onPressed: () {
                            Get.to(
                              () => AddItemWiseTestParaScreen(),
                            );
                          },
                        ),
                        AppSpaces.v10,
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Obx(
            () => AppLoadingOverlay(
              isLoading: _controller.isLoading.value,
            ),
          ),
        ],
      ),
    );
  }
}
