import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreeji_dairy/constants/color_constants.dart';
import 'package:shreeji_dairy/features/store_order/controllers/store_order_controller.dart';
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

class StoreOrderScreen extends StatefulWidget {
  const StoreOrderScreen({
    super.key,
  });

  @override
  State<StoreOrderScreen> createState() => _StoreOrderScreenState();
}

class _StoreOrderScreenState extends State<StoreOrderScreen> {
  final StoreOrderController _controller = Get.put(
    StoreOrderController(),
  );

  @override
  void initState() {
    super.initState();
    _controller.fetchStoreProducts(
      searchText: _controller.searchController.text,
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
              title: 'Store Order',
              leading: IconButton(
                onPressed: () => Get.back(),
                icon: Icon(
                  Icons.arrow_back_ios,
                  size: 25,
                  color: kColorTextPrimary,
                ),
              ),
            ),
            body: Padding(
              padding: AppPaddings.p10,
              child: Column(
                children: [
                  AppTextFormField(
                    controller: _controller.searchController,
                    hintText: 'Search',
                    onChanged: (value) {
                      _controller.fetchStoreProducts(
                        searchText: value,
                      );
                    },
                  ),
                  AppSpaces.v10,
                  Obx(
                    () => Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: _controller.storeProducts.length,
                        itemBuilder: (context, index) {
                          final category = _controller.storeProducts[index];

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                category.icname,
                                style: TextStyles.kMediumFredoka(
                                  color: kColorSecondary,
                                ),
                              ),
                              AppSpaces.v10,
                              ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: category.products.length,
                                itemBuilder: (context, index) {
                                  final product = category.products[index];
                                  final controller = _controller
                                      .productControllers[product.icode];
                                  return AppCard1(
                                    child: Padding(
                                      padding: AppPaddings.p10,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(
                                            width: 0.5.screenWidth,
                                            child: Text(
                                              product.printname,
                                              style: TextStyles.kRegularFredoka(
                                                fontSize: FontSizes.k16FontSize,
                                                color: kColorTextPrimary,
                                              ).copyWith(
                                                height: 1.25,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 0.3.screenWidth,
                                            child: AppTextFormField(
                                              controller: controller!,
                                              hintText: 'Qty',
                                              fontSize: FontSizes.k20FontSize,
                                              keyboardType:
                                                  TextInputType.number,
                                              onChanged: (_) {
                                                _controller.addOrUpdateCart(
                                                  iCode: product.icode,
                                                );
                                              },
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                              AppSpaces.v10,
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                  AppButton(
                    buttonColor: kColorPrimary,
                    title: 'Place Order',
                    titleColor: kColorTextPrimary,
                    onPressed: () {},
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
