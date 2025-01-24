import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreeji_dairy/constants/color_constants.dart';
import 'package:shreeji_dairy/features/outstandings/controllers/outstandings_controller.dart';
import 'package:shreeji_dairy/features/outstandings/widgets/outstanding_row.dart';
import 'package:shreeji_dairy/styles/font_sizes.dart';
import 'package:shreeji_dairy/styles/text_styles.dart';
import 'package:shreeji_dairy/utils/extensions/app_size_extensions.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_paddings.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_spacings.dart';
import 'package:shreeji_dairy/widgets/app_appbar.dart';
import 'package:shreeji_dairy/widgets/app_card2.dart';
import 'package:shreeji_dairy/widgets/app_date_picker_field.dart';
import 'package:shreeji_dairy/widgets/app_dropdown.dart';
import 'package:shreeji_dairy/widgets/app_loading_overlay.dart';

class OutstandingsScreen extends StatefulWidget {
  const OutstandingsScreen({
    super.key,
    required this.pCode,
    required this.pName,
    required this.branchCode,
  });

  final String pCode;
  final String pName;
  final String branchCode;

  @override
  State<OutstandingsScreen> createState() => _OutstandingsScreenState();
}

class _OutstandingsScreenState extends State<OutstandingsScreen> {
  final OutstandingsController _controller = Get.put(
    OutstandingsController(),
  );

  @override
  void initState() {
    super.initState();
    initialize();
  }

  void initialize() async {
    DateTime now = DateTime.now();
    DateTime fromDate;
    DateTime toDate;

    if (now.month >= 4) {
      fromDate = DateTime(now.year, 4, 1);
      toDate = DateTime(now.year + 1, 3, 31);
    } else {
      fromDate = DateTime(now.year - 1, 4, 1);
      toDate = DateTime(now.year, 3, 31);
    }

    final formattedFromDate =
        "${fromDate.day.toString().padLeft(2, '0')}-${fromDate.month.toString().padLeft(2, '0')}-${fromDate.year}";
    final formattedToDate =
        "${toDate.day.toString().padLeft(2, '0')}-${toDate.month.toString().padLeft(2, '0')}-${toDate.year}";

    _controller.fromDateController.text = formattedFromDate;
    _controller.toDateController.text = formattedToDate;

    _controller.fromDateController.addListener(() {
      _onDateChanged();
    });
    _controller.toDateController.addListener(() {
      _onDateChanged();
    });

    await _controller.getCustomers();

    _controller.selectedCustomer.value = widget.pName;
    _controller.selectedCustomerCode.value = widget.pCode;

    await _controller.getOutstandings(
      pCode: widget.pCode,
      branchCode: widget.branchCode,
    );
  }

  void _onDateChanged() async {
    await _controller.getOutstandings(
      pCode: _controller.selectedCustomerCode.value,
      branchCode: widget.branchCode,
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
              title: 'Outstandings',
              leading: IconButton(
                onPressed: () => Get.back(),
                icon: Icon(
                  Icons.arrow_back_ios,
                  size: 25,
                  color: kColorTextPrimary,
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    _controller.downloadOutstandings();
                  },
                  icon: Icon(
                    Icons.file_download_outlined,
                    color: kColorTextPrimary,
                    size: 25,
                  ),
                ),
              ],
            ),
            body: Padding(
              padding: AppPaddings.p10,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 0.4.screenWidth,
                        child: AppDatePickerTextFormField(
                          dateController: _controller.fromDateController,
                          hintText: 'From Date',
                          fillColor: kColorWhite,
                        ),
                      ),
                      SizedBox(
                        width: 0.4.screenWidth,
                        child: AppDatePickerTextFormField(
                          dateController: _controller.toDateController,
                          hintText: 'To Date',
                          fillColor: kColorWhite,
                        ),
                      )
                    ],
                  ),
                  AppSpaces.v10,
                  Obx(
                    () => AppDropdown(
                      fillColor: kColorWhite,
                      items: _controller.customerNames,
                      selectedItem:
                          _controller.selectedCustomer.value.isNotEmpty
                              ? _controller.selectedCustomer.value
                              : null,
                      hintText: 'Select Customer',
                      searchHintText: 'Search Customer',
                      onChanged: (value) {
                        _controller.onCustomerSelected(
                          value!,
                          widget.branchCode,
                        );
                      },
                    ),
                  ),
                  AppSpaces.v10,
                  Obx(
                    () {
                      if (_controller.outstandings.isEmpty ||
                          _controller.isLoading.value) {
                        return SizedBox.shrink();
                      }

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Outstanding',
                            style: TextStyles.kMediumFredoka(
                              fontSize: FontSizes.k18FontSize,
                              color: kColorTextPrimary,
                            ),
                          ),
                          Text(
                            _controller.outstandingAmount.value.toString(),
                            style: TextStyles.kMediumFredoka(
                              fontSize: FontSizes.k18FontSize,
                              color: _controller.outstandingAmount.value
                                      .contains('-')
                                  ? kColorRed
                                  : kColorBlue,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  AppSpaces.v10,
                  Obx(
                    () {
                      if (_controller.isLoading.value) {
                        return const SizedBox.shrink();
                      }
                      if (_controller.outstandings.isEmpty &&
                          !_controller.isLoading.value) {
                        return Expanded(
                          child: Center(
                            child: Text(
                              'No outstandings found.',
                              style: TextStyles.kMediumFredoka(
                                color: kColorTextPrimary,
                              ),
                            ),
                          ),
                        );
                      }
                      return Expanded(
                        child: ListView.builder(
                          itemCount: _controller.outstandings.length,
                          itemBuilder: (context, index) {
                            final outstanding = _controller.outstandings[index];

                            return Column(
                              children: [
                                AppCard2(
                                  child: Padding(
                                    padding: AppPaddings.p8,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          outstanding.invNo,
                                          style: TextStyles.kMediumFredoka(
                                            fontSize: FontSizes.k16FontSize,
                                            color: kColorTextPrimary,
                                          ).copyWith(
                                            height: 1.25,
                                          ),
                                        ),
                                        Text(
                                          outstanding.date,
                                          style: TextStyles.kRegularFredoka(
                                            fontSize: FontSizes.k14FontSize,
                                            color: kColorTextPrimary,
                                          ).copyWith(
                                            height: 1.25,
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            OutstandingRow(
                                              title: 'Amount',
                                              value:
                                                  outstanding.amount.toString(),
                                            ),
                                            OutstandingRow(
                                              title: 'Outstanding',
                                              value: outstanding.outstanding
                                                  .toString(),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            OutstandingRow(
                                              title: 'Paid',
                                              value: outstanding.paidAmount,
                                            ),
                                            Text(
                                              outstanding.runningTotal,
                                              style: TextStyles.kMediumFredoka(
                                                color: outstanding.runningTotal
                                                        .contains('-')
                                                    ? kColorRed
                                                    : kColorBlue,
                                                fontSize: FontSizes.k16FontSize,
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                AppSpaces.v2,
                              ],
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
