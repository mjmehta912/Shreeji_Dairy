import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreeji_dairy/constants/color_constants.dart';
import 'package:shreeji_dairy/features/order_authorisation/controllers/order_authorisation_controller.dart';
import 'package:shreeji_dairy/features/order_authorisation/widgets/order_authorisation_card.dart';
import 'package:shreeji_dairy/styles/text_styles.dart';
import 'package:shreeji_dairy/utils/extensions/app_size_extensions.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_paddings.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_spacings.dart';
import 'package:shreeji_dairy/widgets/app_appbar.dart';
import 'package:shreeji_dairy/widgets/app_dropdown.dart';
import 'package:shreeji_dairy/widgets/app_loading_overlay.dart';
import 'package:shreeji_dairy/widgets/app_text_form_field.dart';

class OrderAuthorisationScreen extends StatefulWidget {
  const OrderAuthorisationScreen({
    super.key,
    required this.pCode,
    required this.pName,
  });

  final String pCode;
  final String pName;

  @override
  State<OrderAuthorisationScreen> createState() =>
      _OrderAuthorisationScreenState();
}

class _OrderAuthorisationScreenState extends State<OrderAuthorisationScreen> {
  final OrderAuthorisationController _controller = Get.put(
    OrderAuthorisationController(),
  );

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  void _initialize() async {
    await _controller.getCustomers();

    await _controller.getOrders(
      pCode: '',
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
              title: 'Order Authorisation',
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
                    hintText: 'Search Order',
                    onChanged: (value) {
                      _controller.getOrders(
                        pCode: _controller.selectedCustomerCode.value,
                      );
                    },
                  ),
                  AppSpaces.v10,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(
                        () => SizedBox(
                          width: 0.8.screenWidth,
                          child: AppDropdown(
                            items: _controller.customerNames,
                            hintText: 'Customer',
                            onChanged: _controller.onCustomerSelected,
                            selectedItem:
                                _controller.selectedCustomer.value.isNotEmpty
                                    ? _controller.selectedCustomer.value
                                    : null,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          _controller.selectedCustomer.value = '';
                          _controller.selectedCustomerCode.value = '';

                          await _controller.getOrders(
                            pCode: '',
                          );
                        },
                        icon: Icon(
                          Icons.clear,
                          size: 25,
                          color: kColorTextPrimary,
                        ),
                      ),
                    ],
                  ),
                  AppSpaces.v10,
                  Obx(
                    () {
                      if (_controller.orders.isEmpty &&
                          !_controller.isLoading.value) {
                        return Expanded(
                          child: Center(
                            child: Text(
                              'No pending orders found.',
                              style: TextStyles.kRegularFredoka(),
                            ),
                          ),
                        );
                      }

                      return Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: _controller.orders.length,
                          itemBuilder: (context, index) {
                            final order = _controller.orders[index];

                            return OrderAuthorisationCard(
                              order: order,
                              // onAccept: () => _showApprovalDialog(order, 1),
                              // onHold: () async {
                              //   await _controller.approveOrder(
                              //     status: 2,
                              //     pCode: order.pCode,
                              //     iCode: order.iCode,
                              //     invNo: order.invNo,
                              //     approvedQty: 0.0,
                              //   );
                              // },
                              // onReject: () async {
                              //   await _controller.approveOrder(
                              //     status: 3,
                              //     pCode: order.pCode,
                              //     iCode: order.iCode,
                              //     invNo: order.invNo,
                              //     approvedQty: 0.0,
                              //   );
                              // },
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

  // void _showApprovalDialog(OrderDm order, int status) {
  //   _controller.approvedQtyController.text = order.orderQty.toString();
  //   Get.defaultDialog(
  //     title: 'Approve Order',
  //     titleStyle: TextStyles.kRegularFredoka(),
  //     contentPadding: AppPaddings.p20,
  //     content: Column(
  //       mainAxisSize: MainAxisSize.min,
  //       children: [
  //         AppTextFormField(
  //           controller: _controller.approvedQtyController,
  //           hintText: 'Approved Qty',
  //           keyboardType: TextInputType.number,
  //         ),
  //         AppSpaces.v10,
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.end,
  //           children: [
  //             AppButton(
  //               onPressed: () async {
  //                 double? approvedQty =
  //                     double.tryParse(_controller.approvedQtyController.text);
  //                 if (approvedQty == null || approvedQty <= 0) {
  //                   showErrorSnackbar(
  //                     'Error',
  //                     'Enter a valid quantity',
  //                   );
  //                   return;
  //                 }

  //                 await _controller.approveOrder(
  //                   status: status,
  //                   pCode: order.pCode,
  //                   iCode: order.iCode,
  //                   invNo: order.invNo,
  //                   approvedQty: approvedQty,
  //                 );
  //               },
  //               title: 'Save',
  //               buttonWidth: 0.2.screenWidth,
  //               buttonHeight: 35,
  //               buttonColor: kColorSecondary,
  //               titleSize: FontSizes.k16FontSize,
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
