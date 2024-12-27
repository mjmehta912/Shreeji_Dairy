import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreeji_dairy/constants/color_constants.dart';
import 'package:shreeji_dairy/features/invoice/invoices/controllers/invoices_controller.dart';
import 'package:shreeji_dairy/styles/font_sizes.dart';
import 'package:shreeji_dairy/styles/text_styles.dart';
import 'package:shreeji_dairy/utils/extensions/app_size_extensions.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_paddings.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_spacings.dart';
import 'package:shreeji_dairy/widgets/app_appbar.dart';
import 'package:shreeji_dairy/widgets/app_button.dart';
import 'package:shreeji_dairy/widgets/app_date_picker_field.dart';
import 'package:shreeji_dairy/widgets/app_dropdown.dart';

class InvoicesScreen extends StatelessWidget {
  InvoicesScreen({
    super.key,
  });

  final InvoicesController _controller = Get.put(
    InvoicesController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kColorWhite,
      appBar: AppAppbar(
        title: 'Invoices',
      ),
      body: Obx(
        () {
          if (_controller.invoices.isEmpty) {
            return Center(
              child: CircularProgressIndicator(),
            );
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
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _controller.invoices.length,
                      itemBuilder: (context, index) {
                        final entry = _controller.invoices[index];
                        return Card(
                          elevation: 2.5,
                          color: kColorLightGrey,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: AppPaddings.p10,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: 0.4.screenWidth,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            entry.pname,
                                            style: TextStyles.kMediumFredoka(
                                              color: kColorTextPrimary,
                                              fontSize: FontSizes.k18FontSize,
                                            ).copyWith(
                                              height: 1.25,
                                            ),
                                          ),
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
                                    ),
                                    SizedBox(
                                      width: 0.4.screenWidth,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            '₹ ${entry.amount.toString()}',
                                            style: TextStyles.kMediumFredoka(
                                              color: kColorTextPrimary,
                                              fontSize: FontSizes.k18FontSize,
                                            ).copyWith(
                                              height: 1.25,
                                            ),
                                          ),
                                          AppSpaces.v6,
                                          SizedBox(
                                            width: 0.2.screenWidth,
                                            height: 30,
                                            child: AppButton(
                                              title: 'View',
                                              titleSize: FontSizes.k14FontSize,
                                              titleColor: kColorBlack,
                                              buttonColor: kColorPrimary,
                                              onPressed: () {},
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
