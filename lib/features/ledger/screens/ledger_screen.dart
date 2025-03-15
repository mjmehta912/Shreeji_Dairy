import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shreeji_dairy/constants/color_constants.dart';
import 'package:shreeji_dairy/features/ledger/controllers/ledger_controller.dart';
import 'package:shreeji_dairy/styles/font_sizes.dart';
import 'package:shreeji_dairy/styles/text_styles.dart';
import 'package:shreeji_dairy/utils/extensions/app_size_extensions.dart';
import 'package:shreeji_dairy/utils/helpers/secure_storage_helper.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_paddings.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_spacings.dart';
import 'package:shreeji_dairy/widgets/app_appbar.dart';
import 'package:shreeji_dairy/widgets/app_button.dart';
import 'package:shreeji_dairy/widgets/app_card1.dart';
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

    String? ledgerStart = await SecureStorageHelper.read('ledgerStart');
    String? ledgerEnd = await SecureStorageHelper.read('ledgerEnd');

    DateTime today = DateTime.now();

    DateTime financialYearStart;
    if (today.month < 4) {
      financialYearStart = DateTime(today.year - 1, 4, 1);
    } else {
      financialYearStart = DateTime(today.year, 4, 1);
    }

    if (ledgerStart == null || ledgerStart.isEmpty) {
      ledgerStart = DateFormat('dd-MM-yyyy').format(financialYearStart);
    }
    if (ledgerEnd == null || ledgerEnd.isEmpty) {
      ledgerEnd = DateFormat('dd-MM-yyyy').format(today);
    }

    if (ledgerStart.isNotEmpty && ledgerEnd.isEmpty) {
      ledgerEnd = DateFormat('dd-MM-yyyy').format(today);
    }

    if (ledgerEnd.isNotEmpty && ledgerStart.isEmpty) {
      ledgerStart = DateFormat('dd-MM-yyyy').format(financialYearStart);
    }

    _controller.fromDateController.text = ledgerStart;
    _controller.toDateController.text = ledgerEnd;

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
              actions: [
                IconButton(
                  onPressed: () {
                    _controller.downloadLedger();
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
                      Obx(
                        () => SizedBox(
                          width: 0.75.screenWidth,
                          child: AppDropdown(
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
                        ),
                      ),
                      SizedBox(
                        width: 0.45.screenWidth,
                        child: AppDatePickerTextFormField(
                          dateController: _controller.toDateController,
                          hintText: 'To Date',
                        ),
                      ),
                    ],
                  ),
                  AppSpaces.v6,
                  Obx(
                    () => _controller.ledgerData.isNotEmpty &&
                            !_controller.isLoading.value &&
                            (_controller.ledgerData.first.remarks != null &&
                                _controller
                                    .ledgerData.first.remarks!.isNotEmpty &&
                                _controller.ledgerData.first.remarks!
                                    .toLowerCase()
                                    .contains('opening'))
                        ? AppCard1(
                            child: Padding(
                              padding: AppPaddings.p8,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Opening Balance',
                                    style: TextStyles.kMediumFredoka(
                                      color: kColorTextPrimary,
                                      fontSize: FontSizes.k18FontSize,
                                    ),
                                  ),
                                  Text(
                                    _controller.ledgerData.first.balance !=
                                                null &&
                                            _controller.ledgerData.first
                                                .balance!.isNotEmpty
                                        ? _controller.ledgerData.first.balance!
                                        : '0.0',
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
                                      ledger.invNo!.isNotEmpty &&
                                      ledger.isParent == 1)
                                  .toList()
                                  .length,
                              itemBuilder: (context, index) {
                                final parentEntries = _controller.ledgerData
                                    .where((ledger) =>
                                        ledger.invNo != null &&
                                        ledger.invNo!.isNotEmpty &&
                                        ledger.isParent == 1)
                                    .toList();

                                final parent = parentEntries[index];

                                final childEntries = _controller.ledgerData
                                    .where((ledger) =>
                                        ledger.invNo != null &&
                                        ledger.invNo!.isNotEmpty &&
                                        ledger.invNo == parent.invNo &&
                                        ledger.isParent == 0)
                                    .toList();

                                return AppCard1(
                                  child: Padding(
                                    padding: AppPaddings.combined(
                                      horizontal: 8.appWidth,
                                      vertical: 6.appHeight,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          parent.pnameC != null &&
                                                  parent.pnameC!.isNotEmpty
                                              ? parent.pnameC!
                                              : '',
                                          style: TextStyles.kMediumFredoka(
                                            color: kColorSecondary,
                                            fontSize: FontSizes.k16FontSize,
                                          ).copyWith(
                                            height: 1,
                                          ),
                                        ),
                                        AppSpaces.v4,
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                InkWell(
                                                  onTap: parent.dbc != null &&
                                                          parent.dbc!
                                                              .isNotEmpty &&
                                                          parent.dbc! == 'SALE'
                                                      ? () {
                                                          _controller
                                                              .downloadInvoice(
                                                            invNo:
                                                                parent.invNo!,
                                                            financialYear:
                                                                parent.finYear!,
                                                          );
                                                        }
                                                      : () {},
                                                  child: Text(
                                                    parent.invNo!,
                                                    style: TextStyles
                                                        .kRegularFredoka(
                                                      color: kColorTextPrimary,
                                                      fontSize:
                                                          FontSizes.k14FontSize,
                                                    ).copyWith(height: 1),
                                                  ),
                                                ),
                                                Text(
                                                  parent.date!,
                                                  style: TextStyles
                                                      .kRegularFredoka(
                                                    color: kColorTextPrimary,
                                                    fontSize:
                                                        FontSizes.k14FontSize,
                                                  ).copyWith(height: 1),
                                                ),
                                                AppSpaces.v4,
                                                Text(
                                                  parent.dbc!,
                                                  style:
                                                      TextStyles.kMediumFredoka(
                                                    color: kColorSecondary,
                                                    fontSize:
                                                        FontSizes.k16FontSize,
                                                  ).copyWith(height: 1),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                parent.credit! == 0.00
                                                    ? Text(
                                                        parent.debit!
                                                            .toString(),
                                                        style: TextStyles
                                                            .kMediumFredoka(
                                                          color: kColorRed,
                                                          fontSize: FontSizes
                                                              .k18FontSize,
                                                        ).copyWith(height: 1),
                                                      )
                                                    : Text(
                                                        parent.credit!
                                                            .toString(),
                                                        style: TextStyles
                                                            .kMediumFredoka(
                                                          color: Colors.green,
                                                          fontSize: FontSizes
                                                              .k18FontSize,
                                                        ).copyWith(height: 1),
                                                      ),
                                                Text(
                                                  'Bal : ${parent.balance}',
                                                  style:
                                                      TextStyles.kMediumFredoka(
                                                    color: kColorTextPrimary,
                                                    fontSize:
                                                        FontSizes.k18FontSize,
                                                  ).copyWith(height: 1),
                                                ),
                                                AppSpaces.v4,
                                              ],
                                            ),
                                          ],
                                        ),
                                        parent.remarks != null &&
                                                parent.remarks!.isNotEmpty
                                            ? Text(
                                                parent.remarks!
                                                    .replaceAll("\\n ", "\n")
                                                    .replaceAll("\\n", ''),
                                                style:
                                                    TextStyles.kRegularFredoka(
                                                  color: kColorTextPrimary,
                                                  fontSize:
                                                      FontSizes.k14FontSize,
                                                ).copyWith(
                                                  height: 1,
                                                ),
                                              )
                                            : SizedBox.shrink(),
                                        if (childEntries.isNotEmpty &&
                                            childEntries.any((child) =>
                                                child.pnameC != null &&
                                                child.pnameC!.isNotEmpty &&
                                                child.remarks!
                                                    .toLowerCase()
                                                    .contains('bill')))
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              AppSpaces.v4,
                                              Divider(
                                                color: kColorGrey,
                                                thickness: 1.0,
                                              ),
                                              Text(
                                                'Bill Detail',
                                                style:
                                                    TextStyles.kMediumFredoka(
                                                  color: kColorTextPrimary,
                                                  fontSize:
                                                      FontSizes.k16FontSize,
                                                ).copyWith(
                                                  height: 1,
                                                ),
                                              ),
                                              AppSpaces.v2,
                                            ],
                                          ),
                                        for (var child in childEntries)
                                          if (child.pnameC != null &&
                                              child.pnameC!.isNotEmpty &&
                                              child.remarks!
                                                  .toLowerCase()
                                                  .contains('bill'))
                                            Padding(
                                              padding: AppPaddings.pv2,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    child.pnameC ?? '',
                                                    style: TextStyles
                                                        .kRegularFredoka(
                                                      color: kColorTextPrimary,
                                                      fontSize:
                                                          FontSizes.k14FontSize,
                                                    ).copyWith(
                                                      height: 1,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                        if (childEntries.isNotEmpty &&
                                            childEntries.any((child) =>
                                                child.pnameC != null &&
                                                child.pnameC!.isNotEmpty &&
                                                child.remarks!
                                                    .toLowerCase()
                                                    .contains('item')))
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Divider(
                                                color: kColorGrey,
                                                thickness: 1.0,
                                              ),
                                              Text(
                                                'Item Detail',
                                                style:
                                                    TextStyles.kMediumFredoka(
                                                  color: kColorTextPrimary,
                                                  fontSize:
                                                      FontSizes.k16FontSize,
                                                ).copyWith(
                                                  height: 1,
                                                ),
                                              ),
                                              AppSpaces.v2,
                                            ],
                                          ),
                                        for (var child in childEntries)
                                          if (child.pnameC != null &&
                                              child.pnameC!.isNotEmpty &&
                                              child.remarks!
                                                  .toLowerCase()
                                                  .contains('item'))
                                            Padding(
                                              padding: AppPaddings.pv2,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    child.pnameC ?? '',
                                                    style: TextStyles
                                                        .kRegularFredoka(
                                                      color: kColorTextPrimary,
                                                      fontSize:
                                                          FontSizes.k14FontSize,
                                                    ).copyWith(
                                                      height: 1,
                                                    ),
                                                  ),
                                                ],
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
                      if (_controller.ledgerData.isEmpty ||
                          _controller.isLoading.value) {
                        return const SizedBox.shrink();
                      }

                      final closingBalance = _controller.ledgerData.firstWhere(
                        (ledg) =>
                            ledg.remarks != null &&
                            ledg.remarks!.toLowerCase() == 'closing balance',
                      );

                      return AppCard1(
                        child: Padding(
                          padding: AppPaddings.p10,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Closing Balance',
                                style: TextStyles.kMediumFredoka(
                                  color: kColorTextPrimary,
                                  fontSize: FontSizes.k18FontSize,
                                ),
                              ),
                              Text(
                                closingBalance.balance != null &&
                                        closingBalance.balance!.isNotEmpty
                                    ? closingBalance.balance!
                                    : '0.0',
                                style: TextStyles.kMediumFredoka(
                                  color: kColorTextPrimary,
                                  fontSize: FontSizes.k18FontSize,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  AppSpaces.v60,
                  AppSpaces.v14,
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
            Obx(
              () {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Show Bill Detail',
                      style: TextStyles.kRegularFredoka(
                        color: kColorTextPrimary,
                      ),
                    ),
                    Switch(
                      activeTrackColor: kColorSecondary,
                      value: _controller.showBillDtl.value,
                      onChanged: (value) {
                        _controller.showBillDtl.value = value;
                      },
                    ),
                  ],
                );
              },
            ),
            AppSpaces.v10,
            Obx(
              () {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Show Item Detail',
                      style:
                          TextStyles.kRegularFredoka(color: kColorTextPrimary),
                    ),
                    Switch(
                      activeTrackColor: kColorSecondary,
                      value: _controller.showItemDtl.value,
                      onChanged: (value) {
                        _controller.showItemDtl.value = value;
                      },
                    ),
                  ],
                );
              },
            ),
            AppSpaces.v10,
            Obx(
              () {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '+ / -',
                      style:
                          TextStyles.kRegularFredoka(color: kColorTextPrimary),
                    ),
                    Switch(
                      activeTrackColor: kColorSecondary,
                      value: _controller.showSign.value,
                      onChanged: (value) {
                        _controller.showSign.value = value;
                      },
                    ),
                  ],
                );
              },
            ),
            AppSpaces.v20,
            AppButton(
              onPressed: () {
                _controller.getLedger();
                Get.back();
              },
              title: 'Apply Filter',
              buttonWidth: 0.5.screenWidth,
              buttonColor: kColorPrimary,
              titleColor: kColorTextPrimary,
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
}
