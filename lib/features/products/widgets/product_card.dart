import 'package:flutter/material.dart';
import 'package:shreeji_dairy/constants/color_constants.dart';
import 'package:shreeji_dairy/features/products/controllers/products_controller.dart';
import 'package:shreeji_dairy/features/products/models/product_dm.dart';
import 'package:shreeji_dairy/features/products/screens/products_screen.dart';
import 'package:shreeji_dairy/styles/font_sizes.dart';
import 'package:shreeji_dairy/styles/text_styles.dart';
import 'package:shreeji_dairy/utils/extensions/app_size_extensions.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_paddings.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_spacings.dart';
import 'package:shreeji_dairy/widgets/app_button.dart';
import 'package:shreeji_dairy/widgets/app_card1.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
    required ScrollController scrollController,
    required ProductsController controller,
    required this.widget,
  })  : _scrollController = scrollController,
        _controller = controller;

  final ProductDm product;
  final ScrollController _scrollController;
  final ProductsController _controller;
  final ProductsScreen widget;

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
                                      child: Padding(
                                        padding: AppPaddings.combined(
                                          horizontal: 10.appWidth,
                                          vertical: 5.appHeight,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              sku.pack,
                                              style: TextStyles.kMediumFredoka(
                                                fontSize: FontSizes.k14FontSize,
                                              ).copyWith(
                                                height: 1,
                                              ),
                                            ),
                                            AppSpaces.v4,
                                            Text(
                                              '₹ ${sku.rate}',
                                              style: TextStyles.kRegularFredoka(
                                                fontSize: FontSizes.k14FontSize,
                                              ).copyWith(
                                                height: 1,
                                              ),
                                            ),
                                            AppSpaces.v4,
                                            sku.cartQty == 0
                                                ? SizedBox(
                                                    width: 0.2.screenWidth,
                                                    height: 30,
                                                    child: AppButton(
                                                      onPressed: () async {
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
                                                          qty: sku.cartQty +
                                                              1, // or -1 for remove
                                                          rate: sku.rate,
                                                        );

                                                        await _controller
                                                            .searchProduct(
                                                          pCode: widget.pCode,
                                                          searchText: _controller
                                                              .searchController
                                                              .text,
                                                        );

                                                        // ✅ Restore scroll position after UI updates
                                                        WidgetsBinding.instance
                                                            .addPostFrameCallback(
                                                                (_) {
                                                          if (_scrollController
                                                              .hasClients) {
                                                            _scrollController
                                                                .jumpTo(offset);
                                                          }
                                                        });
                                                      },
                                                      title: 'Add +',
                                                      titleSize:
                                                          FontSizes.k14FontSize,
                                                      buttonColor: kColorWhite,
                                                      borderColor:
                                                          kColorSecondary,
                                                      titleColor:
                                                          kColorSecondary,
                                                    ),
                                                  )
                                                : Row(
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
                                                            qty: sku.cartQty ==
                                                                    1
                                                                ? 0
                                                                : sku.cartQty -
                                                                    1,
                                                            rate: sku.rate,
                                                          );

                                                          await _controller
                                                              .searchProduct(
                                                            pCode: widget.pCode,
                                                            searchText: _controller
                                                                .searchController
                                                                .text,
                                                          );

                                                          // ✅ Restore scroll position after UI updates
                                                          WidgetsBinding
                                                              .instance
                                                              .addPostFrameCallback(
                                                                  (_) {
                                                            if (_scrollController
                                                                .hasClients) {
                                                              _scrollController
                                                                  .jumpTo(
                                                                      offset);
                                                            }
                                                          });
                                                        },
                                                        child: const Icon(
                                                          Icons.remove,
                                                          color:
                                                              kColorSecondary,
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
                                                            qty: sku.cartQty +
                                                                1, // or -1 for remove
                                                            rate: sku.rate,
                                                          );

                                                          await _controller
                                                              .searchProduct(
                                                            pCode: widget.pCode,
                                                            searchText: _controller
                                                                .searchController
                                                                .text,
                                                          );

                                                          // ✅ Restore scroll position after UI updates
                                                          WidgetsBinding
                                                              .instance
                                                              .addPostFrameCallback(
                                                                  (_) {
                                                            if (_scrollController
                                                                .hasClients) {
                                                              _scrollController
                                                                  .jumpTo(
                                                                      offset);
                                                            }
                                                          });
                                                        },
                                                        child: const Icon(
                                                          Icons.add,
                                                          color:
                                                              kColorSecondary,
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
  }
}
