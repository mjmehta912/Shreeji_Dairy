import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreeji_dairy/constants/color_constants.dart';
import 'package:shreeji_dairy/features/slot_master/slots/controllers/slots_controller.dart';
import 'package:shreeji_dairy/styles/font_sizes.dart';
import 'package:shreeji_dairy/styles/text_styles.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_paddings.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_spacings.dart';
import 'package:shreeji_dairy/widgets/app_appbar.dart';
import 'package:shreeji_dairy/widgets/app_button.dart';
import 'package:shreeji_dairy/widgets/app_card1.dart';
import 'package:shreeji_dairy/widgets/app_loading_overlay.dart';
import 'package:shreeji_dairy/widgets/app_text_form_field.dart';
import 'package:shreeji_dairy/widgets/app_time_picker_field.dart';
import 'package:shreeji_dairy/widgets/app_title_value_row.dart';

class SlotsScreen extends StatefulWidget {
  const SlotsScreen({
    super.key,
    required this.cCode,
    required this.cName,
  });

  final String cCode;
  final String cName;

  @override
  State<SlotsScreen> createState() => _SlotsScreenState();
}

class _SlotsScreenState extends State<SlotsScreen> {
  final SlotsController _controller = Get.put(
    SlotsController(),
  );

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  void _initialize() async {
    await _controller.getCategoryWiseSlots(
      cCode: widget.cCode,
    );
  }

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
              title: widget.cName,
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
                    hintText: 'Search',
                    onChanged: _controller.searchSlots,
                  ),
                  AppSpaces.v10,
                  Obx(
                    () {
                      if (_controller.filteredSlots.isEmpty &&
                          !_controller.isLoading.value) {
                        return Expanded(
                          child: Center(
                            child: Text(
                              'No slots found.',
                              style: TextStyles.kRegularFredoka(),
                            ),
                          ),
                        );
                      }
                      return Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: _controller.filteredSlots.length,
                          itemBuilder: (context, index) {
                            final slot = _controller.filteredSlots[index];

                            return GestureDetector(
                              onTap: () {},
                              child: AppCard1(
                                child: Padding(
                                  padding: AppPaddings.p10,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          AppTitleValueRow(
                                            title: 'Slot',
                                            value: slot.slot,
                                          ),
                                          AppTitleValueRow(
                                            title: 'Del. Time',
                                            value: slot.dTime,
                                          ),
                                        ],
                                      ),
                                      InkWell(
                                        onTap: () {
                                          _controller.removeSlot(
                                            id: slot.id.toString(),
                                            cCode: widget.cCode,
                                          );
                                        },
                                        child: Icon(
                                          Icons.delete,
                                          size: 20,
                                          color: kColorRed,
                                        ),
                                      ),
                                    ],
                                  ),
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
              onPressed: () {},
              backgroundColor: kColorPrimary,
              shape: const CircleBorder(),
              child: IconButton(
                onPressed: () {
                  _showAddSlotDialog();
                },
                icon: Icon(
                  Icons.add,
                  size: 25,
                  color: kColorTextPrimary,
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

  void _showAddSlotDialog() {
    _controller.slotFromController.clear();
    _controller.slotToController.clear();
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
                key: _controller.slotFormKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Add Slot',
                        style: TextStyles.kMediumFredoka(
                          fontSize: FontSizes.k20FontSize,
                          color: kColorSecondary,
                        ),
                      ),
                    ),
                    AppSpaces.v10,
                    AppTimePickerTextFormField(
                      timeController: _controller.slotFromController,
                      hintText: 'From',
                    ),
                    AppSpaces.v10,
                    AppTimePickerTextFormField(
                      timeController: _controller.slotToController,
                      hintText: 'To',
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
                          title: 'Add',
                          titleSize: FontSizes.k16FontSize,
                          buttonWidth: 0.2 * Get.width,
                          buttonHeight: 40,
                          onPressed: () {
                            if (_controller.slotFormKey.currentState!
                                .validate()) {
                              _controller.addSlot(
                                cCode: widget.cCode,
                              );
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
