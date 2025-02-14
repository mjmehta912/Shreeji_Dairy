import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shreeji_dairy/constants/color_constants.dart';
import 'package:shreeji_dairy/features/credit_note/credit_note_entry/controllers/credit_note_entry_controller.dart';
import 'package:shreeji_dairy/styles/font_sizes.dart';
import 'package:shreeji_dairy/styles/text_styles.dart';
import 'package:shreeji_dairy/utils/dialogs/app_dialogs.dart';
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
              actions: [
                IconButton(
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
                            child: Form(
                              key: _controller.creditNoteEntryFormKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Obx(
                                    () => AppDropdown(
                                      items: _controller.itemNames,
                                      hintText: 'Items',
                                      onChanged: (value) async {
                                        _controller.onItemSelected(
                                          _controller.items.firstWhere(
                                            (item) => item.printName == value,
                                          ),
                                        );
                                      },
                                      selectedItem:
                                          _controller.selectedItem.value !=
                                                      null &&
                                                  _controller
                                                      .selectedItem
                                                      .value!
                                                      .printName
                                                      .isNotEmpty
                                              ? _controller
                                                  .selectedItem.value?.printName
                                              : null,
                                      validatorText: 'Please select an item',
                                    ),
                                  ),
                                  AppSpaces.v10,
                                  Obx(
                                    () => AppDropdown(
                                      items: _controller.skuPacks,
                                      hintText: 'Sku',
                                      onChanged: (value) async {
                                        _controller.onSkuSelected(
                                          _controller.skus.firstWhere(
                                            (sku) => sku.pack == value,
                                          ),
                                        );
                                        await _controller.getInvNos(
                                          pCode: widget.pCode,
                                          iCode: _controller
                                              .selectedSkuIcode.value,
                                        );
                                      },
                                      selectedItem: _controller
                                              .selectedPack.value.isNotEmpty
                                          ? _controller.selectedPack.value
                                          : null,
                                      validatorText: 'Please select a pack',
                                    ),
                                  ),
                                  AppSpaces.v10,
                                  AppTextFormField(
                                    controller: _controller.qtyController,
                                    hintText: 'Qty',
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter a qty';
                                      }
                                      return null;
                                    },
                                  ),
                                  AppSpaces.v10,
                                  Obx(
                                    () => AppDropdown(
                                      items: _controller.invNoNos,
                                      hintText: 'Inv No.',
                                      onChanged: (value) {
                                        _controller.onInvNoSelected(value!);
                                      },
                                      selectedItem: _controller
                                              .selectedInvNo.value.isNotEmpty
                                          ? _controller.selectedInvNo.value
                                          : null,
                                    ),
                                  ),
                                  AppSpaces.v10,
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextButton(
                                        onPressed: pickImage,
                                        child: Text(
                                          'Upload Image',
                                          style: TextStyles.kRegularFredoka(
                                            color: kColorSecondary,
                                            fontSize: FontSizes.k18FontSize,
                                          ).copyWith(
                                            decoration:
                                                TextDecoration.underline,
                                            decorationColor: kColorSecondary,
                                          ),
                                        ),
                                      ),
                                      Obx(
                                        () => _controller.selectedImage.value !=
                                                null
                                            ? Stack(
                                                clipBehavior: Clip.none,
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
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
                                                        _controller
                                                            .selectedImage
                                                            .value = null;
                                                      },
                                                      child: Container(
                                                        padding:
                                                            EdgeInsets.all(2),
                                                        decoration:
                                                            BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color: Colors.white,
                                                          border: Border.all(
                                                              color:
                                                                  Colors.grey,
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
                                          if (_controller.creditNoteEntryFormKey
                                              .currentState!
                                              .validate()) {
                                            if (_controller
                                                    .selectedImage.value ==
                                                null) {
                                              showErrorSnackbar(
                                                'Oops',
                                                'Please upload an image',
                                              );
                                            } else {
                                              _controller.addItemToList(
                                                itemName: _controller
                                                        .selectedItem
                                                        .value
                                                        ?.printName ??
                                                    '',
                                                skuPack: _controller
                                                    .selectedPack.value,
                                                skuICode: _controller
                                                    .selectedSkuIcode.value,
                                                qty: _controller
                                                    .qtyController.text,
                                                invNo: _controller
                                                    .selectedInvNo.value,
                                              );
                                              Get.back();
                                            }
                                          }
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
                      ),
                      isScrollControlled: true,
                    );
                  },
                  icon: Icon(
                    Icons.add,
                    size: 30,
                    color: kColorTextPrimary,
                  ),
                ),
              ],
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
                                            fontSize: FontSizes.k18FontSize,
                                          ).copyWith(
                                            height: 1.25,
                                          ),
                                        ),
                                        Text(
                                          'Qty : ${item['qty']}',
                                          style: TextStyles.kRegularFredoka(
                                            fontSize: FontSizes.k18FontSize,
                                          ).copyWith(
                                            height: 1.25,
                                          ),
                                        ),
                                        Text(
                                          'Inv No : ${item['invNo']}',
                                          style: TextStyles.kRegularFredoka(
                                            fontSize: FontSizes.k18FontSize,
                                          ).copyWith(
                                            height: 1.25,
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                _controller.deleteItem(
                                                  item['serialNo'],
                                                );
                                              },
                                              child: Icon(
                                                Icons.delete,
                                                color: kColorRed,
                                              ),
                                            ),
                                          ],
                                        )
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
                  Obx(
                    () => Visibility(
                      visible: _controller.addedItems.isNotEmpty,
                      child: Column(
                        children: [
                          AppTextFormField(
                            controller: _controller.remarkController,
                            hintText: 'Remark',
                          ),
                          AppSpaces.v10,
                          AppButton(
                            title: 'Save',
                            onPressed: () {
                              if (_controller.addedItems.isEmpty) {
                                showErrorSnackbar(
                                  'Oops!',
                                  'Please add an item to continue',
                                );
                              } else {
                                _controller.saveCreditNote(
                                  pCode: widget.pCode,
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
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
