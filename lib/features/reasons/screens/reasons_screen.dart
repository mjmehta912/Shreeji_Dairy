import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreeji_dairy/constants/color_constants.dart';
import 'package:shreeji_dairy/features/reasons/controllers/reasons_controller.dart';
import 'package:shreeji_dairy/features/reasons/models/reason_dm.dart';
import 'package:shreeji_dairy/features/reasons/widgets/reason_card.dart';
import 'package:shreeji_dairy/styles/font_sizes.dart';
import 'package:shreeji_dairy/styles/text_styles.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_paddings.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_spacings.dart';
import 'package:shreeji_dairy/widgets/app_appbar.dart';
import 'package:shreeji_dairy/widgets/app_button.dart';
import 'package:shreeji_dairy/widgets/app_dropdown.dart';
import 'package:shreeji_dairy/widgets/app_loading_overlay.dart';
import 'package:shreeji_dairy/widgets/app_text_form_field.dart';

class ReasonsScreen extends StatelessWidget {
  ReasonsScreen({
    super.key,
  });

  final ReasonsController _controller = Get.put(
    ReasonsController(),
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
              title: 'Reasons',
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
                  AppTextFormField(
                    controller: _controller.searchController,
                    hintText: 'Search Reason',
                    onChanged: _controller.searchReasons,
                  ),
                  AppSpaces.v14,
                  Obx(
                    () {
                      if (_controller.filteredReasons.isEmpty &&
                          !_controller.isLoading.value) {
                        return Expanded(
                          child: Center(
                            child: Text(
                              'No reasons found.',
                              style: TextStyles.kRegularFredoka(),
                            ),
                          ),
                        );
                      }
                      return Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: _controller.filteredReasons.length,
                          itemBuilder: (context, index) {
                            final reason = _controller.filteredReasons[index];

                            return ReasonCard(
                              reason: reason,
                              onPressedEdit: () {
                                _showAddReasonDialog(
                                  true,
                                  reason: reason,
                                );
                              },
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
                _showAddReasonDialog(false);
              },
              shape: const CircleBorder(),
              backgroundColor: kColorPrimary,
              child: Icon(
                Icons.add,
                size: 25,
                color: kColorTextPrimary,
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

  void _showAddReasonDialog(bool isEdit, {ReasonDm? reason}) {
    if (isEdit && reason != null) {
      _controller.reasonController.text = reason.rName;
      _controller.selectedUseInLabel.value = reason.label;
      _controller.selectedUseIn.value = reason.useIn;
    } else {
      _controller.reasonController.clear();
      _controller.selectedUseIn.value = '';
      _controller.selectedUseInLabel.value = '';
    }

    Get.dialog(
      Dialog(
        backgroundColor: kColorWhite,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: AppPaddings.p10,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: 0.75 * Get.height,
            ),
            child: SingleChildScrollView(
              child: Form(
                key: _controller.reasonFormKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        isEdit ? 'Edit Reason' : 'Add Reason',
                        style: TextStyles.kMediumFredoka(
                          fontSize: FontSizes.k20FontSize,
                          color: kColorSecondary,
                        ),
                      ),
                    ),
                    AppSpaces.v10,
                    AppTextFormField(
                      controller: _controller.reasonController,
                      hintText: 'Reason',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a reason';
                        }
                        return null;
                      },
                    ),
                    AppSpaces.v10,
                    Obx(
                      () => AppDropdown(
                        items: _controller.useInLabels,
                        hintText: 'Use In',
                        onChanged: _controller.onUseInSelected,
                        selectedItem:
                            _controller.selectedUseInLabel.value.isNotEmpty
                                ? _controller.selectedUseInLabel.value
                                : null,
                        validatorText: 'Please select a use in',
                      ),
                    ),
                    AppSpaces.v20,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        AppButton(
                          title: 'Cancel',
                          titleSize: FontSizes.k16FontSize,
                          buttonWidth: 0.2 * Get.width,
                          buttonHeight: 40,
                          onPressed: () => Get.back(),
                        ),
                        AppSpaces.h10,
                        AppButton(
                          title: isEdit ? 'Edit' : 'Add',
                          titleSize: FontSizes.k16FontSize,
                          buttonWidth: 0.2 * Get.width,
                          buttonHeight: 40,
                          onPressed: () {
                            if (_controller.reasonFormKey.currentState!
                                .validate()) {
                              if (isEdit && reason != null) {
                                _controller.editReason(
                                  id: reason.id.toString(),
                                );
                              } else {
                                _controller.addReason();
                              }
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
