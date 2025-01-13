import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreeji_dairy/constants/color_constants.dart';
import 'package:shreeji_dairy/constants/image_constants.dart';
import 'package:shreeji_dairy/features/cart/controllers/cart_controller.dart';
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

class CartScreen extends StatefulWidget {
  const CartScreen({
    super.key,
    required this.pCode,
    required this.pName,
  });

  final String pCode;
  final String pName;

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartController _controller = Get.put(
    CartController(),
  );

  final ProductsController productsController = Get.find<ProductsController>();

  @override
  void initState() {
    _controller.getCartProducts(
      pCode: widget.pCode,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: kColorWhite,
          appBar: AppAppbar(
            title: 'Cart',
            subtitle: widget.pName,
            leading: IconButton(
              onPressed: () => Get.back(),
              icon: Icon(
                Icons.arrow_back_ios,
                color: kColorTextPrimary,
                size: 20,
              ),
            ),
          ),
          body: Padding(
            padding: AppPaddings.p16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(
                  () {
                    if (_controller.isLoading.value) {
                      return SizedBox.shrink();
                    }

                    if (_controller.cartProducts.isEmpty &&
                        !_controller.isLoading.value) {
                      return Expanded(
                        child: Center(
                          child: Text(
                            'Please add a product to continue.',
                            style: TextStyles.kMediumFredoka(
                              color: kColorTextPrimary,
                            ),
                          ),
                        ),
                      );
                    }

                    return Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: _controller.cartProducts.length,
                        itemBuilder: (context, index) {
                          final product = _controller.cartProducts[index];

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
                                              style: TextStyles.kMediumFredoka(
                                                color: kColorTextPrimary,
                                                fontSize: FontSizes.k18FontSize,
                                              ).copyWith(
                                                height: 1,
                                              ),
                                            ),
                                            AppSpaces.v10,
                                            SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
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
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .end,
                                                              children: [
                                                                Padding(
                                                                  padding:
                                                                      AppPaddings
                                                                          .p2,
                                                                  child:
                                                                      InkWell(
                                                                    onTap: () {
                                                                      _controller
                                                                          .removeProduct(
                                                                        pCode: widget
                                                                            .pCode,
                                                                        iCode: sku
                                                                            .skuIcode,
                                                                      );
                                                                    },
                                                                    child: Icon(
                                                                      Icons
                                                                          .cancel_outlined,
                                                                      color:
                                                                          kColorTextPrimary,
                                                                      size: 20,
                                                                    ),
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      AppPaddings
                                                                          .ph10,
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      AppSpaces
                                                                          .v4,
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
                                                                              width: 0.2.screenWidth,
                                                                              height: 30,
                                                                              child: AppButton(
                                                                                onPressed: () async {
                                                                                  await _controller.addOrUpdateCart(
                                                                                    pCode: widget.pCode,
                                                                                    iCode: sku.skuIcode,
                                                                                    qty: sku.cartQty + 1,
                                                                                    rate: sku.rate,
                                                                                  );

                                                                                  await _controller.getCartProducts(
                                                                                    pCode: widget.pCode,
                                                                                  );

                                                                                  await productsController.searchProduct(
                                                                                    pCode: widget.pCode,
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

                                                                                    await _controller.getCartProducts(
                                                                                      pCode: widget.pCode,
                                                                                    );

                                                                                    await productsController.searchProduct(
                                                                                      pCode: widget.pCode,
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

                                                                                    await _controller.getCartProducts(
                                                                                      pCode: widget.pCode,
                                                                                    );

                                                                                    await productsController.searchProduct(
                                                                                      pCode: widget.pCode,
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
                                                                AppSpaces.v6
                                                              ],
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
                Obx(
                  () => _controller.cartProducts.isNotEmpty &&
                          !_controller.isLoading.value
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Amount',
                                  style: TextStyles.kRegularFredoka(
                                    color: kColorTextPrimary,
                                    fontSize: FontSizes.k18FontSize,
                                  ),
                                ),
                                Obx(
                                  () => Text(
                                    '₹ ${_controller.totalAmount.toStringAsFixed(2)}',
                                    style: TextStyles.kMediumFredoka(
                                      color: kColorTextPrimary,
                                      fontSize: FontSizes.k24FontSize,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            AppButton(
                              buttonWidth: 0.5.screenWidth,
                              title: 'Place Order',
                              titleColor: kColorTextPrimary,
                              buttonColor: kColorPrimary,
                              onPressed: () {
                                _controller.placeOrder(
                                  pCode: widget.pCode,
                                );
                              },
                            ),
                          ],
                        )
                      : const SizedBox.shrink(),
                ),
              ],
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
