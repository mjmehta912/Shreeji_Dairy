import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreeji_dairy/constants/color_constants.dart';
import 'package:shreeji_dairy/features/products/widgets/products_filter_bottom_sheet.dart';
import 'package:shreeji_dairy/features/store_order/controllers/store_order_controller.dart';
import 'package:shreeji_dairy/features/store_order/screens/place_store_order_screen.dart';
import 'package:shreeji_dairy/styles/font_sizes.dart';
import 'package:shreeji_dairy/styles/text_styles.dart';
import 'package:shreeji_dairy/utils/extensions/app_size_extensions.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_paddings.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_spacings.dart';
import 'package:shreeji_dairy/widgets/app_appbar.dart';
import 'package:shreeji_dairy/widgets/app_button.dart';
import 'package:shreeji_dairy/widgets/app_card1.dart';
import 'package:shreeji_dairy/widgets/app_loading_overlay.dart';
import 'package:shreeji_dairy/widgets/app_text_form_field.dart';

class StoreOrderScreen extends StatefulWidget {
  const StoreOrderScreen({
    super.key,
    required this.pCode,
    required this.pName,
    required this.cCode,
    required this.branchCode,
    required this.deliDateOption,
  });

  final String pCode;
  final String pName;
  final String cCode;
  final String branchCode;
  final String deliDateOption;

  @override
  State<StoreOrderScreen> createState() => _StoreOrderScreenState();
}

class _StoreOrderScreenState extends State<StoreOrderScreen> {
  final StoreOrderController _controller = Get.put(
    StoreOrderController(),
  );
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  void _initialize() async {
    await _controller.getGroups(
      cCode: widget.cCode,
    );
    await _controller.getSubGroups(
      cCode: widget.cCode,
    );
    await _controller.getSubGroups2(
      cCode: widget.cCode,
    );
    await _controller.fetchStoreProducts(
      searchText: _controller.searchController.text,
    );
  }

  void showGroupFilter() {
    showFilterBottomSheet(
      title: 'Group',
      items: _controller.groups,
      selectedItems: _controller.selectedIgCodes,
      searchController: _controller.groupSearchController,
      displayField: (group) => group.igName,
      valueField: (group) => group.igCode,
      onApply: () {
        _controller.selectedIcCodes.clear();
        _controller.selectedIpackgCodes.clear();
        _controller.getSubGroups(
          cCode: widget.cCode,
        );
        _controller.getSubGroups2(
          cCode: widget.cCode,
        );
        _controller.fetchStoreProducts(
          searchText: _controller.searchController.text,
        );
      },
      onClear: () {
        _controller.selectedIgCodes.clear();
        _controller.getSubGroups(
          cCode: widget.cCode,
        );
        _controller.getSubGroups2(
          cCode: widget.cCode,
        );
        _controller.fetchStoreProducts(
          searchText: _controller.searchController.text,
        );
      },
    );
  }

  void showSubGroupFilter() {
    showFilterBottomSheet(
      title: 'Sub Group',
      items: _controller.subGroups,
      selectedItems: _controller.selectedIcCodes,
      searchController: _controller.subGroupSearchController,
      displayField: (subGroup) => subGroup.icName,
      valueField: (subGroup) => subGroup.icCode,
      onApply: () {
        _controller.selectedIpackgCodes.clear();

        _controller.getSubGroups2(
          cCode: widget.cCode,
        );

        _controller.fetchStoreProducts(
          searchText: _controller.searchController.text,
        );
      },
      onClear: () {
        _controller.selectedIcCodes.clear();
        _controller.getSubGroups2(
          cCode: widget.cCode,
        );
        _controller.fetchStoreProducts(
          searchText: _controller.searchController.text,
        );
      },
    );
  }

  void showSubGroup2Filter() {
    showFilterBottomSheet(
      title: 'Sub Group 2',
      items: _controller.subGroups2,
      selectedItems: _controller.selectedIpackgCodes,
      searchController: _controller.subGroup2SearchController,
      displayField: (subGroup2) => subGroup2.ipackgName,
      valueField: (subGroup2) => subGroup2.ipackgCode,
      onApply: () {
        _controller.fetchStoreProducts(
          searchText: _controller.searchController.text,
        );
      },
      onClear: () {
        _controller.selectedIpackgCodes.clear();
        _controller.fetchStoreProducts(
          searchText: _controller.searchController.text,
        );
      },
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
              title: 'Store Order',
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppTextFormField(
                    controller: _controller.searchController,
                    hintText: 'Search',
                    onChanged: (value) {
                      _controller.fetchStoreProducts(
                        searchText: value,
                      );
                    },
                  ),
                  AppSpaces.v10,
                  Obx(
                    () {
                      final List<Map<String, dynamic>> filters = [
                        {
                          "label": "Group",
                          "selectedCodes": _controller.selectedIgCodes,
                          "onSelected": () => showGroupFilter(),
                        },
                        {
                          "label": "Sub Group",
                          "selectedCodes": _controller.selectedIcCodes,
                          "onSelected": () => showSubGroupFilter(),
                        },
                        {
                          "label": "Sub Group 2",
                          "selectedCodes": _controller.selectedIpackgCodes,
                          "onSelected": () => showSubGroup2Filter(),
                        },
                      ];

                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: FilterChip(
                                avatar: Icon(
                                  Icons.history,
                                  size: 18,
                                  color: kColorTextPrimary,
                                ),
                                label: Text(
                                  'Recent Orders',
                                  style: TextStyles.kRegularFredoka(
                                      fontSize: FontSizes.k12FontSize,
                                      color: kColorTextPrimary),
                                ),
                                selected: _controller.suggestedProducts.value,
                                selectedColor: kColorPrimary,
                                backgroundColor: kColorWhite,
                                showCheckmark: false,
                                onSelected: (selected) {
                                  _controller.suggestedProducts.toggle();
                                  _controller.fetchStoreProducts(
                                    searchText:
                                        _controller.searchController.text,
                                  );
                                },
                              ),
                            ),
                            // MY ORDERS chip
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: ChoiceChip(
                                label: Text(
                                  'My Cart',
                                  style: TextStyles.kRegularFredoka(
                                    fontSize: FontSizes.k12FontSize,
                                    color: kColorTextPrimary,
                                  ),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                showCheckmark: false,
                                backgroundColor: kColorWhite,
                                selectedColor: kColorPrimary,
                                selected: _controller.isCartFilterActive.value,
                                onSelected: (selected) {
                                  _controller.toggleCartFilter();
                                },
                              ),
                            ),

                            // PACKING chip
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: ChoiceChip(
                                label: Text(
                                  'Packing',
                                  style: TextStyles.kRegularFredoka(
                                    fontSize: FontSizes.k12FontSize,
                                    color: kColorTextPrimary,
                                  ),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                showCheckmark: false,
                                backgroundColor: kColorWhite,
                                selectedColor: kColorPrimary,
                                selected: _controller.isPackingItem.value,
                                onSelected: (selected) {
                                  _controller.showPackingItem();
                                },
                              ),
                            ),

                            // Dynamic filter chips (Group, Sub Group, Sub Group 2)
                            ...filters.map(
                              (filter) {
                                final selectedCodes =
                                    filter["selectedCodes"] as RxSet<String>;
                                final isSelected = selectedCodes.isNotEmpty;

                                return Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: ChoiceChip(
                                    label: Text(
                                      filter["label"],
                                      style: TextStyles.kRegularFredoka(
                                        fontSize: FontSizes.k12FontSize,
                                        color: isSelected
                                            ? kColorWhite
                                            : kColorTextPrimary,
                                      ),
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    showCheckmark: false,
                                    backgroundColor: kColorWhite,
                                    selectedColor: kColorSecondary,
                                    selected: isSelected,
                                    onSelected: (_) => filter["onSelected"](),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  AppSpaces.v10,
                  Obx(
                    () {
                      if (_controller.storeProducts.isEmpty &&
                          !_controller.isLoading.value) {
                        return Expanded(
                          child: Center(
                            child: Text(
                              'No products found.',
                              style: TextStyles.kRegularFredoka(),
                            ),
                          ),
                        );
                      }
                      return Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: _controller.storeProducts.length,
                          itemBuilder: (context, index) {
                            final category = _controller.storeProducts[index];

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  category.icname,
                                  style: TextStyles.kMediumFredoka(
                                    color: kColorSecondary,
                                  ),
                                ),
                                AppSpaces.v10,
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: category.products.length,
                                  itemBuilder: (context, index) {
                                    final product = category.products[index];
                                    final controller = _controller
                                        .productControllers[product.icode];
                                    return AppCard1(
                                      child: Padding(
                                        padding: AppPaddings.p10,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(
                                              width: 0.5.screenWidth,
                                              child: Text(
                                                product.printname,
                                                style:
                                                    TextStyles.kRegularFredoka(
                                                  fontSize:
                                                      FontSizes.k16FontSize,
                                                  color: kColorTextPrimary,
                                                ).copyWith(
                                                  height: 1.25,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 0.3.screenWidth,
                                              child: AppTextFormField(
                                                controller: controller!,
                                                hintText: 'Qty',
                                                fontSize: FontSizes.k18FontSize,
                                                fontWeight: FontWeight.w600,
                                                enabled:
                                                    product.oldIcode.isNotEmpty,
                                                keyboardType:
                                                    TextInputType.number,
                                                onChanged: (value) {
                                                  if (_debounce?.isActive ??
                                                      false) {
                                                    _debounce!.cancel();
                                                  }

                                                  // Start a new timer
                                                  _debounce = Timer(
                                                    Duration(
                                                      milliseconds: 500,
                                                    ),
                                                    () {
                                                      _controller
                                                          .addOrUpdateCart(
                                                        iCode: product.icode,
                                                        oldIcode:
                                                            product.oldIcode,
                                                      );
                                                    },
                                                  );
                                                },
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                AppSpaces.v10,
                              ],
                            );
                          },
                        ),
                      );
                    },
                  ),
                  AppButton(
                    buttonColor: kColorPrimary,
                    title: 'Place Order',
                    titleColor: kColorTextPrimary,
                    onPressed: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                      Get.to(
                        () => PlaceStoreOrderScreen(
                          pCode: widget.pCode,
                          pName: widget.pName,
                          cCode: widget.cCode,
                          branchCode: widget.branchCode,
                          deliDateOption: widget.deliDateOption,
                        ),
                      );
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
