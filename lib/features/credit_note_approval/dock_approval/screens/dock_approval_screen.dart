import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shreeji_dairy/constants/color_constants.dart';
import 'package:shreeji_dairy/features/credit_note_approval/dock_approval/controllers/dock_approval_controller.dart';
import 'package:shreeji_dairy/features/credit_note_approval/dock_approval/widgets/dock_approval_card.dart';
import 'package:shreeji_dairy/styles/font_sizes.dart';
import 'package:shreeji_dairy/styles/text_styles.dart';
import 'package:shreeji_dairy/utils/extensions/app_size_extensions.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_paddings.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_spacings.dart';
import 'package:shreeji_dairy/widgets/app_appbar.dart';
import 'package:shreeji_dairy/widgets/app_button.dart';
import 'package:shreeji_dairy/widgets/app_loading_overlay.dart';
import 'package:shreeji_dairy/widgets/app_text_form_field.dart';

class DockApprovalScreen extends StatelessWidget {
  DockApprovalScreen({
    super.key,
  });

  final DockApprovalController _controller = Get.put(
    DockApprovalController(),
  );

  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _controller.selectedImage.value = File(pickedFile.path);
    }
  }

  void _showDockApprovalBottomSheet({
    required String id,
  }) {
    _controller.qtyController.clear();
    _controller.weightController.clear();
    _controller.remarkController.clear();
    _controller.selectedImage.value = null;
    Get.bottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: kColorWhite,
        ),
        padding: AppPaddings.p16,
        constraints: BoxConstraints(
          maxHeight: 0.6.screenHeight,
        ),
        child: GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: SingleChildScrollView(
            child: Form(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AppTextFormField(
                    controller: _controller.qtyController,
                    hintText: 'Qty',
                  ),
                  AppSpaces.v10,
                  AppTextFormField(
                    controller: _controller.weightController,
                    hintText: 'Weight',
                  ),
                  AppSpaces.v10,
                  AppTextFormField(
                    controller: _controller.remarkController,
                    hintText: 'Remark',
                  ),
                  AppSpaces.v10,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: pickImage,
                        child: Text(
                          'Upload Image',
                          style: TextStyles.kRegularFredoka(
                            color: kColorSecondary,
                            fontSize: FontSizes.k18FontSize,
                          ).copyWith(
                            decoration: TextDecoration.underline,
                            decorationColor: kColorSecondary,
                          ),
                        ),
                      ),
                      Obx(
                        () => _controller.selectedImage.value != null
                            ? Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.file(
                                      _controller.selectedImage.value!,
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned(
                                    top: -7.5,
                                    right: -7.5,
                                    child: GestureDetector(
                                      onTap: () {
                                        _controller.selectedImage.value = null;
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white,
                                          border: Border.all(
                                              color: Colors.grey, width: 1),
                                        ),
                                        child: Icon(
                                          Icons.close,
                                          color: Colors.grey,
                                          size: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Container(),
                      ),
                    ],
                  ),
                  AppSpaces.v10,
                  AppButton(
                    title: 'Save',
                    buttonWidth: 0.3.screenWidth,
                    buttonHeight: 40,
                    titleSize: FontSizes.k16FontSize,
                    onPressed: () {
                      _controller.approveDock(
                        id: id,
                      );
                    },
                  ),
                  AppSpaces.v10,
                ],
              ),
            ),
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          child: Scaffold(
            backgroundColor: kColorWhite,
            appBar: AppAppbar(
              title: 'Dock Approval',
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
              padding: AppPaddings.p12,
              child: Column(
                children: [
                  Obx(
                    () {
                      if (_controller.itemsForApproval.isEmpty &&
                          !_controller.isLoading.value) {
                        return Expanded(
                          child: Center(
                            child: Text(
                              'No credit notes found.',
                              style: TextStyles.kRegularFredoka(),
                            ),
                          ),
                        );
                      }
                      return Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: _controller.itemsForApproval.length,
                          itemBuilder: (context, index) {
                            final item = _controller.itemsForApproval[index];

                            return DockApprovalCard(
                              item: item,
                              onApproved: () {
                                _showDockApprovalBottomSheet(
                                  id: item.id.toString(),
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
