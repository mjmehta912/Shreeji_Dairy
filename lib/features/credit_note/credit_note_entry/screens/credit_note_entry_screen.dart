import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shreeji_dairy/constants/color_constants.dart';
import 'package:shreeji_dairy/features/credit_note/credit_note_entry/controllers/credit_note_entry_controller.dart';
import 'package:shreeji_dairy/styles/font_sizes.dart';
import 'package:shreeji_dairy/styles/text_styles.dart';
import 'package:shreeji_dairy/utils/extensions/app_size_extensions.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_paddings.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_spacings.dart';
import 'package:shreeji_dairy/widgets/app_appbar.dart';
import 'package:shreeji_dairy/widgets/app_button.dart';
import 'package:shreeji_dairy/widgets/app_card1.dart';
import 'package:shreeji_dairy/widgets/app_dropdown.dart';
import 'package:shreeji_dairy/widgets/app_loading_overlay.dart';
import 'package:shreeji_dairy/widgets/app_text_form_field.dart';

class CreditNoteEntryScreen extends StatefulWidget {
  const CreditNoteEntryScreen({
    super.key,
    required this.pCode,
    required this.pName,
  });

  final String pCode;
  final String pName;

  @override
  State<CreditNoteEntryScreen> createState() => _CreditNoteEntryScreenState();
}

class _CreditNoteEntryScreenState extends State<CreditNoteEntryScreen> {
  final CreditNoteEntryController _controller = Get.put(
    CreditNoteEntryController(),
  );
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _controller.getAllItems();
  }

  Future<void> pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _controller.selectedImage.value = File(pickedFile.path);
    }
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
              title: 'Credit Note Entry',
              subtitle: widget.pName,
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
                    child: Obx(
                      () => ListView.builder(
                        shrinkWrap: true,
                        itemCount: _controller.addedItems.length,
                        itemBuilder: (context, index) {
                          final item = _controller.addedItems[index];
                          return AppCard1(
                            child: Padding(
                              padding: AppPaddings.p12,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.file(
                                      item['image'],
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  AppSpaces.h10,
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${item['itemName']} - ${item['skuPack']}',
                                          style: TextStyles.kMediumFredoka(
                                            fontSize: FontSizes.k16FontSize,
                                          ).copyWith(
                                            height: 1,
                                          ),
                                        ),
                                        AppSpaces.v10,
                                        Text(
                                          'Qty : ${item['qty']}',
                                          style: TextStyles.kLightFredoka(
                                            fontSize: FontSizes.k16FontSize,
                                          ).copyWith(
                                            height: 1,
                                          ),
                                        ),
                                        AppSpaces.v10,
                                        Text(
                                          'Inv No : ${item['invNo']}',
                                          style: TextStyles.kLightFredoka(
                                            fontSize: FontSizes.k16FontSize,
                                          ).copyWith(
                                            height: 1,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  AppSpaces.v10,
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                _controller.clearForm();

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
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Obx(
                              () => AppDropdown(
                                items: _controller.itemNames,
                                hintText: 'Items',
                                onChanged: (value) {
                                  _controller.onItemSelected(
                                    _controller.items.firstWhere(
                                      (item) => item.printName == value,
                                    ),
                                  );
                                },
                                selectedItem: _controller.selectedItem.value !=
                                            null &&
                                        _controller.selectedItem.value!
                                            .printName.isNotEmpty
                                    ? _controller.selectedItem.value?.printName
                                    : null,
                              ),
                            ),
                            AppSpaces.v10,
                            Obx(
                              () => AppDropdown(
                                items: _controller.skuPacks,
                                hintText: 'Sku',
                                onChanged: (value) {
                                  _controller.onSkuSelected(
                                    _controller.skus.firstWhere(
                                      (sku) => sku.pack == value,
                                    ),
                                  );
                                },
                                selectedItem:
                                    _controller.selectedPack.value.isNotEmpty
                                        ? _controller.selectedPack.value
                                        : null,
                              ),
                            ),
                            AppSpaces.v10,
                            AppTextFormField(
                              controller: _controller.qtyController,
                              hintText: 'Qty',
                              keyboardType: TextInputType.number,
                            ),
                            AppSpaces.v10,
                            AppTextFormField(
                              controller: _controller.invNoController,
                              hintText: 'Inv No.',
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
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: Image.file(
                                                _controller
                                                    .selectedImage.value!,
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
                                                  _controller.selectedImage
                                                      .value = null;
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.all(2),
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.white,
                                                    border: Border.all(
                                                        color: Colors.grey,
                                                        width: 1),
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                AppButton(
                                  buttonWidth: 0.5.screenWidth,
                                  title: 'Add',
                                  onPressed: () {
                                    _controller.addItemToList(
                                      itemName: _controller
                                              .selectedItem.value?.printName ??
                                          '',
                                      skuPack: _controller.selectedPack.value,
                                      skuICode:
                                          _controller.selectedSkuIcode.value,
                                      qty: _controller.qtyController.text,
                                      invNo: _controller.invNoController.text,
                                    );
                                    Get.back();
                                  },
                                ),
                              ],
                            ),
                            AppSpaces.v20,
                          ],
                        ),
                      ),
                    ),
                  ),
                  isScrollControlled: true,
                );
              },
              shape: CircleBorder(),
              backgroundColor: kColorPrimary,
              child: Icon(
                Icons.add,
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
}
