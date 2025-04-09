// ignore_for_file: deprecated_member_use

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
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 10,
      ),
      decoration: const BoxDecoration(
        color: kColorWhite,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
      constraints: BoxConstraints(
        maxHeight: 0.85.screenHeight,
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 5,
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: kColorWhite,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          Text(
            title,
            style: TextStyles.kMediumFredoka(
              fontSize: FontSizes.k22FontSize,
              color: kColorTextPrimary,
            ),
          ),
          AppSpaces.v10,
          AppTextFormField(
            hintText: 'Search $title',
            controller: searchController,
            onChanged: (val) => searchQuery.value = val.toLowerCase(),
          ),
          AppSpaces.v10,
          Row(
            children: [
              Obx(
                () {
                  final isAllSelected =
                      tempSelectedItems.length == items.length;
                  return TextButton.icon(
                    onPressed: () {
                      if (isAllSelected) {
                        tempSelectedItems.clear();
                      } else {
                        tempSelectedItems.addAll(
                          items.map((item) => valueField(item)),
                        );
                      }
                    },
                    icon: Icon(
                      isAllSelected ? Icons.close : Icons.done_all,
                      color: kColorSecondary,
                    ),
                    label: Text(
                      isAllSelected ? 'Deselect All' : 'Select All',
                      style: TextStyles.kRegularFredoka(
                        fontSize: FontSizes.k16FontSize,
                        color: kColorSecondary,
                      ),
                    ),
                  );
                },
              ),
              const Spacer(),
              Obx(
                () {
                  return Text(
                    '${tempSelectedItems.length} selected',
                    style: TextStyles.kRegularFredoka(
                      fontSize: FontSizes.k16FontSize,
                      color: kColorGrey,
                    ),
                  );
                },
              ),
            ],
          ),
          AppSpaces.v10,
          Expanded(
            child: Obx(
              () {
                final filteredItems = items
                    .where(
                      (item) => displayField(item)
                          .toLowerCase()
                          .contains(searchQuery.value),
                    )
                    .toList()
                  ..sort(
                    (a, b) {
                      final aSelected =
                          tempSelectedItems.contains(valueField(a));
                      final bSelected =
                          tempSelectedItems.contains(valueField(b));
                      return (bSelected ? 1 : 0).compareTo(aSelected ? 1 : 0);
                    },
                  );

                return ListView.builder(
                  itemCount: filteredItems.length,
                  itemBuilder: (_, index) {
                    final item = filteredItems[index];
                    final value = valueField(item);
                    final label = displayField(item);
                    final isSelected = tempSelectedItems.contains(value);

                    return InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () {
                        if (isSelected) {
                          tempSelectedItems.remove(value);
                        } else {
                          tempSelectedItems.add(value);
                        }
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeInOut,
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        padding: AppPaddings.p12,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? kColorSecondary.withOpacity(0.1)
                              : kColorLightGrey.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isSelected
                                ? kColorSecondary
                                : Colors.transparent,
                            width: 1.2,
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                label,
                                style: isSelected
                                    ? TextStyles.kMediumFredoka(
                                        fontSize: FontSizes.k16FontSize,
                                        color: kColorTextPrimary,
                                      )
                                    : TextStyles.kRegularFredoka(
                                        fontSize: FontSizes.k14FontSize,
                                        color: kColorTextPrimary,
                                      ),
                              ),
                            ),
                            if (isSelected)
                              const Icon(
                                Icons.check_circle,
                                color: kColorSecondary,
                                size: 20,
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          AppSpaces.v10,
          SafeArea(
            child: Row(
              children: [
                Expanded(
                  child: AppButton(
                    title: 'Clear Filter',
                    titleSize: FontSizes.k18FontSize,
                    titleColor: kColorSecondary,
                    buttonColor: kColorWhite,
                    borderColor: kColorSecondary,
                    onPressed: () {
                      selectedItems.clear();
                      onClear();
                      Get.back();
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: AppButton(
                    title: 'Apply Filter',
                    titleSize: FontSizes.k18FontSize,
                    onPressed: () {
                      selectedItems
                        ..clear()
                        ..addAll(tempSelectedItems);
                      onApply();
                      Get.back();
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
    isScrollControlled: true,
  );
}
