import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shreeji_dairy/constants/color_constants.dart';
import 'package:shreeji_dairy/features/store_order/controllers/place_store_order_controller.dart';
import 'package:shreeji_dairy/utils/dialogs/app_dialogs.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_paddings.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_spacings.dart';
import 'package:shreeji_dairy/widgets/app_appbar.dart';
import 'package:shreeji_dairy/widgets/app_button.dart';
import 'package:shreeji_dairy/widgets/app_date_picker_field.dart';
import 'package:shreeji_dairy/widgets/app_dropdown.dart';
import 'package:shreeji_dairy/widgets/app_loading_overlay.dart';
import 'package:shreeji_dairy/widgets/app_time_picker_field.dart';

class PlaceStoreOrderScreen extends StatefulWidget {
  const PlaceStoreOrderScreen({
    super.key,
    required this.pCode,
    required this.pName,
    required this.cCode,
    required this.branchCode,
    required this.deliDateOption,
  });

  final String pCode;
  final String pName;
  final String cCode;
  final String branchCode;
  final String deliDateOption;

  @override
  State<PlaceStoreOrderScreen> createState() => _PlaceStoreOrderScreenState();
}

class _PlaceStoreOrderScreenState extends State<PlaceStoreOrderScreen> {
  final PlaceStoreOrderController _controller = Get.put(
    PlaceStoreOrderController(),
  );

  @override
  void initState() {
    super.initState();
    if (widget.deliDateOption == 'Slot Time') {
      _controller.getCategoryWiseSlots(
        cCode: widget.cCode,
      );
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
                        key: _controller.placeStoreOrderFormKey,
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
                  AppButton(
                    title: 'Place Order',
                    titleColor: kColorTextPrimary,
                    buttonColor: kColorPrimary,
                    onPressed: () {
                      if (_controller.placeStoreOrderFormKey.currentState!
                          .validate()) {
                        if (widget.deliDateOption == 'Slot Time') {
                          DateTime selectedDate = DateFormat('dd-MM-yyyy')
                              .parse(_controller.deliveryDateController.text);

                          DateTime now = DateTime.now();

                          if (selectedDate.year == now.year &&
                              selectedDate.month == now.month &&
                              selectedDate.day == now.day) {
                            DateTime selectedTime = DateFormat('hh:mm a')
                                .parse(_controller.selectedDTime.value);

                            DateTime selectedDateTime = DateTime(
                              now.year,
                              now.month,
                              now.day,
                              selectedTime.hour,
                              selectedTime.minute,
                            );

                            if (selectedDateTime.isBefore(now)) {
                              showErrorSnackbar(
                                'Oops!',
                                'Delivery time must be greater than the current time',
                              );
                              return;
                            }
                          }

                          _controller.placeOrder(
                            pCode: widget.pCode,
                            dDate:
                                DateFormat('yyyy-MM-dd').format(selectedDate),
                            dTime: _controller.selectedDTime.value,
                            branchPrefix: widget.branchCode,
                          );
                        } else {
                          DateTime selectedDate = DateFormat('dd-MM-yyyy')
                              .parse(_controller.deliveryDateController.text);

                          DateTime now = DateTime.now();

                          if (selectedDate.year == now.year &&
                              selectedDate.month == now.month &&
                              selectedDate.day == now.day) {
                            DateTime pickedTime = DateFormat('h:mm a')
                                .parse(_controller.deliveryTimeController.text);

                            DateTime pickedDateTime = DateTime(
                              now.year,
                              now.month,
                              now.day,
                              pickedTime.hour,
                              pickedTime.minute,
                            );

                            if (pickedDateTime.isBefore(now)) {
                              showErrorSnackbar(
                                'Oops!',
                                'Delivery time must be greater than the current time',
                              );
                              return;
                            }
                          }

                          _controller.placeOrder(
                            pCode: widget.pCode,
                            dDate:
                                DateFormat('yyyy-MM-dd').format(selectedDate),
                            branchPrefix: widget.branchCode,
                            dTime: _controller.deliveryTimeController.text,
                          );
                        }
                      }
                    },
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
