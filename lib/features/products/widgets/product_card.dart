import 'dart:async'; // For debounce
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
import 'package:shreeji_dairy/widgets/app_text_form_field.dart';

class ProductCard extends StatefulWidget {
  final ProductDm product;
  final ScrollController scrollController;
  final ProductsController controller;
  final ProductsScreen widget;

  const ProductCard({
    super.key,
    required this.product,
    required this.scrollController,
    required this.controller,
    required this.widget,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  Timer? _debounce; // Timer for debounce

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
                // Product Image
                Card(
                  elevation: 5,
                  color: kColorWhite,
                  clipBehavior: Clip.antiAlias,
                  child: SizedBox(
                    width: 100,
                    height: 100,
                    child: Image.network(
                      'http://43.250.164.139:8080/api/Product/Image?ICODE=${widget.product.icode}',
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
                        widget.product.printName,
                        style: TextStyles.kMediumFredoka(
                          color: kColorTextPrimary,
                          fontSize: FontSizes.k16FontSize,
                        ).copyWith(height: 1),
                      ),
                      AppSpaces.v10,

                      // Packaging Section
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: widget.product.skus.isEmpty
                              ? [
                                  Text(
                                    'No packaging available',
                                    style: TextStyles.kMediumFredoka(
                                      color: kColorTextPrimary,
                                      fontSize: FontSizes.k14FontSize,
                                    ),
                                  )
                                ]
                              : widget.product.skus.map((sku) {
                                  if (sku.pack.isEmpty) {
                                    TextEditingController qtyController =
                                        TextEditingController(
                                      text: sku.cartQty.toString(),
                                    );

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
                                              '₹ ${sku.rate}',
                                              style: TextStyles.kRegularFredoka(
                                                fontSize: FontSizes.k14FontSize,
                                              ).copyWith(height: 1),
                                            ),
                                            AppSpaces.v8,
                                            SizedBox(
                                              width: 0.2.screenWidth,
                                              child: AppTextFormField(
                                                controller: qtyController,
                                                keyboardType:
                                                    TextInputType.number,
                                                onChanged: (value) {
                                                  if (_debounce?.isActive ??
                                                      false) {
                                                    _debounce!.cancel();
                                                  }
                                                  _debounce = Timer(
                                                      const Duration(
                                                        seconds: 1,
                                                      ), () async {
                                                    double qty =
                                                        double.tryParse(
                                                                value) ??
                                                            0.0;

                                                    double offset = widget
                                                            .scrollController
                                                            .hasClients
                                                        ? widget
                                                            .scrollController
                                                            .offset
                                                        : 0.0;

                                                    await widget.controller
                                                        .addOrUpdateCart(
                                                      pCode:
                                                          widget.widget.pCode,
                                                      iCode: sku.skuIcode,
                                                      qty: qty,
                                                      rate: sku.rate,
                                                    );

                                                    await widget.controller
                                                        .searchProduct(
                                                      pCode:
                                                          widget.widget.pCode,
                                                      searchText: widget
                                                          .controller
                                                          .searchController
                                                          .text,
                                                    );

                                                    WidgetsBinding.instance
                                                        .addPostFrameCallback(
                                                            (_) {
                                                      if (widget
                                                          .scrollController
                                                          .hasClients) {
                                                        widget.scrollController
                                                            .jumpTo(offset);
                                                      }
                                                    });
                                                  });
                                                },
                                                hintText: 'Qty',
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }

                                  // Regular SKU Cards
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
                                            ).copyWith(height: 1),
                                          ),
                                          AppSpaces.v4,
                                          Text(
                                            '₹ ${sku.rate}',
                                            style: TextStyles.kRegularFredoka(
                                              fontSize: FontSizes.k14FontSize,
                                            ).copyWith(height: 1),
                                          ),
                                          AppSpaces.v4,
                                          sku.cartQty == 0
                                              ? SizedBox(
                                                  width: 0.2.screenWidth,
                                                  height: 30,
                                                  child: AppButton(
                                                    onPressed: () async {
                                                      await _updateCart(sku, 1);
                                                    },
                                                    title: 'Add +',
                                                    titleSize:
                                                        FontSizes.k14FontSize,
                                                    buttonColor: kColorWhite,
                                                    borderColor:
                                                        kColorSecondary,
                                                    titleColor: kColorSecondary,
                                                  ),
                                                )
                                              : Row(
                                                  children: [
                                                    InkWell(
                                                      onTap: () async {
                                                        await _updateCart(sku,
                                                            sku.cartQty - 1);
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
                                                        await _updateCart(sku,
                                                            sku.cartQty + 1);
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
                                }).toList(),
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

  Future<void> _updateCart(sku, double qty) async {
    double offset = widget.scrollController.hasClients
        ? widget.scrollController.offset
        : 0.0;

    await widget.controller.addOrUpdateCart(
      pCode: widget.widget.pCode,
      iCode: sku.skuIcode,
      qty: qty,
      rate: sku.rate,
    );

    await widget.controller.searchProduct(
      pCode: widget.widget.pCode,
      searchText: widget.controller.searchController.text,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.scrollController.hasClients) {
        widget.scrollController.jumpTo(offset);
      }
    });
  }
}
