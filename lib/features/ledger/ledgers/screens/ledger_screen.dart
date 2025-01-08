import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shreeji_dairy/constants/color_constants.dart';
import 'package:shreeji_dairy/features/ledger/ledgers/controllers/ledger_controller.dart';
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

class LedgerScreen extends StatefulWidget {
  const LedgerScreen({
    super.key,
    required this.pCode,
    required this.pName,
  });

  final String pCode;
  final String pName;

  @override
  State<LedgerScreen> createState() => _LedgerScreenState();
}

class _LedgerScreenState extends State<LedgerScreen> {
  final LedgerController _controller = Get.put(
    LedgerController(),
  );

  @override
  void initState() {
    super.initState();
    initialize();
  }

  void initialize() async {
    await _controller.getCustomers();

    final DateFormat dateFormat = DateFormat('dd-MM-yyyy');

    int currentYear = DateTime.now().year;
    int startYear = DateTime.now().month < 4 ? currentYear - 1 : currentYear;
    int endYear = startYear + 1;

    _controller.fromDateController.text = dateFormat.format(
      DateTime(startYear, 4, 1),
    );

    _controller.toDateController.text = dateFormat.format(
      DateTime(endYear, 3, 31),
    );

    _controller.selectedCustomer.value = widget.pName;
    _controller.selectedCustomerCode.value = widget.pCode;

    await _controller.getLedger();

    _controller.fromDateController.addListener(_controller.getLedger);
    _controller.toDateController.addListener(_controller.getLedger);
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
              title: 'Ledger',
            ),
            body: Padding(
              padding: AppPaddings.p10,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(
                        () => SizedBox(
                          width: 0.75.screenWidth,
                          child: AppDropdown(
                            fillColor: kColorWhite,
                            items: _controller.customerNames,
                            selectedItem:
                                _controller.selectedCustomer.value.isNotEmpty
                                    ? _controller.selectedCustomer.value
                                    : null,
                            hintText: 'Select Customer',
                            searchHintText: 'Search Customer',
                            onChanged: (value) {
                              _controller.onCustomerSelected(value!);
                            },
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.filter_list,
                          color: kColorTextPrimary,
                          size: 30,
                        ),
                        onPressed: () => showFilterBottomSheet(context),
                      ),
                    ],
                  ),
                  AppSpaces.v10,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 0.45.screenWidth,
                        child: AppDatePickerTextFormField(
                          dateController: _controller.fromDateController,
                          hintText: 'From Date',
                          fillColor: kColorWhite,
                        ),
                      ),
                      SizedBox(
                        width: 0.45.screenWidth,
                        child: AppDatePickerTextFormField(
                          dateController: _controller.toDateController,
                          hintText: 'To Date',
                          fillColor: kColorWhite,
                        ),
                      ),
                    ],
                  ),
                  AppSpaces.v10,
                  Obx(
                    () => _controller.ledgerData.isNotEmpty &&
                            _controller.isLoading.value == false
                        ? AppCard2(
                            child: Padding(
                              padding: AppPaddings.p8,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _controller.ledgerData.first.remarks!,
                                    style: TextStyles.kMediumFredoka(
                                      color: kColorTextPrimary,
                                      fontSize: FontSizes.k18FontSize,
                                    ),
                                  ),
                                  Text(
                                    _controller.ledgerData.first.balance!,
                                    style: TextStyles.kMediumFredoka(
                                      color: kColorTextPrimary,
                                      fontSize: FontSizes.k18FontSize,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                  Obx(
                    () => _controller.ledgerData.isNotEmpty &&
                            !_controller.isLoading.value
                        ? Expanded(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: _controller.ledgerData
                                  .where((ledger) =>
                                      ledger.invNo != null &&
                                      ledger.invNo!
                                          .isNotEmpty) // Filter out empty or null invNo
                                  .map((ledger) => ledger.invNo)
                                  .toSet()
                                  .length, // Only count unique invNo
                              itemBuilder: (context, index) {
                                // Get unique invNo list (filtered for non-null and non-empty invNo)
                                final uniqueInvNos = _controller.ledgerData
                                    .where((ledger) =>
                                        ledger.invNo != null &&
                                        ledger.invNo!.isNotEmpty)
                                    .map((ledger) => ledger.invNo)
                                    .toSet()
                                    .toList();

                                // Find all ledger entries that match this unique invNo
                                final filteredLedgerData = _controller
                                    .ledgerData
                                    .where((ledger) =>
                                        ledger.invNo == uniqueInvNos[index])
                                    .toList();

                                final ledger = filteredLedgerData
                                    .first; // Get the first entry for this invNo

                                // Flag to check if this is the first occurrence of invNo
                                bool isFirstOccurrence =
                                    filteredLedgerData.indexOf(ledger) == 0;

                                return AppCard2(
                                  child: Padding(
                                    padding: AppPaddings.p10,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // For the first occurrence, show pnameC or remarks
                                        isFirstOccurrence
                                            ? ledger.pnameC != null &&
                                                    ledger.pnameC!.isNotEmpty
                                                ? Text(
                                                    ledger.pnameC!,
                                                    style: TextStyles
                                                        .kMediumFredoka(
                                                      color: kColorTextPrimary,
                                                      fontSize:
                                                          FontSizes.k18FontSize,
                                                    ).copyWith(height: 1),
                                                  )
                                                : (ledger.remarks != null &&
                                                        ledger
                                                            .remarks!.isNotEmpty
                                                    ? Text(
                                                        ledger.remarks!,
                                                        style: TextStyles
                                                            .kMediumFredoka(
                                                          color:
                                                              kColorTextPrimary,
                                                          fontSize: FontSizes
                                                              .k18FontSize,
                                                        ).copyWith(height: 1),
                                                      )
                                                    : SizedBox.shrink())
                                            : SizedBox.shrink(),

                                        // Main content row (invNo, date, debit/credit, balance)
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  ledger.invNo!,
                                                  style: TextStyles
                                                      .kRegularFredoka(
                                                    color: kColorTextPrimary,
                                                    fontSize:
                                                        FontSizes.k16FontSize,
                                                  ).copyWith(height: 1.25),
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      ledger.date!,
                                                      style: TextStyles
                                                          .kRegularFredoka(
                                                        color:
                                                            kColorTextPrimary,
                                                        fontSize: FontSizes
                                                            .k16FontSize,
                                                      ).copyWith(height: 1.25),
                                                    ),
                                                    AppSpaces.h4,
                                                    Text(
                                                      ledger.dbc!,
                                                      style: TextStyles
                                                          .kRegularFredoka(
                                                        color:
                                                            kColorTextPrimary,
                                                        fontSize: FontSizes
                                                            .k16FontSize,
                                                      ).copyWith(height: 1.25),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                ledger.credit! == 0.00
                                                    ? Text(
                                                        ledger.debit!
                                                            .toString(),
                                                        style: TextStyles
                                                            .kMediumFredoka(
                                                          color: kColorRed,
                                                          fontSize: FontSizes
                                                              .k18FontSize,
                                                        ).copyWith(
                                                            height: 1.25),
                                                      )
                                                    : Text(
                                                        ledger.credit!
                                                            .toString(),
                                                        style: TextStyles
                                                            .kMediumFredoka(
                                                          color: Colors.green,
                                                          fontSize: FontSizes
                                                              .k18FontSize,
                                                        ).copyWith(
                                                            height: 1.25),
                                                      ),
                                                Text(
                                                  'Bal : ${ledger.balance}',
                                                  style:
                                                      TextStyles.kMediumFredoka(
                                                    color: kColorTextPrimary,
                                                    fontSize:
                                                        FontSizes.k18FontSize,
                                                  ).copyWith(height: 1.25),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        if (ledger.pnameC != null &&
                                            ledger.pnameC!.isNotEmpty)
                                          Text(
                                            ledger.remarks!,
                                            style: TextStyles.kRegularFredoka(
                                              color: kColorTextPrimary,
                                              fontSize: FontSizes.k16FontSize,
                                            ).copyWith(
                                              height: 1.25,
                                            ),
                                            maxLines: 2,
                                          ),

                                        // For subsequent occurrences of the same invNo, show pnameC below the date
                                        for (var subLedger
                                            in filteredLedgerData.skip(1))
                                          if (subLedger.pnameC != null &&
                                              subLedger.pnameC!.isNotEmpty)
                                            Padding(
                                              padding: AppPaddings.custom(
                                                  left: 10.appWidth),
                                              child: Text(
                                                subLedger.pnameC!,
                                                style:
                                                    TextStyles.kRegularFredoka(
                                                  color: kColorTextPrimary,
                                                  fontSize:
                                                      FontSizes.k16FontSize,
                                                ).copyWith(height: 1.25),
                                              ),
                                            ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                  Obx(
                    () {
                      final closingBalance = _controller.ledgerData.firstWhere(
                        (ledg) =>
                            ledg.remarks != null &&
                            ledg.remarks!.toLowerCase() == 'closing balance',
                      );

                      return _controller.ledgerData.isNotEmpty &&
                              !_controller.isLoading.value
                          ? AppCard2(
                              child: Padding(
                                padding: AppPaddings.p10,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      closingBalance.remarks ?? '',
                                      style: TextStyles.kMediumFredoka(
                                        color: kColorTextPrimary,
                                        fontSize: FontSizes.k18FontSize,
                                      ),
                                    ),
                                    Text(
                                      closingBalance.credit == 0.00
                                          ? closingBalance.debit.toString()
                                          : closingBalance.credit.toString(),
                                      style: TextStyles.kMediumFredoka(
                                        color: kColorTextPrimary,
                                        fontSize: FontSizes.k18FontSize,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : const SizedBox.shrink();
                    },
                  ),
                  AppSpaces.v60,
                  AppSpaces.v16,
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

  void showFilterBottomSheet(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: AppPaddings.p16,
        decoration: BoxDecoration(
          color: kColorWhite,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(10),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Filter Invoices',
              style: TextStyles.kMediumFredoka(
                color: kColorTextPrimary,
              ),
            ),
            AppSpaces.v10,

            // Switch for Show Bill Detail
            Obx(() {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Show Bill Detail',
                    style: TextStyles.kRegularFredoka(color: kColorTextPrimary),
                  ),
                  Switch(
                    value: _controller.showBillDtl.value,
                    onChanged: (value) {
                      _controller.showBillDtl.value = value;
                      _controller.getLedger(); // Call getLedger when changed
                      Get.back(); // Close the bottom sheet
                    },
                  ),
                ],
              );
            }),
            AppSpaces.v10,

            // Switch for Show Item Detail
            Obx(() {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Show Item Detail',
                    style: TextStyles.kRegularFredoka(color: kColorTextPrimary),
                  ),
                  Switch(
                    value: _controller.showItemDtl.value,
                    onChanged: (value) {
                      _controller.showItemDtl.value = value;
                      _controller.getLedger(); // Call getLedger when changed
                      Get.back(); // Close the bottom sheet
                    },
                  ),
                ],
              );
            }),
            AppSpaces.v10,

            // Switch for Show Sign
            Obx(() {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Show Sign',
                    style: TextStyles.kRegularFredoka(color: kColorTextPrimary),
                  ),
                  Switch(
                    value: _controller.showSign.value,
                    onChanged: (value) {
                      _controller.showSign.value = value;
                      _controller.getLedger(); // Call getLedger when changed
                      Get.back(); // Close the bottom sheet
                    },
                  ),
                ],
              );
            }),
            AppSpaces.v20,
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
}
