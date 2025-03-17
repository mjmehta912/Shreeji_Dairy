import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreeji_dairy/constants/color_constants.dart';
import 'package:shreeji_dairy/features/cart/controllers/cart_controller.dart';
import 'package:shreeji_dairy/features/cart/widgets/cart_card.dart';
import 'package:shreeji_dairy/features/place_order/screens/place_order_screen.dart';
import 'package:shreeji_dairy/features/products/controllers/products_controller.dart';
import 'package:shreeji_dairy/styles/font_sizes.dart';
import 'package:shreeji_dairy/styles/text_styles.dart';
import 'package:shreeji_dairy/utils/extensions/app_size_extensions.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_paddings.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_spacings.dart';
import 'package:shreeji_dairy/widgets/app_appbar.dart';
import 'package:shreeji_dairy/widgets/app_button.dart';
import 'package:shreeji_dairy/widgets/app_loading_overlay.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({
    super.key,
    required this.pCode,
    required this.pName,
    required this.deliDateOption,
  });

  final String pCode;
  final String pName;
  final String deliDateOption;

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartController _controller = Get.put(
    CartController(),
  );

  final ScrollController _scrollController = ScrollController();

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
            padding: AppPaddings.p12,
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
                            style: TextStyles.kRegularFredoka(),
                          ),
                        ),
                      );
                    }

                    return Expanded(
                      child: ListView.builder(
                        controller: _scrollController,
                        shrinkWrap: true,
                        itemCount: _controller.cartProducts.length,
                        itemBuilder: (context, index) {
                          final product = _controller.cartProducts[index];

                          return CartCard(
                            product: product,
                            controller: _controller,
                            widget: widget,
                            scrollController: _scrollController,
                            productsController: productsController,
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
                              title: 'Proceed',
                              titleColor: kColorTextPrimary,
                              buttonColor: kColorPrimary,
                              onPressed: () {
                                Get.to(
                                  () => PlaceOrderScreen(
                                    pCode: widget.pCode,
                                    pName: widget.pName,
                                    deliDateOption: widget.deliDateOption,
                                    totalAmount: _controller.totalAmount,
                                  ),
                                );
                              },
                            ),
                          ],
                        )
                      : const SizedBox.shrink(),
                ),
                AppSpaces.v10,
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
