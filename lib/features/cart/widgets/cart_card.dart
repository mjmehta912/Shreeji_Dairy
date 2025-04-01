import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shreeji_dairy/constants/color_constants.dart';
import 'package:shreeji_dairy/features/cart/controllers/cart_controller.dart';
import 'package:shreeji_dairy/features/cart/models/cart_product_dm.dart';
import 'package:shreeji_dairy/features/cart/screens/cart_screen.dart';
import 'package:shreeji_dairy/features/products/controllers/products_controller.dart';
import 'package:shreeji_dairy/styles/font_sizes.dart';
import 'package:shreeji_dairy/styles/text_styles.dart';
import 'package:shreeji_dairy/utils/dialogs/app_dialogs.dart';
import 'package:shreeji_dairy/utils/extensions/app_size_extensions.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_paddings.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_spacings.dart';
import 'package:shreeji_dairy/widgets/app_card1.dart';
import 'package:shreeji_dairy/widgets/app_text_form_field.dart';

class CartCard extends StatefulWidget {
  final CartProductDm product;
  final CartController controller;
  final CartScreen widget;
  final ScrollController scrollController;
  final ProductsController productsController;

  const CartCard({
    super.key,
    required this.product,
    required this.controller,
    required this.widget,
    required this.scrollController,
    required this.productsController,
  });

  @override
  State<CartCard> createState() => _CartCardState();
}

class _CartCardState extends State<CartCard> {
  Timer? _debounce;

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
                        ).copyWith(
                          height: 1,
                        ),
                      ),
                      AppSpaces.v10,

                      // SKU List
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
                              : widget.product.skus.map(
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
                                                widget.controller.removeProduct(
                                                  pCode: widget.widget.pCode,
                                                  iCode: sku.skuIcode,
                                                  oldICode: sku.oldSkuICode,
                                                );
                                              },
                                              child: const Icon(
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
                                                // Display SKU Pack Name if Available
                                                if (sku.pack.isNotEmpty) ...[
                                                  Text(
                                                    sku.pack,
                                                    style: TextStyles
                                                        .kMediumFredoka(
                                                      fontSize:
                                                          FontSizes.k14FontSize,
                                                    ).copyWith(height: 1),
                                                  ),
                                                  AppSpaces.v4,
                                                ],
                                                // Display Price
                                                Text(
                                                  '₹ ${sku.rate}',
                                                  style: TextStyles
                                                      .kRegularFredoka(
                                                    fontSize:
                                                        FontSizes.k14FontSize,
                                                  ).copyWith(height: 1),
                                                ),
                                                AppSpaces.v8,

                                                // Handle SKU with Free Input Quantity (No Predefined Pack)
                                                if (sku.pack.isEmpty) ...[
                                                  _buildQtyTextField(sku),
                                                ] else ...[
                                                  _buildQtyButtons(sku),
                                                ],
                                              ],
                                            ),
                                          ),
                                          AppSpaces.v6,
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

  /// 📌 Quantity Input Field (for SKUs without predefined pack)
  Widget _buildQtyTextField(sku) {
    TextEditingController qtyController =
        TextEditingController(text: sku.cartQty.toString());

    return SizedBox(
      width: 0.2.screenWidth,
      child: AppTextFormField(
        controller: qtyController,
        keyboardType: TextInputType.number,
        hintText: 'Qty',
        onChanged: (value) {
          if (_debounce?.isActive ?? false) _debounce!.cancel();
          _debounce = Timer(
              const Duration(
                seconds: 1,
              ), () async {
            double qty = double.tryParse(value) ?? 0.0;
            await _updateCart(sku, qty);
          });
        },
      ),
    );
  }

  /// 📌 Quantity Increment/Decrement Buttons (for SKUs with predefined pack)
  Widget _buildQtyButtons(sku) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Decrease Quantity
        InkWell(
          onTap: () async {
            await _updateCart(sku, sku.cartQty - 1);
          },
          child: const Icon(
            Icons.remove,
            color: kColorSecondary,
            size: 20,
          ),
        ),
        AppSpaces.h10,
        Text(
          sku.cartQty.toInt().toString(),
          style: TextStyles.kMediumFredoka(
            fontSize: FontSizes.k16FontSize,
            color: kColorTextPrimary,
          ),
        ),
        AppSpaces.h10,
        // Increase Quantity
        InkWell(
          onTap: () async {
            await _updateCart(sku, sku.cartQty + 1);
          },
          child: const Icon(
            Icons.add,
            color: kColorSecondary,
            size: 20,
          ),
        ),
      ],
    );
  }

  /// 📌 Update Cart with Scroll Position Preservation
  Future<void> _updateCart(CartSKUDm sku, double qty) async {
    if (qty < 0) return; // Prevent negative values

    double offset = widget.scrollController.hasClients
        ? widget.scrollController.offset
        : 0.0;

    if (sku.oldSkuICode.isEmpty) {
      showErrorSnackbar(
        'Alert!',
        'Item not mapped',
      );
    } else {
      await widget.controller.addOrUpdateCart(
        pCode: widget.widget.pCode,
        iCode: sku.skuIcode,
        oldICode: sku.oldSkuICode,
        qty: qty > 0 ? qty : 0,
        rate: sku.rate,
      );

      await widget.controller.getCartProducts(
        pCode: widget.widget.pCode,
      );

      await widget.productsController.searchProduct(
        pCode: widget.widget.pCode,
      );
    }

    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        if (widget.scrollController.hasClients) {
          widget.scrollController.jumpTo(offset);
        }
      },
    );
  }
}
