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

  @override
  void initState() {
    _controller.searchProduct(
      pCode: widget.pCode,
      searchText: _controller.searchController.text,
    );
    super.initState();
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
              padding: AppPaddings.p14,
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
                    () {
                      if (_controller.products.isEmpty) {
                        return Center(
                          child: Text(
                            'No products found',
                            style: TextStyles.kMediumFredoka(
                              color: kColorTextPrimary,
                            ),
                          ),
                        );
                      }

                      return Expanded(
                        child: ListView.builder(
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
                                            height: 50.appHeight,
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
                                                                                await _controller.addOrUpdateCart(
                                                                                  pCode: widget.pCode,
                                                                                  iCode: sku.skuIcode,
                                                                                  qty: sku.cartQty + 1,
                                                                                  rate: sku.rate,
                                                                                );

                                                                                await _controller.searchProduct(
                                                                                  pCode: widget.pCode,
                                                                                  searchText: _controller.searchController.text,
                                                                                );
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
                                                                                  await _controller.addOrUpdateCart(
                                                                                    pCode: widget.pCode,
                                                                                    iCode: sku.skuIcode,
                                                                                    qty: sku.cartQty + 1,
                                                                                    rate: sku.rate,
                                                                                  );

                                                                                  await _controller.searchProduct(
                                                                                    pCode: widget.pCode,
                                                                                    searchText: _controller.searchController.text,
                                                                                  );
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
