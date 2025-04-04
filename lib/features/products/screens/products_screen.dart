import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shreeji_dairy/constants/color_constants.dart';
import 'package:shreeji_dairy/constants/image_constants.dart';
import 'package:shreeji_dairy/features/cart/screens/cart_screen.dart';
import 'package:shreeji_dairy/features/products/controllers/products_controller.dart';
import 'package:shreeji_dairy/features/products/widgets/product_card.dart';
import 'package:shreeji_dairy/features/products/widgets/products_filter_bottom_sheet.dart';
import 'package:shreeji_dairy/styles/font_sizes.dart';
import 'package:shreeji_dairy/styles/text_styles.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_paddings.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_spacings.dart';
import 'package:shreeji_dairy/widgets/app_appbar.dart';
import 'package:shreeji_dairy/widgets/app_loading_overlay.dart';
import 'package:shreeji_dairy/widgets/app_text_form_field.dart';
import 'package:badges/badges.dart' as badges;

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({
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
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final ProductsController _controller = Get.put(
    ProductsController(),
  );

  final ScrollController _scrollController = ScrollController();

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
    await _controller.searchProduct(
      pCode: widget.pCode,
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
        _controller.searchProduct(
          searchText: _controller.searchController.text,
          pCode: widget.pCode,
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
        _controller.searchProduct(
          searchText: _controller.searchController.text,
          pCode: widget.pCode,
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
        _controller.searchProduct(
          searchText: _controller.searchController.text,
          pCode: widget.pCode,
        );
      },
      onClear: () {
        _controller.selectedIcCodes.clear();
        _controller.getSubGroups2(
          cCode: widget.cCode,
        );
        _controller.searchProduct(
          searchText: _controller.searchController.text,
          pCode: widget.pCode,
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
        _controller.searchProduct(
          searchText: _controller.searchController.text,
          pCode: widget.pCode,
        );
      },
      onClear: () {
        _controller.selectedIpackgCodes.clear();
        _controller.searchProduct(
          searchText: _controller.searchController.text,
          pCode: widget.pCode,
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
              title: 'Products',
              subtitle: widget.pName,
              actions: [
                Obx(
                  () {
                    return Padding(
                      padding: AppPaddings.ph6,
                      child: GestureDetector(
                        onTap: () {
                          Get.to(
                            () => CartScreen(
                              cCode: widget.cCode,
                              pCode: widget.pCode,
                              pName: widget.pName,
                              branchCode: widget.branchCode,
                              deliDateOption: widget.deliDateOption,
                            ),
                          );
                        },
                        child: _controller.cartCount.value == 0
                            ? IconButton(
                                onPressed: () {
                                  Get.to(
                                    () => CartScreen(
                                      cCode: widget.cCode,
                                      pCode: widget.pCode,
                                      pName: widget.pName,
                                      branchCode: widget.branchCode,
                                      deliDateOption: widget.deliDateOption,
                                    ),
                                  );
                                },
                                icon: SvgPicture.asset(
                                  kIconShoppingCart,
                                  height: 20,
                                  colorFilter: ColorFilter.mode(
                                    kColorTextPrimary,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              )
                            : badges.Badge(
                                badgeContent: Text(
                                  '${_controller.cartCount.value}',
                                  style: TextStyles.kMediumFredoka(
                                    fontSize: FontSizes.k12FontSize,
                                    color: kColorWhite,
                                  ),
                                ),
                                badgeStyle: badges.BadgeStyle(
                                  badgeColor: kColorTextPrimary,
                                  padding: AppPaddings.p6,
                                ),
                                badgeAnimation: badges.BadgeAnimation.scale(),
                                position: badges.BadgePosition.topEnd(
                                  top: 0,
                                  end: 0,
                                ),
                                child: IconButton(
                                  onPressed: () {
                                    Get.to(
                                      () => CartScreen(
                                        cCode: widget.cCode,
                                        pCode: widget.pCode,
                                        pName: widget.pName,
                                        branchCode: widget.branchCode,
                                        deliDateOption: widget.deliDateOption,
                                      ),
                                    );
                                  },
                                  icon: SvgPicture.asset(
                                    kIconShoppingCart,
                                    height: 20,
                                    colorFilter: ColorFilter.mode(
                                      kColorTextPrimary,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ),
                              ),
                      ),
                    );
                  },
                ),
              ],
            ),
            body: Padding(
              padding: AppPaddings.p12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppTextFormField(
                    controller: _controller.searchController,
                    hintText: 'Search Product',
                    suffixIcon: IconButton(
                      onPressed: () {
                        _controller.searchController.clear();
                        _controller.searchProduct(
                          pCode: widget.pCode,
                          searchText: _controller.searchController.text,
                        );
                      },
                      icon: Icon(
                        Icons.clear,
                        size: 20,
                        color: kColorGrey,
                      ),
                    ),
                    onChanged: (value) {
                      _controller.searchProduct(
                        searchText: value,
                        pCode: widget.pCode,
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

                      return Wrap(
                        spacing: 8.0,
                        children: filters.map(
                          (filter) {
                            return ChoiceChip(
                              label: Text(
                                filter["label"],
                                style: TextStyles.kRegularFredoka(
                                  fontSize: FontSizes.k12FontSize,
                                  color:
                                      (filter["selectedCodes"] as RxSet<String>)
                                              .isNotEmpty
                                          ? kColorWhite
                                          : kColorTextPrimary,
                                ),
                              ),
                              showCheckmark: false,
                              backgroundColor: kColorWhite,
                              selectedColor: kColorSecondary,
                              selected:
                                  (filter["selectedCodes"] as RxSet<String>)
                                      .isNotEmpty,
                              onSelected: (selected) {
                                filter["onSelected"]();
                              },
                            );
                          },
                        ).toList(),
                      );
                    },
                  ),
                  AppSpaces.v10,
                  Obx(
                    () {
                      if (_controller.isLoading.value) {
                        return const SizedBox.shrink();
                      }
                      if (_controller.products.isEmpty &&
                          _controller.isLoading.value == false) {
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
                          controller: _scrollController,
                          shrinkWrap: true,
                          itemCount: _controller.products.length,
                          itemBuilder: (context, index) {
                            final product = _controller.products[index];

                            return ProductCard(
                              product: product,
                              scrollController: _scrollController,
                              controller: _controller,
                              widget: widget,
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
