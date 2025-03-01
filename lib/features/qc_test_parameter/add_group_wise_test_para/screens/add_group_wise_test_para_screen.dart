import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreeji_dairy/constants/color_constants.dart';
import 'package:shreeji_dairy/features/qc_test_parameter/add_group_wise_test_para/controllers/add_group_wise_test_para_controller.dart';
import 'package:shreeji_dairy/styles/font_sizes.dart';
import 'package:shreeji_dairy/styles/text_styles.dart';
import 'package:shreeji_dairy/utils/dialogs/app_dialogs.dart';
import 'package:shreeji_dairy/utils/extensions/app_size_extensions.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_paddings.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_spacings.dart';
import 'package:shreeji_dairy/widgets/app_button.dart';
import 'package:shreeji_dairy/widgets/app_card1.dart';
import 'package:shreeji_dairy/widgets/app_dropdown.dart';
import 'package:shreeji_dairy/widgets/app_loading_overlay.dart';

class AddGroupWiseTestParaScreen extends StatelessWidget {
  AddGroupWiseTestParaScreen({
    super.key,
  });

  final AddGroupWiseTestParaController _controller = Get.put(
    AddGroupWiseTestParaController(),
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
            appBar: AppBar(
              backgroundColor: kColorWhite,
              title: Text(
                'Add Group Wise Test Para',
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
            ),
            body: Padding(
              padding: AppPaddings.p10,
              child: Column(
                children: [
                  Obx(
                    () => AppDropdown(
                      items: _controller.subGroupNames,
                      hintText: 'Group',
                      onChanged: _controller.onSubGroupSelected,
                      selectedItem:
                          _controller.selectedSubGroup.value.isNotEmpty
                              ? _controller.selectedSubGroup.value
                              : null,
                    ),
                  ),
                  AppSpaces.v10,
                  Obx(
                    () => AppDropdown(
                      items: _controller.testingParameterNames,
                      hintText: 'Testing Parameter',
                      onChanged: _controller.onTestingParameterSelected,
                      selectedItem:
                          _controller.selectedTestingParameter.value.isNotEmpty
                              ? _controller.selectedTestingParameter.value
                              : null,
                    ),
                  ),
                  AppSpaces.v20,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      AppButton(
                        title: '+ Add',
                        titleColor: kColorTextPrimary,
                        buttonColor: kColorPrimary,
                        buttonWidth: 0.4.screenWidth,
                        buttonHeight: 40,
                        onPressed: _controller.addData,
                      ),
                    ],
                  ),
                  AppSpaces.v20,
                  Obx(
                    () => Expanded(
                      child: ListView.builder(
                        itemCount: _controller.addedData.length,
                        itemBuilder: (context, index) {
                          final item = _controller.addedData[index];
                          return AppCard1(
                            child: ListTile(
                              title: Text(
                                'Group : ${item['ICNAME']}',
                                style: TextStyles.kRegularFredoka(
                                  fontSize: FontSizes.k18FontSize,
                                ),
                              ),
                              subtitle: Text(
                                'Test Para : ${item['TPNAME']}',
                                style: TextStyles.kRegularFredoka(
                                  fontSize: FontSizes.k16FontSize,
                                ),
                              ),
                              trailing: InkWell(
                                onTap: () {
                                  _controller.deleteData(index);
                                },
                                child: Icon(
                                  Icons.delete,
                                  color: kColorRed,
                                  size: 20,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  AppButton(
                    title: 'Save',
                    onPressed: () {
                      if (_controller.addedData.isNotEmpty) {
                        _controller.addGroupwiseQcTestPara();
                      } else {
                        showErrorSnackbar(
                          'Oops!',
                          'Please add test parameters to continue',
                        );
                      }
                    },
                  ),
                  AppSpaces.v10,
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
