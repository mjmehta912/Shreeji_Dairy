import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shreeji_dairy/constants/color_constants.dart';
import 'package:shreeji_dairy/features/invoice/invoices/controllers/invoices_controller.dart';
import 'package:shreeji_dairy/features/invoice/invoices/widgets/invoice_card.dart';
import 'package:shreeji_dairy/styles/text_styles.dart';
import 'package:shreeji_dairy/utils/extensions/app_size_extensions.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_paddings.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_spacings.dart';
import 'package:shreeji_dairy/widgets/app_appbar.dart';
import 'package:shreeji_dairy/widgets/app_button.dart';
import 'package:shreeji_dairy/widgets/app_date_picker_field.dart';
import 'package:shreeji_dairy/widgets/app_dropdown.dart';
import 'package:shreeji_dairy/widgets/app_loading_overlay.dart';
import 'package:shreeji_dairy/widgets/app_text_form_field.dart';

class InvoicesScreen extends StatefulWidget {
  const InvoicesScreen({
    super.key,
    required this.pCode,
    required this.pName,
  });

  final String pCode;
  final String pName;

  @override
  State<InvoicesScreen> createState() => _InvoicesScreenState();
}

class _InvoicesScreenState extends State<InvoicesScreen> {
  final InvoicesController _controller = Get.put(
    InvoicesController(),
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

    await _controller.getInvoices();

    _controller.fromDateController.addListener(_controller.getInvoices);
    _controller.toDateController.addListener(_controller.getInvoices);
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
              title: 'Invoices',
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
                            onChanged: (value) =>
                                _controller.onCustomerSelected(value!),
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
                    () {
                      if (_controller.isLoading.value) {
                        return const SizedBox.shrink();
                      }
                      if (_controller.invoices.isEmpty &&
                          !_controller.isLoading.value) {
                        return Expanded(
                          child: Center(
                            child: Text(
                              'No invoices found.',
                              style: TextStyles.kMediumFredoka(
                                color: kColorTextPrimary,
                              ),
                            ),
                          ),
                        );
                      }
                      return Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: _controller.invoices.length,
                          itemBuilder: (context, index) {
                            final invoice = _controller.invoices[index];
                            return InvoiceCard(
                              invoice: invoice,
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
              () => AppDropdown(
                fillColor: kColorWhite,
                items: [
                  'ALL',
                  'PAID',
                  'PARTLY PAID',
                  'UNPAID',
                ],
                selectedItem: _controller.selectedStatus.value,
                hintText: 'Select Status',
                showSearchBox: false,
                onChanged: (value) {
                  _controller.selectedStatus.value = value!;
                },
              ),
            ),
            AppSpaces.v10,
            AppTextFormField(
              controller: _controller.searchController,
              hintText: 'Search Inv No.',
              fillColor: kColorWhite,
            ),
            AppSpaces.v20,
            AppButton(
              onPressed: () {
                _controller.getInvoices();
                Get.back(); // Close the Bottom Sheet
              },
              buttonWidth: 0.5.screenWidth,
              buttonColor: kColorPrimary,
              titleColor: kColorTextPrimary,
              title: 'Apply Filter',
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
}
