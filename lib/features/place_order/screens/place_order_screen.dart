import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shreeji_dairy/constants/color_constants.dart';
import 'package:shreeji_dairy/features/place_order/controllers/place_order_controller.dart';
import 'package:shreeji_dairy/styles/font_sizes.dart';
import 'package:shreeji_dairy/styles/text_styles.dart';
import 'package:shreeji_dairy/utils/extensions/app_size_extensions.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_paddings.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_spacings.dart';
import 'package:shreeji_dairy/widgets/app_appbar.dart';
import 'package:shreeji_dairy/widgets/app_button.dart';
import 'package:shreeji_dairy/widgets/app_date_picker_field.dart';
import 'package:shreeji_dairy/widgets/app_dropdown.dart';
import 'package:shreeji_dairy/widgets/app_loading_overlay.dart';
import 'package:shreeji_dairy/widgets/app_time_picker_field.dart';

class PlaceOrderScreen extends StatefulWidget {
  const PlaceOrderScreen({
    super.key,
    required this.pCode,
    required this.pName,
    required this.deliDateOption,
    required this.totalAmount,
  });

  final String pCode;
  final String pName;
  final String deliDateOption;
  final double totalAmount;

  @override
  State<PlaceOrderScreen> createState() => _PlaceOrderScreenState();
}

class _PlaceOrderScreenState extends State<PlaceOrderScreen> {
  final PlaceOrderController _controller = Get.put(
    PlaceOrderController(),
  );

  @override
  void initState() {
    super.initState();
    if (widget.deliDateOption == 'Slot Time') {
      _controller.getSlots();
    }
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
              title: 'Place Order',
              subtitle: widget.pName,
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
              padding: AppPaddings.p16,
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Form(
                        key: _controller.placeOrderFormKey,
                        child: Column(
                          children: [
                            AppDatePickerTextFormField(
                              dateController:
                                  _controller.deliveryDateController,
                              hintText: 'Delivery Date',
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select a delivery date';
                                }
                                return null;
                              },
                            ),
                            AppSpaces.v16,
                            widget.deliDateOption == 'Slot Time'
                                ? Obx(
                                    () => AppDropdown(
                                      items: _controller.slotTimes,
                                      hintText: 'Delivery Time',
                                      onChanged: _controller.onSlotSelected,
                                      selectedItem: _controller
                                              .selectedSlotTime.value.isNotEmpty
                                          ? _controller.selectedSlotTime.value
                                          : null,
                                      validatorText:
                                          'Please select a delivery time',
                                    ),
                                  )
                                : AppTimePickerTextFormField(
                                    timeController:
                                        _controller.deliveryTimeController,
                                    hintText: 'Delivery Time',
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please select a delivery time';
                                      }
                                      return null;
                                    },
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Row(
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
                          Text(
                            '₹ ${widget.totalAmount}',
                            style: TextStyles.kMediumFredoka(
                              color: kColorTextPrimary,
                              fontSize: FontSizes.k24FontSize,
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
                          if (_controller.placeOrderFormKey.currentState!
                              .validate()) {
                            if (widget.deliDateOption == 'Slot Time') {
                              _controller.placeOrder(
                                pCode: widget.pCode,
                                dDate: DateFormat('yyyy-MM-dd').format(
                                  DateFormat('dd-MM-yyyy').parse(
                                    _controller.deliveryDateController.text,
                                  ),
                                ),
                                dTime: _controller.selectedDTime.value,
                              );
                            } else {
                              _controller.placeOrder(
                                pCode: widget.pCode,
                                dDate: DateFormat('yyyy-MM-dd').format(
                                  DateFormat('dd-MM-yyyy').parse(
                                    _controller.deliveryDateController.text,
                                  ),
                                ),
                                dTime: _controller.deliveryTimeController.text,
                              );
                            }
                          }
                        },
                      ),
                    ],
                  ),
                  AppSpaces.v10,
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
