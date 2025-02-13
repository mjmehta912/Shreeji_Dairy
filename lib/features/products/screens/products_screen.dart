import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shreeji_dairy/constants/color_constants.dart';
import 'package:shreeji_dairy/constants/image_constants.dart';
import 'package:shreeji_dairy/features/cart/screens/cart_screen.dart';
import 'package:shreeji_dairy/features/products/controllers/products_controller.dart';
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
import 'package:badges/badges.dart' as badges;

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({
    super.key,
    required this.pCode,
    required this.pName,
  });

  final String pCode;
  final String pName;

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
    _controller.getGroups();
    _controller.getSubGroups();
    _controller.getSubGroups2();
    _controller.searchProduct(
      pCode: widget.pCode,
      searchText: _controller.searchController.text,
    );
    super.initState();
  }

  void showGroupFilter() {
    final RxSet<String> tempSelectedIgCodes =
        _controller.selectedIgCodes.toSet().obs;
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
          maxHeight: 0.5.screenHeight,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Group',
              style: TextStyles.kRegularFredoka(
                fontSize: FontSizes.k20FontSize,
                color: kColorTextPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            AppSpaces.v10,
            AppTextFormField(
              controller: _controller.groupSearchController,
              hintText: 'Search Group',
              onChanged: (value) {
                searchQuery.value = value.toLowerCase();
              },
            ),
            AppSpaces.v10,
            Expanded(
              child: Obx(
                () {
                  final sortedGroups = _controller.groups
                      .where(
                        (group) => group.igName
                            .toLowerCase()
                            .contains(searchQuery.value),
                      )
                      .toList()
                    ..sort(
                      (a, b) {
                        bool aSelected = tempSelectedIgCodes.contains(a.igCode);
                        bool bSelected = tempSelectedIgCodes.contains(b.igCode);
                        return (bSelected ? 1 : 0).compareTo(aSelected ? 1 : 0);
                      },
                    );

                  return ListView(
                    shrinkWrap: true,
                    children: sortedGroups.map(
                      (group) {
                        return CheckboxListTile(
                          title: Text(
                            group.igName,
                            style: TextStyles.kRegularFredoka(
                              fontSize: FontSizes.k16FontSize,
                              color: kColorTextPrimary,
                            ),
                          ),
                          contentPadding: EdgeInsets.zero,
                          value: tempSelectedIgCodes.contains(group.igCode),
                          activeColor: kColorSecondary,
                          onChanged: (isSelected) {
                            if (isSelected == true) {
                              tempSelectedIgCodes.add(group.igCode);
                            } else {
                              tempSelectedIgCodes.remove(group.igCode);
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
                AppButton(
                  buttonWidth: 0.3.screenWidth,
                  buttonHeight: 40,
                  buttonColor: kColorGrey,
                  titleColor: kColorTextPrimary,
                  titleSize: FontSizes.k16FontSize,
                  onPressed: () {
                    _controller.selectedIgCodes.clear();
                    _controller.searchProduct(
                      searchText: _controller.searchController.text,
                      pCode: widget.pCode,
                    );
                    Get.back();
                  },
                  title: 'Clear Filter',
                ),
                AppButton(
                  buttonWidth: 0.5.screenWidth,
                  buttonHeight: 40,
                  buttonColor: kColorPrimary,
                  titleColor: kColorTextPrimary,
                  titleSize: FontSizes.k16FontSize,
                  onPressed: () {
                    _controller.selectedIgCodes
                      ..clear()
                      ..addAll(tempSelectedIgCodes);
                    _controller.searchProduct(
                      searchText: _controller.searchController.text,
                      pCode: widget.pCode,
                    );
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

  void showSubGroupFilter() {
    final RxSet<String> tempSelectedIcCodes =
        _controller.selectedIcCodes.toSet().obs;
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
        constraints: BoxConstraints(maxHeight: 0.5.screenHeight),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Sub Group',
              style: TextStyles.kRegularFredoka(
                fontSize: FontSizes.k20FontSize,
                color: kColorTextPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            AppSpaces.v10,
            AppTextFormField(
              controller: _controller.subGroupSearchController,
              hintText: 'Search Subgroup',
              onChanged: (value) {
                searchQuery.value = value.toLowerCase();
              },
            ),
            AppSpaces.v10,
            Expanded(
              child: Obx(
                () {
                  final sortedSubGroups = _controller.subGroups
                      .where(
                        (subGroup) => subGroup.icName
                            .toLowerCase()
                            .contains(searchQuery.value),
                      )
                      .toList()
                    ..sort(
                      (a, b) {
                        bool aSelected = tempSelectedIcCodes.contains(a.icCode);
                        bool bSelected = tempSelectedIcCodes.contains(b.icCode);
                        return (bSelected ? 1 : 0).compareTo(aSelected ? 1 : 0);
                      },
                    );

                  return ListView(
                    shrinkWrap: true,
                    children: sortedSubGroups.map(
                      (subGroup) {
                        return CheckboxListTile(
                          title: Text(
                            subGroup.icName,
                            style: TextStyles.kRegularFredoka(
                              fontSize: FontSizes.k16FontSize,
                              color: kColorTextPrimary,
                            ),
                          ),
                          contentPadding: EdgeInsets.zero,
                          value: tempSelectedIcCodes.contains(subGroup.icCode),
                          activeColor: kColorSecondary,
                          onChanged: (isSelected) {
                            if (isSelected == true) {
                              tempSelectedIcCodes.add(subGroup.icCode);
                            } else {
                              tempSelectedIcCodes.remove(subGroup.icCode);
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
                AppButton(
                  buttonWidth: 0.3.screenWidth,
                  buttonHeight: 40,
                  buttonColor: kColorGrey,
                  titleColor: kColorTextPrimary,
                  titleSize: FontSizes.k16FontSize,
                  onPressed: () {
                    _controller.selectedIcCodes.clear();
                    _controller.searchProduct(
                      searchText: _controller.searchController.text,
                      pCode: widget.pCode,
                    );
                    Get.back();
                  },
                  title: 'Clear Filter',
                ),
                AppButton(
                  buttonWidth: 0.5.screenWidth,
                  buttonHeight: 40,
                  buttonColor: kColorPrimary,
                  titleColor: kColorTextPrimary,
                  titleSize: FontSizes.k16FontSize,
                  onPressed: () {
                    _controller.selectedIcCodes
                      ..clear()
                      ..addAll(tempSelectedIcCodes);
                    _controller.searchProduct(
                      searchText: _controller.searchController.text,
                      pCode: widget.pCode,
                    );
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

  void showSubGroup2Filter() {
    final RxSet<String> tempSelectedIpackgCodes =
        _controller.selectedIpackgCodes.toSet().obs;
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
          maxHeight: 0.5.screenHeight,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Sub Group 2',
              style: TextStyles.kRegularFredoka(
                fontSize: FontSizes.k20FontSize,
                color: kColorTextPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            AppSpaces.v10,
            AppTextFormField(
              controller: _controller.subGroup2SearchController,
              hintText: 'Search Subgroup 2',
              onChanged: (value) {
                searchQuery.value = value.toLowerCase();
              },
            ),
            AppSpaces.v10,
            Expanded(
              child: Obx(
                () {
                  final sortedSubGroups2 = _controller.subGroups2
                      .where(
                        (subGroup2) => subGroup2.ipackgName
                            .toLowerCase()
                            .contains(searchQuery.value),
                      )
                      .toList()
                    ..sort(
                      (a, b) {
                        bool aSelected =
                            tempSelectedIpackgCodes.contains(a.ipackgCode);
                        bool bSelected =
                            tempSelectedIpackgCodes.contains(b.ipackgCode);
                        return (bSelected ? 1 : 0).compareTo(aSelected ? 1 : 0);
                      },
                    );

                  return ListView(
                    shrinkWrap: true,
                    children: sortedSubGroups2.map(
                      (subGroup2) {
                        return CheckboxListTile(
                          title: Text(
                            subGroup2.ipackgName,
                            style: TextStyles.kRegularFredoka(
                              fontSize: FontSizes.k16FontSize,
                              color: kColorTextPrimary,
                            ),
                          ),
                          contentPadding: EdgeInsets.zero,
                          value: tempSelectedIpackgCodes
                              .contains(subGroup2.ipackgCode),
                          activeColor: kColorSecondary,
                          onChanged: (isSelected) {
                            if (isSelected == true) {
                              tempSelectedIpackgCodes.add(subGroup2.ipackgCode);
                            } else {
                              tempSelectedIpackgCodes
                                  .remove(subGroup2.ipackgCode);
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
                AppButton(
                  buttonWidth: 0.3.screenWidth,
                  buttonHeight: 40,
                  buttonColor: kColorGrey,
                  titleColor: kColorTextPrimary,
                  titleSize: FontSizes.k16FontSize,
                  onPressed: () {
                    _controller.selectedIpackgCodes.clear();
                    _controller.searchProduct(
                      searchText: _controller.searchController.text,
                      pCode: widget.pCode,
                    );
                    Get.back();
                  },
                  title: 'Clear Filter',
                ),
                AppButton(
                  buttonWidth: 0.5.screenWidth,
                  buttonHeight: 40,
                  buttonColor: kColorPrimary,
                  titleColor: kColorTextPrimary,
                  titleSize: FontSizes.k16FontSize,
                  onPressed: () {
                    _controller.selectedIpackgCodes
                      ..clear()
                      ..addAll(tempSelectedIpackgCodes);
                    _controller.searchProduct(
                      searchText: _controller.searchController.text,
                      pCode: widget.pCode,
                    );
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
                              pCode: widget.pCode,
                              pName: widget.pName,
                            ),
                          );
                        },
                        child: _controller.cartCount.value == 0
                            ? IconButton(
                                onPressed: () {
                                  Get.to(
                                    () => CartScreen(
                                      pCode: widget.pCode,
                                      pName: widget.pName,
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
                                        pCode: widget.pCode,
                                        pName: widget.pName,
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
              padding: AppPaddings.p16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppTextFormField(
                    controller: _controller.searchController,
                    hintText: 'Search Product',
                    onChanged: (value) {
                      _controller.searchProduct(
                        searchText: value,
                        pCode: widget.pCode,
                      );
                    },
                  ),
                  AppSpaces.v10,
                  Obx(
                    () => Wrap(
                      spacing: 8.0,
                      children: [
                        ChoiceChip(
                          label: Text(
                            'Group',
                            style: TextStyles.kRegularFredoka(
                              fontSize: FontSizes.k12FontSize,
                              color: _controller.selectedIgCodes.isNotEmpty
                                  ? kColorWhite
                                  : kColorTextPrimary,
                            ),
                          ),
                          showCheckmark: false,
                          backgroundColor: kColorWhite,
                          selectedColor: kColorSecondary,
                          selected: _controller.selectedIgCodes.isNotEmpty,
                          onSelected: (selected) {
                            showGroupFilter();
                          },
                        ),
                        ChoiceChip(
                          label: Text(
                            'Sub Group',
                            style: TextStyles.kRegularFredoka(
                              fontSize: FontSizes.k12FontSize,
                              color: _controller.selectedIcCodes.isNotEmpty
                                  ? kColorWhite
                                  : kColorTextPrimary,
                            ),
                          ),
                          showCheckmark: false,
                          backgroundColor: kColorWhite,
                          selectedColor: kColorSecondary,
                          selected: _controller.selectedIcCodes.isNotEmpty,
                          onSelected: (selected) {
                            showSubGroupFilter();
                          },
                        ),
                        ChoiceChip(
                          label: Text(
                            'Sub Group 2',
                            style: TextStyles.kRegularFredoka(
                              fontSize: FontSizes.k12FontSize,
                              color: _controller.selectedIpackgCodes.isNotEmpty
                                  ? kColorWhite
                                  : kColorTextPrimary,
                            ),
                          ),
                          showCheckmark: false,
                          backgroundColor: kColorWhite,
                          selectedColor: kColorSecondary,
                          selected: _controller.selectedIpackgCodes.isNotEmpty,
                          onSelected: (selected) {
                            showSubGroup2Filter();
                          },
                        ),
                      ],
                    ),
                  ),
                  AppSpaces.v10,
                  Obx(
                    () {
                      if (_controller.isLoading.value) {
                        return const SizedBox.shrink();
                      }
                      if (_controller.products.isEmpty &&
                          !_controller.isLoading.value) {
                        return Expanded(
                          child: Center(
                            child: Text(
                              'No products found',
                              style: TextStyles.kMediumFredoka(
                                color: kColorTextPrimary,
                              ),
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

                            return AppCard1(
                              child: Padding(
                                padding: AppPaddings.p10,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Card(
                                          color: kColorWhite,
                                          clipBehavior: Clip.antiAlias,
                                          child: Image.asset(
                                            kImageMAndM,
                                            height: 75.appHeight,
                                          ),
                                        ),
                                        AppSpaces.h10,
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                product.printName,
                                                style:
                                                    TextStyles.kMediumFredoka(
                                                  color: kColorTextPrimary,
                                                  fontSize:
                                                      FontSizes.k18FontSize,
                                                ).copyWith(
                                                  height: 1,
                                                ),
                                              ),
                                              AppSpaces.v10,
                                              SingleChildScrollView(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                child: Row(
                                                  children: product.skus.isEmpty
                                                      ? [
                                                          Text(
                                                            'No packaging available',
                                                            style: TextStyles
                                                                .kMediumFredoka(
                                                              color:
                                                                  kColorTextPrimary,
                                                              fontSize: FontSizes
                                                                  .k14FontSize,
                                                            ),
                                                          )
                                                        ]
                                                      : product.skus.map(
                                                          (sku) {
                                                            return AppCard1(
                                                              child: Padding(
                                                                padding:
                                                                    AppPaddings
                                                                        .combined(
                                                                  horizontal: 10
                                                                      .appWidth,
                                                                  vertical: 5
                                                                      .appHeight,
                                                                ),
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Text(
                                                                      sku.pack,
                                                                      style: TextStyles
                                                                          .kMediumFredoka(
                                                                        fontSize:
                                                                            FontSizes.k14FontSize,
                                                                      ).copyWith(
                                                                        height:
                                                                            1,
                                                                      ),
                                                                    ),
                                                                    AppSpaces
                                                                        .v4,
                                                                    Text(
                                                                      '₹ ${sku.rate}',
                                                                      style: TextStyles
                                                                          .kRegularFredoka(
                                                                        fontSize:
                                                                            FontSizes.k14FontSize,
                                                                      ).copyWith(
                                                                        height:
                                                                            1,
                                                                      ),
                                                                    ),
                                                                    AppSpaces
                                                                        .v4,
                                                                    sku.cartQty ==
                                                                            0
                                                                        ? SizedBox(
                                                                            width:
                                                                                0.2.screenWidth,
                                                                            height:
                                                                                30,
                                                                            child:
                                                                                AppButton(
                                                                              onPressed: () async {
                                                                                double offset = _scrollController.hasClients ? _scrollController.offset : 0.0;

                                                                                await _controller.addOrUpdateCart(
                                                                                  pCode: widget.pCode,
                                                                                  iCode: sku.skuIcode,
                                                                                  qty: sku.cartQty + 1, // or -1 for remove
                                                                                  rate: sku.rate,
                                                                                );

                                                                                await _controller.searchProduct(
                                                                                  pCode: widget.pCode,
                                                                                  searchText: _controller.searchController.text,
                                                                                );

                                                                                // ✅ Restore scroll position after UI updates
                                                                                WidgetsBinding.instance.addPostFrameCallback((_) {
                                                                                  if (_scrollController.hasClients) {
                                                                                    _scrollController.jumpTo(offset);
                                                                                  }
                                                                                });
                                                                              },
                                                                              title: 'Add +',
                                                                              titleSize: FontSizes.k14FontSize,
                                                                              buttonColor: kColorWhite,
                                                                              borderColor: kColorSecondary,
                                                                              titleColor: kColorSecondary,
                                                                            ),
                                                                          )
                                                                        : Row(
                                                                            children: [
                                                                              InkWell(
                                                                                onTap: () async {
                                                                                  double offset = _scrollController.hasClients ? _scrollController.offset : 0.0;

                                                                                  await _controller.addOrUpdateCart(
                                                                                    pCode: widget.pCode,
                                                                                    iCode: sku.skuIcode,
                                                                                    qty: sku.cartQty == 1 ? 0 : sku.cartQty - 1,
                                                                                    rate: sku.rate,
                                                                                  );

                                                                                  await _controller.searchProduct(
                                                                                    pCode: widget.pCode,
                                                                                    searchText: _controller.searchController.text,
                                                                                  );

                                                                                  // ✅ Restore scroll position after UI updates
                                                                                  WidgetsBinding.instance.addPostFrameCallback((_) {
                                                                                    if (_scrollController.hasClients) {
                                                                                      _scrollController.jumpTo(offset);
                                                                                    }
                                                                                  });
                                                                                },
                                                                                child: const Icon(
                                                                                  Icons.remove,
                                                                                  color: kColorSecondary,
                                                                                  size: 20,
                                                                                ),
                                                                              ),
                                                                              AppSpaces.h10,
                                                                              Text(
                                                                                '${sku.cartQty}',
                                                                                style: TextStyles.kMediumFredoka(
                                                                                  fontSize: FontSizes.k16FontSize,
                                                                                  color: kColorTextPrimary,
                                                                                ),
                                                                              ),
                                                                              AppSpaces.h10,
                                                                              InkWell(
                                                                                onTap: () async {
                                                                                  double offset = _scrollController.hasClients ? _scrollController.offset : 0.0;

                                                                                  await _controller.addOrUpdateCart(
                                                                                    pCode: widget.pCode,
                                                                                    iCode: sku.skuIcode,
                                                                                    qty: sku.cartQty + 1, // or -1 for remove
                                                                                    rate: sku.rate,
                                                                                  );

                                                                                  await _controller.searchProduct(
                                                                                    pCode: widget.pCode,
                                                                                    searchText: _controller.searchController.text,
                                                                                  );

                                                                                  // ✅ Restore scroll position after UI updates
                                                                                  WidgetsBinding.instance.addPostFrameCallback((_) {
                                                                                    if (_scrollController.hasClients) {
                                                                                      _scrollController.jumpTo(offset);
                                                                                    }
                                                                                  });
                                                                                },
                                                                                child: const Icon(
                                                                                  Icons.add,
                                                                                  color: kColorSecondary,
                                                                                  size: 20,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                  ],
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        ).toList(),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
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
