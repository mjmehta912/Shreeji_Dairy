import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreeji_dairy/constants/color_constants.dart';
import 'package:shreeji_dairy/styles/font_sizes.dart';
import 'package:shreeji_dairy/styles/text_styles.dart';
import 'package:shreeji_dairy/utils/extensions/app_size_extensions.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_paddings.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_spacings.dart';
import 'package:shreeji_dairy/widgets/app_button.dart';
import 'package:shreeji_dairy/widgets/app_text_form_field.dart';

void showFilterBottomSheet<T>({
  required String title,
  required List<T> items,
  required RxSet<String> selectedItems,
  required TextEditingController searchController,
  required String Function(T item) displayField,
  required String Function(T item) valueField,
  required VoidCallback onApply,
  required VoidCallback onClear,
}) {
  final RxSet<String> tempSelectedItems = selectedItems.toSet().obs;
  final RxString searchQuery = ''.obs;

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
        maxHeight: 0.75.screenHeight,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: TextStyles.kRegularFredoka(
              fontSize: FontSizes.k20FontSize,
              color: kColorTextPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          AppSpaces.v10,
          AppTextFormField(
            controller: searchController,
            hintText: 'Search $title',
            onChanged: (value) {
              searchQuery.value = value.toLowerCase();
            },
          ),
          AppSpaces.v10,
          Expanded(
            child: Obx(
              () {
                final filteredItems = items
                    .where((item) => displayField(item)
                        .toLowerCase()
                        .contains(searchQuery.value))
                    .toList()
                  ..sort(
                    (a, b) {
                      bool aSelected =
                          tempSelectedItems.contains(valueField(a));
                      bool bSelected =
                          tempSelectedItems.contains(valueField(b));
                      return (bSelected ? 1 : 0).compareTo(aSelected ? 1 : 0);
                    },
                  );

                return ListView(
                  shrinkWrap: true,
                  children: filteredItems.map(
                    (item) {
                      return CheckboxListTile(
                        title: Text(
                          displayField(item),
                          style: TextStyles.kRegularFredoka(
                            fontSize: FontSizes.k16FontSize,
                            color: kColorTextPrimary,
                          ),
                        ),
                        contentPadding: EdgeInsets.zero,
                        value: tempSelectedItems.contains(valueField(item)),
                        activeColor: kColorSecondary,
                        onChanged: (isSelected) {
                          if (isSelected == true) {
                            tempSelectedItems.add(valueField(item));
                          } else {
                            tempSelectedItems.remove(valueField(item));
                          }
                        },
                      );
                    },
                  ).toList(),
                );
              },
            ),
          ),
          AppSpaces.v10,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                child: Text(
                  'Clear Filter',
                  style: TextStyles.kRegularFredoka(
                    fontSize: FontSizes.k18FontSize,
                    color: kColorSecondary,
                  ).copyWith(
                    decoration: TextDecoration.underline,
                    decorationColor: kColorSecondary,
                  ),
                ),
                onPressed: () {
                  selectedItems.clear();
                  onClear();
                  Get.back();
                },
              ),
              AppButton(
                buttonWidth: 0.5.screenWidth,
                buttonHeight: 40,
                buttonColor: kColorPrimary,
                titleColor: kColorTextPrimary,
                titleSize: FontSizes.k16FontSize,
                onPressed: () {
                  selectedItems
                    ..clear()
                    ..addAll(tempSelectedItems);
                  onApply();
                  Get.back();
                },
                title: 'Apply Filter',
              ),
            ],
          ),
        ],
      ),
    ),
    isScrollControlled: true,
  );
}
