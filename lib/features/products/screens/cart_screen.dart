import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreeji_dairy/constants/color_constants.dart';
import 'package:shreeji_dairy/features/products/controllers/products_controller.dart';
import 'package:shreeji_dairy/features/products/models/cart.dart';
import 'package:shreeji_dairy/styles/font_sizes.dart';
import 'package:shreeji_dairy/styles/text_styles.dart';
import 'package:shreeji_dairy/utils/dialogs/app_dialogs.dart';
import 'package:shreeji_dairy/utils/extensions/app_size_extensions.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_paddings.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_spacings.dart';
import 'package:shreeji_dairy/widgets/app_appbar.dart';
import 'package:shreeji_dairy/widgets/app_button.dart';

class CartScreen extends StatelessWidget {
  final ProductsController _controller = Get.find<ProductsController>();

  CartScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kColorWhite,
      appBar: AppAppbar(
        title: 'Your bag',
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(
            Icons.arrow_back_ios,
            size: 20,
          ),
        ),
      ),
      body: Obx(
        () {
          if (_controller.cartItems.isEmpty) {
            return Center(
              child: Text(
                'Your cart is empty',
                style: TextStyles.kRegularFredoka(),
              ),
            );
          }

          final groupedProducts = <String, List<CartItem>>{};

          for (var cartItem in _controller.cartItems) {
            if (!groupedProducts.containsKey(cartItem.product.name)) {
              groupedProducts[cartItem.product.name] = [];
            }
            groupedProducts[cartItem.product.name]!.add(cartItem);
          }

          return Padding(
            padding: AppPaddings.p14,
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: groupedProducts.length,
                    itemBuilder: (context, index) {
                      final productName = groupedProducts.keys.elementAt(index);
                      final cartItemsForProduct = groupedProducts[productName]!;

                      return Card(
                        elevation: 2.5,
                        color: kColorWhite,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(
                            color: kColorBlack,
                          ),
                        ),
                        child: Padding(
                          padding: AppPaddings.combined(
                            horizontal: 10.appWidth,
                            vertical: 5.appHeight,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Card(
                                    color: kColorWhite,
                                    clipBehavior: Clip.antiAlias,
                                    child: Image.asset(
                                      cartItemsForProduct[0].product.image,
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
                                          productName,
                                          style: TextStyles.kMediumFredoka(
                                            fontSize: FontSizes.k18FontSize,
                                          ).copyWith(
                                            height: 1,
                                          ),
                                        ),
                                        AppSpaces.v10,
                                        SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            children: cartItemsForProduct
                                                .map(
                                                  (cartItem) => Card(
                                                    color: kColorWhite,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      side: BorderSide(
                                                        color:
                                                            kColorTextPrimary,
                                                      ),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          AppPaddings.combined(
                                                        horizontal: 10,
                                                        vertical: 5,
                                                      ),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            cartItem.sku.size,
                                                            style: TextStyles
                                                                .kMediumFredoka(
                                                              fontSize: FontSizes
                                                                  .k14FontSize,
                                                            ).copyWith(
                                                              height: 1,
                                                            ),
                                                          ),
                                                          AppSpaces.v4,
                                                          Text(
                                                            '₹ ${cartItem.sku.rate}',
                                                            style: TextStyles
                                                                .kRegularFredoka(
                                                              fontSize: FontSizes
                                                                  .k14FontSize,
                                                            ).copyWith(
                                                              height: 1,
                                                            ),
                                                          ),
                                                          AppSpaces.v4,
                                                          Obx(
                                                            () => Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                InkWell(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                  child: Icon(
                                                                    Icons
                                                                        .remove,
                                                                    color:
                                                                        kColorSecondary,
                                                                    size: 20,
                                                                  ),
                                                                  onTap: () {
                                                                    _controller
                                                                        .decrementCounter(
                                                                      cartItem
                                                                          .product,
                                                                      cartItem
                                                                          .sku,
                                                                    );
                                                                  },
                                                                ),
                                                                AppSpaces.h10,
                                                                Text(
                                                                  '${cartItem.sku.counter.value}',
                                                                  style: TextStyles
                                                                      .kMediumFredoka(
                                                                    fontSize:
                                                                        FontSizes
                                                                            .k16FontSize,
                                                                    color:
                                                                        kColorTextPrimary,
                                                                  ),
                                                                ),
                                                                AppSpaces.h10,
                                                                InkWell(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                  child: Icon(
                                                                    Icons.add,
                                                                    color:
                                                                        kColorSecondary,
                                                                    size: 20,
                                                                  ),
                                                                  onTap: () {
                                                                    _controller
                                                                        .incrementCounter(
                                                                      cartItem
                                                                          .product,
                                                                      cartItem
                                                                          .sku,
                                                                    );
                                                                  },
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                )
                                                .toList(),
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
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(
                      () {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total Amount',
                              style: TextStyles.kRegularFredoka(
                                fontSize: FontSizes.k18FontSize,
                              ),
                            ),
                            Text(
                              '₹${_controller.totalPrice.value.toStringAsFixed(2)}',
                              style: TextStyles.kMediumFredoka(),
                            ),
                          ],
                        );
                      },
                    ),
                    AppButton(
                      buttonWidth: 0.45.screenWidth,
                      title: 'Place Order',
                      titleColor: kColorBlack,
                      buttonColor: kColorPrimary,
                      onPressed: () {
                        showSuccessSnackbar(
                          'Order Placed',
                          'Your order is placed successfully',
                        );
                      },
                    ),
                  ],
                ),
                AppSpaces.v10,
              ],
            ),
          );
        },
      ),
    );
  }
}
