import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreeji_dairy/constants/color_constants.dart';
import 'package:shreeji_dairy/features/order_authorisation/auth_order/controllers/auth_order_controller.dart';
import 'package:shreeji_dairy/features/order_authorisation/auth_order/models/order_detail_dm.dart';
import 'package:shreeji_dairy/features/order_authorisation/auth_order/widgets/auth_order_card.dart';
import 'package:shreeji_dairy/styles/font_sizes.dart';
import 'package:shreeji_dairy/styles/text_styles.dart';
import 'package:shreeji_dairy/utils/dialogs/app_dialogs.dart';
import 'package:shreeji_dairy/utils/extensions/app_size_extensions.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_paddings.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_spacings.dart';
import 'package:shreeji_dairy/widgets/app_appbar.dart';
import 'package:shreeji_dairy/widgets/app_button.dart';
import 'package:shreeji_dairy/widgets/app_loading_overlay.dart';
import 'package:shreeji_dairy/widgets/app_text_form_field.dart';

class AuthOrderScreen extends StatefulWidget {
  const AuthOrderScreen({
    super.key,
    required this.invNo,
  });

  final String invNo;

  @override
  State<AuthOrderScreen> createState() => _AuthOrderScreenState();
}

class _AuthOrderScreenState extends State<AuthOrderScreen> {
  final AuthOrderController _controller = Get.put(
    AuthOrderController(),
  );

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  void _initialize() async {
    await _controller.getOrderDetails(
      invNo: widget.invNo,
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
              title: widget.invNo,
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
                    onChanged: _controller.searchOrderDetails,
                  ),
                  AppSpaces.v10,
                  Obx(
                    () {
                      if (!_controller.isSelecting.value) {
                        return SizedBox.shrink();
                      }
                      return GestureDetector(
                        child: Row(
                          children: [
                            Obx(
                              () => Checkbox(
                                activeColor: kColorGreen,
                                shape: const CircleBorder(),
                                value: _controller.selectedItems.length ==
                                    _controller.filteredOrderDetails
                                        .where(
                                          (item) =>
                                              item.status == 0 ||
                                              item.status == 2,
                                        )
                                        .length,
                                onChanged: (value) => _controller.selectAll(),
                              ),
                            ),
                            Text(
                              'Select All',
                              style: TextStyles.kRegularFredoka(
                                fontSize: FontSizes.k16FontSize,
                                color: kColorTextPrimary,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  Obx(
                    () {
                      if (_controller.filteredOrderDetails.isEmpty &&
                          !_controller.isLoading.value) {
                        return Expanded(
                          child: Center(
                            child: Text(
                              'No order details found.',
                              style: TextStyles.kRegularFredoka(),
                            ),
                          ),
                        );
                      }
                      return Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: _controller.filteredOrderDetails.length,
                          itemBuilder: (context, index) {
                            final orderDetail =
                                _controller.filteredOrderDetails[index];

                            return GestureDetector(
                              onLongPress: () => _controller
                                  .toggleSelection(orderDetail.iCode),
                              onTap: () {
                                if (_controller.isSelecting.value) {
                                  _controller
                                      .toggleSelection(orderDetail.iCode);
                                }
                              },
                              child: Stack(
                                children: [
                                  AuthOrderCard(
                                    orderDetail: orderDetail,
                                    onAccept: () =>
                                        _showApprovalDialog(orderDetail, 1),
                                    onHold: () async {
                                      await _controller.approveOrder(
                                        status: 2,
                                        pCode: orderDetail.pCode,
                                        iCodes: orderDetail.iCode,
                                        invNo: orderDetail.invNo,
                                        approvedQty: 0.0,
                                      );
                                    },
                                    onReject: () async {
                                      await _controller.approveOrder(
                                        status: 3,
                                        pCode: orderDetail.pCode,
                                        iCodes: orderDetail.iCode,
                                        invNo: orderDetail.invNo,
                                        approvedQty: 0.0,
                                      );
                                    },
                                  ),
                                  Positioned(
                                    right: 10,
                                    top: 10,
                                    child: Obx(
                                      () => Checkbox(
                                        activeColor: kColorGreen,
                                        shape: const CircleBorder(),
                                        value: _controller.selectedItems
                                            .contains(orderDetail.iCode),
                                        onChanged: (orderDetail.status == 0 ||
                                                orderDetail.status == 2)
                                            ? (value) {
                                                _controller.toggleSelection(
                                                    orderDetail.iCode);
                                              }
                                            : null,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                  Obx(
                    () {
                      if (!_controller.isSelecting.value) {
                        return SizedBox.shrink();
                      }
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AppButton(
                                buttonWidth: 0.45.screenWidth,
                                buttonHeight: 40,
                                buttonColor: kColorRed,
                                title: "Reject Selected",
                                titleSize: FontSizes.k18FontSize,
                                onPressed: () async {
                                  String iCodes =
                                      _controller.selectedItems.join(',');

                                  var firstSelected = _controller
                                      .filteredOrderDetails
                                      .firstWhere(
                                    (order) => _controller.selectedItems
                                        .contains(order.iCode),
                                  );

                                  await _controller.approveOrder(
                                    status: 3,
                                    pCode: firstSelected.pCode,
                                    iCodes: iCodes,
                                    invNo: firstSelected.invNo,
                                    approvedQty: 0,
                                  );
                                },
                              ),
                              AppButton(
                                buttonWidth: 0.45.screenWidth,
                                buttonHeight: 40,
                                buttonColor: kColorSecondary,
                                title: "Accept Selected",
                                titleSize: FontSizes.k18FontSize,
                                onPressed: () async {
                                  String iCodes =
                                      _controller.selectedItems.join(',');

                                  var firstSelected = _controller
                                      .filteredOrderDetails
                                      .firstWhere(
                                    (order) => _controller.selectedItems
                                        .contains(order.iCode),
                                  );

                                  await _controller.approveOrder(
                                    status: 1,
                                    pCode: firstSelected.pCode,
                                    iCodes: iCodes,
                                    invNo: firstSelected.invNo,
                                    approvedQty: 0,
                                  );
                                },
                              ),
                            ],
                          ),
                          AppSpaces.v10,
                        ],
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

  void _showApprovalDialog(OrderDetailDm orderDetail, int status) {
    _controller.approvedQtyController.text = orderDetail.orderQty.toString();
    Get.defaultDialog(
      title: 'Approve Order',
      titleStyle: TextStyles.kRegularFredoka(),
      contentPadding: AppPaddings.p20,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppTextFormField(
            controller: _controller.approvedQtyController,
            hintText: 'Approved Qty',
            keyboardType: TextInputType.number,
          ),
          AppSpaces.v10,
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AppButton(
                onPressed: () async {
                  double? approvedQty =
                      double.tryParse(_controller.approvedQtyController.text);
                  if (approvedQty == null || approvedQty <= 0) {
                    showErrorSnackbar(
                      'Error',
                      'Enter a valid quantity',
                    );
                    return;
                  }

                  Get.back();

                  await _controller.approveOrder(
                    status: status,
                    pCode: orderDetail.pCode,
                    iCodes: orderDetail.iCode,
                    invNo: orderDetail.invNo,
                    approvedQty: approvedQty,
                  );
                },
                title: 'Save',
                buttonWidth: 0.2.screenWidth,
                buttonHeight: 35,
                buttonColor: kColorSecondary,
                titleSize: FontSizes.k16FontSize,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
