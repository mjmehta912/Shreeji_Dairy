import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreeji_dairy/constants/color_constants.dart';
import 'package:shreeji_dairy/features/order_status/controllers/order_status_controller.dart';
import 'package:shreeji_dairy/features/order_status/widgets/order_status_card.dart';
import 'package:shreeji_dairy/styles/font_sizes.dart';
import 'package:shreeji_dairy/styles/text_styles.dart';
import 'package:shreeji_dairy/utils/extensions/app_size_extensions.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_paddings.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_spacings.dart';
import 'package:shreeji_dairy/widgets/app_appbar.dart';
import 'package:shreeji_dairy/widgets/app_dropdown.dart';
import 'package:shreeji_dairy/widgets/app_loading_overlay.dart';
import 'package:shreeji_dairy/widgets/app_text_form_field.dart';

class OrderStatusScreen extends StatefulWidget {
  const OrderStatusScreen({
    super.key,
    required this.pCode,
    required this.pName,
  });

  final String pCode;
  final String pName;

  @override
  State<OrderStatusScreen> createState() => _OrderStatusScreenState();
}

class _OrderStatusScreenState extends State<OrderStatusScreen> {
  final OrderStatusController _controller = Get.put(
    OrderStatusController(),
  );

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  void _initialize() async {
    await _controller.getCustomers();

    _controller.selectedCustomerCode.value = widget.pCode;
    _controller.selectedCustomer.value = widget.pName;

    await _controller.getOrderItems(
      pCode: _controller.selectedCustomerCode.value,
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
              title: 'Order Status',
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
                      _controller.getOrderItems(
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

                          await _controller.getOrderItems(
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
                    () => SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: _controller.statusOptions.map(
                          (status) {
                            return Padding(
                              padding: AppPaddings.ph4,
                              child: ChoiceChip(
                                showCheckmark: false,
                                backgroundColor: kColorWhite,
                                selectedColor: kColorSecondary,
                                label: Text(status['label']!),
                                labelStyle: TextStyles.kRegularFredoka(
                                  fontSize: FontSizes.k12FontSize,
                                  color: _controller.selectedStatus.value ==
                                          status['value']
                                      ? kColorWhite
                                      : kColorTextPrimary,
                                ),
                                selected: _controller.selectedStatus.value ==
                                    status['value'],
                                onSelected: (_) {
                                  _controller
                                      .onStatusSelected(status['value']!);
                                },
                              ),
                            );
                          },
                        ).toList(),
                      ),
                    ),
                  ),
                  AppSpaces.v10,
                  Obx(
                    () {
                      if (_controller.orders.isEmpty &&
                          !_controller.isLoading.value) {
                        return Expanded(
                          child: Center(
                            child: Text(
                              'No orders found.',
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

                            return OrderStatusCard(
                              order: order,
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
}
