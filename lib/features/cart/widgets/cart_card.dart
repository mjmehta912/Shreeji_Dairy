import 'package:flutter/material.dart';
import 'package:shreeji_dairy/constants/color_constants.dart';
import 'package:shreeji_dairy/features/cart/controllers/cart_controller.dart';
import 'package:shreeji_dairy/features/cart/models/cart_product_dm.dart';
import 'package:shreeji_dairy/features/cart/screens/cart_screen.dart';
import 'package:shreeji_dairy/features/products/controllers/products_controller.dart';
import 'package:shreeji_dairy/styles/font_sizes.dart';
import 'package:shreeji_dairy/styles/text_styles.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_paddings.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_spacings.dart';
import 'package:shreeji_dairy/widgets/app_card1.dart';

class CardCard extends StatelessWidget {
  const CardCard({
    super.key,
    required this.product,
    required CartController controller,
    required this.widget,
    required ScrollController scrollController,
    required this.productsController,
  })  : _controller = controller,
        _scrollController = scrollController;

  final CartProductDm product;
  final CartController _controller;
  final CartScreen widget;
  final ScrollController _scrollController;
  final ProductsController productsController;

  @override
  Widget build(BuildContext context) {
    return AppCard1(
      child: Padding(
        padding: AppPaddings.p10,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Card(
                  elevation: 5,
                  color: kColorWhite,
                  clipBehavior: Clip.antiAlias,
                  child: SizedBox(
                    width: 100,
                    height: 100,
                    child: Image.network(
                      'http://43.250.164.139:8080/api/Product/Image?ICODE=${product.icode}',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                AppSpaces.h10,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                                    style: TextStyles.kMediumFredoka(
                                      color: kColorTextPrimary,
                                      fontSize: FontSizes.k14FontSize,
                                    ),
                                  )
                                ]
                              : product.skus.map(
                                  (sku) {
                                    return AppCard1(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Padding(
                                            padding: AppPaddings.p2,
                                            child: InkWell(
                                              onTap: () {
                                                _controller.removeProduct(
                                                  pCode: widget.pCode,
                                                  iCode: sku.skuIcode,
                                                );
                                              },
                                              child: Icon(
                                                Icons.cancel_outlined,
                                                color: kColorTextPrimary,
                                                size: 20,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: AppPaddings.ph10,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                AppSpaces.v4,
                                                Text(
                                                  sku.pack,
                                                  style:
                                                      TextStyles.kMediumFredoka(
                                                    fontSize:
                                                        FontSizes.k14FontSize,
                                                  ).copyWith(
                                                    height: 1,
                                                  ),
                                                ),
                                                AppSpaces.v4,
                                                Text(
                                                  '₹ ${sku.rate}',
                                                  style: TextStyles
                                                      .kRegularFredoka(
                                                    fontSize:
                                                        FontSizes.k14FontSize,
                                                  ).copyWith(
                                                    height: 1,
                                                  ),
                                                ),
                                                AppSpaces.v4,
                                                Row(
                                                  children: [
                                                    InkWell(
                                                      onTap: () async {
                                                        double offset =
                                                            _scrollController
                                                                    .hasClients
                                                                ? _scrollController
                                                                    .offset
                                                                : 0.0;

                                                        await _controller
                                                            .addOrUpdateCart(
                                                          pCode: widget.pCode,
                                                          iCode: sku.skuIcode,
                                                          qty: sku.cartQty == 1
                                                              ? 0
                                                              : sku.cartQty - 1,
                                                          rate: sku.rate,
                                                        );

                                                        await _controller
                                                            .getCartProducts(
                                                          pCode: widget.pCode,
                                                        );

                                                        await productsController
                                                            .searchProduct(
                                                          pCode: widget.pCode,
                                                        );

                                                        WidgetsBinding.instance
                                                            .addPostFrameCallback(
                                                          (_) {
                                                            if (_scrollController
                                                                .hasClients) {
                                                              _scrollController
                                                                  .jumpTo(
                                                                      offset);
                                                            }
                                                          },
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
                                                      style: TextStyles
                                                          .kMediumFredoka(
                                                        fontSize: FontSizes
                                                            .k16FontSize,
                                                        color:
                                                            kColorTextPrimary,
                                                      ),
                                                    ),
                                                    AppSpaces.h10,
                                                    InkWell(
                                                      onTap: () async {
                                                        double offset =
                                                            _scrollController
                                                                    .hasClients
                                                                ? _scrollController
                                                                    .offset
                                                                : 0.0;
                                                        await _controller
                                                            .addOrUpdateCart(
                                                          pCode: widget.pCode,
                                                          iCode: sku.skuIcode,
                                                          qty: sku.cartQty + 1,
                                                          rate: sku.rate,
                                                        );

                                                        await _controller
                                                            .getCartProducts(
                                                          pCode: widget.pCode,
                                                        );

                                                        await productsController
                                                            .searchProduct(
                                                          pCode: widget.pCode,
                                                        );

                                                        WidgetsBinding.instance
                                                            .addPostFrameCallback(
                                                          (_) {
                                                            if (_scrollController
                                                                .hasClients) {
                                                              _scrollController
                                                                  .jumpTo(
                                                                      offset);
                                                            }
                                                          },
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
  }
}
