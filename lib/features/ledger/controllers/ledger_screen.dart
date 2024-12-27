import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreeji_dairy/constants/color_constants.dart';
import 'package:shreeji_dairy/features/ledger/controllers/ledger_controller.dart';
import 'package:shreeji_dairy/styles/font_sizes.dart';
import 'package:shreeji_dairy/styles/text_styles.dart';
import 'package:shreeji_dairy/utils/extensions/app_size_extensions.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_paddings.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_spacings.dart';
import 'package:shreeji_dairy/widgets/app_appbar.dart';
import 'package:shreeji_dairy/widgets/app_date_picker_field.dart';
import 'package:shreeji_dairy/widgets/app_dropdown.dart';

class LedgerScreen extends StatelessWidget {
  LedgerScreen({
    super.key,
  });

  final LedgerController _controller = Get.put(
    LedgerController(),
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: kColorWhite,
        appBar: AppAppbar(
          title: 'Ledger',
        ),
        body: Obx(
          () {
            if (_controller.ledgerEntries.isEmpty) {
              return Center(child: CircularProgressIndicator());
            } else {
              return Padding(
                padding: AppPaddings.p10,
                child: Column(
                  children: [
                    Obx(
                      () => AppDropdown(
                        fillColor: kColorWhite,
                        items: _controller.customers,
                        selectedItem:
                            _controller.selectedCustomer.value.isNotEmpty
                                ? _controller.selectedCustomer.value
                                : null,
                        hintText: 'Select Customer',
                        searchHintText: 'Search Customer',
                        onChanged: (value) {},
                      ),
                    ),
                    AppSpaces.v10,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 0.45.screenWidth,
                          child: AppDatePickerTextFormField(
                            dateController: TextEditingController(),
                            hintText: 'From Date',
                            fillColor: kColorWhite,
                          ),
                        ),
                        SizedBox(
                          width: 0.45.screenWidth,
                          child: AppDatePickerTextFormField(
                            dateController: TextEditingController(),
                            hintText: 'To Date',
                            fillColor: kColorWhite,
                          ),
                        ),
                      ],
                    ),
                    AppSpaces.v10,
                    Expanded(
                      child: ListView(
                        children: [
                          Card(
                            elevation: 2.5,
                            color: kColorLightGrey,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: AppPaddings.p10,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Opening Balance',
                                    style: TextStyles.kMediumFredoka(
                                      color: kColorSecondary,
                                      fontSize: FontSizes.k18FontSize,
                                    ).copyWith(
                                      height: 1.25,
                                    ),
                                  ),
                                  Text(
                                    '₹ 12,34,5678',
                                    style: TextStyles.kMediumFredoka(
                                      color: kColorSecondary,
                                      fontSize: FontSizes.k18FontSize,
                                    ).copyWith(
                                      height: 1.25,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          AppSpaces.v10,
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: _controller.ledgerEntries.length,
                            itemBuilder: (context, index) {
                              final entry = _controller.ledgerEntries[index];
                              return Card(
                                elevation: 2.5,
                                color: kColorLightGrey,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: ListTile(
                                  minVerticalPadding: 5,
                                  title: Text(
                                    entry.pnamec,
                                    style: TextStyles.kMediumFredoka(
                                      color: kColorTextPrimary,
                                      fontSize: FontSizes.k18FontSize,
                                    ).copyWith(
                                      height: 1.25,
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        entry.invno,
                                        style: TextStyles.kRegularFredoka(
                                          color: kColorTextPrimary,
                                          fontSize: FontSizes.k14FontSize,
                                        ),
                                      ),
                                      Text(
                                        entry.date,
                                        style: TextStyles.kRegularFredoka(
                                          color: kColorTextPrimary,
                                          fontSize: FontSizes.k14FontSize,
                                        ),
                                      ),
                                    ],
                                  ),
                                  trailing: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      if (entry.debit != 0.0 &&
                                          entry.credit == 0.0)
                                        Text(
                                          '- ${entry.debit.toStringAsFixed(2)}',
                                          style: TextStyles.kMediumFredoka(
                                            color: kColorRed,
                                          ),
                                        ),
                                      if (entry.credit != 0.0 &&
                                          entry.debit == 0.0)
                                        Text(
                                          '+ ${entry.credit.toStringAsFixed(2)}',
                                          style: TextStyles.kMediumFredoka(
                                            color: Colors.green,
                                          ),
                                        ),
                                      Text(
                                        'Bal: ${entry.balance}',
                                        style: TextStyles.kMediumFredoka(
                                          color: kColorTextPrimary,
                                          fontSize: FontSizes.k18FontSize,
                                        ),
                                      ),
                                    ],
                                  ),
                                  onTap: () {},
                                ),
                              );
                            },
                          ),
                          AppSpaces.v10,
                          Card(
                            elevation: 2.5,
                            color: kColorLightGrey,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: AppPaddings.p10,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Closing Balance',
                                    style: TextStyles.kMediumFredoka(
                                      color: kColorSecondary,
                                      fontSize: FontSizes.k18FontSize,
                                    ).copyWith(
                                      height: 1.25,
                                    ),
                                  ),
                                  Text(
                                    '₹ 12,34,5678',
                                    style: TextStyles.kMediumFredoka(
                                      color: kColorSecondary,
                                      fontSize: FontSizes.k18FontSize,
                                    ).copyWith(
                                      height: 1.25,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
