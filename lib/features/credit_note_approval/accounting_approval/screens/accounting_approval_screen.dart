import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreeji_dairy/constants/color_constants.dart';
import 'package:shreeji_dairy/constants/image_constants.dart';
import 'package:shreeji_dairy/features/credit_note_approval/accounting_approval/controllers/accounting_approval_controller.dart';
import 'package:shreeji_dairy/features/credit_note_approval/dock_approval/models/item_for_approval_dm.dart';
import 'package:shreeji_dairy/styles/font_sizes.dart';
import 'package:shreeji_dairy/styles/text_styles.dart';
import 'package:shreeji_dairy/utils/dialogs/app_dialogs.dart';
import 'package:shreeji_dairy/utils/extensions/app_size_extensions.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_paddings.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_spacings.dart';
import 'package:shreeji_dairy/widgets/app_appbar.dart';
import 'package:shreeji_dairy/widgets/app_button.dart';
import 'package:shreeji_dairy/widgets/app_card1.dart';
import 'package:shreeji_dairy/widgets/app_loading_overlay.dart';
import 'package:shreeji_dairy/widgets/app_text_form_field.dart';
import 'package:shreeji_dairy/widgets/app_title_value_row.dart';

class AccountingApprovalScreen extends StatefulWidget {
  const AccountingApprovalScreen({
    super.key,
  });

  @override
  State<AccountingApprovalScreen> createState() =>
      _AccountingApprovalScreenState();
}

class _AccountingApprovalScreenState extends State<AccountingApprovalScreen> {
  final AccountingApprovalController _controller = Get.put(
    AccountingApprovalController(),
  );

  @override
  void initState() {
    super.initState();
    _controller.getItemsForApproval();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          child: Scaffold(
            backgroundColor: kColorWhite,
            appBar: AppAppbar(
              title: 'Accounting Approval',
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
              padding: AppPaddings.p12,
              child: Column(
                children: [
                  Obx(
                    () {
                      if (_controller.itemsForApproval.isEmpty &&
                          !_controller.isLoading.value) {
                        return Expanded(
                          child: Center(
                            child: Text(
                              'No credit notes found.',
                              style: TextStyles.kRegularFredoka(),
                            ),
                          ),
                        );
                      }
                      return Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: _controller.itemsForApproval.length,
                          itemBuilder: (context, index) {
                            final item = _controller.itemsForApproval[index];

                            return AppCard1(
                              child: Padding(
                                padding: AppPaddings.p10,
                                child: Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                showImagePreview(
                                                    item.imagePath!);
                                              },
                                              child: Material(
                                                elevation: 5,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child: Image.network(
                                                    item.imagePath!
                                                            .startsWith('http')
                                                        ? item.imagePath!
                                                        : 'http://${item.imagePath!}',
                                                    width: 100,
                                                    height: 100,
                                                    fit: BoxFit.cover,
                                                    errorBuilder: (context,
                                                        error, stackTrace) {
                                                      return Image.asset(
                                                        kImageLogo,
                                                        width: 100,
                                                        height: 100,
                                                        fit: BoxFit.cover,
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ),
                                            AppSpaces.v10,
                                            InkWell(
                                              onTap: () async {
                                                _controller.showQcDetails
                                                    .value = false;
                                                await _controller.getQcDetails(
                                                  id: item.id.toString(),
                                                );
                                                _showDockDetails(item);
                                              },
                                              child: Text(
                                                'Approval\nHistory',
                                                style:
                                                    TextStyles.kRegularFredoka(
                                                  fontSize:
                                                      FontSizes.k16FontSize,
                                                  color: kColorSecondary,
                                                ).copyWith(
                                                  height: 1,
                                                  decoration:
                                                      TextDecoration.underline,
                                                  decorationColor:
                                                      kColorSecondary,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ],
                                        ),
                                        AppSpaces.h10,
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                item.iName != null &&
                                                        item.iName!.isNotEmpty
                                                    ? item.iName!
                                                    : '',
                                                style:
                                                    TextStyles.kMediumFredoka(
                                                  fontSize:
                                                      FontSizes.k16FontSize,
                                                ),
                                              ),
                                              AppTitleValueRow(
                                                title: 'Party',
                                                value: item.pName != null &&
                                                        item.pName!.isNotEmpty
                                                    ? item.pName!
                                                    : '',
                                              ),
                                              AppTitleValueRow(
                                                title: 'CRNT No',
                                                value: item.invNo != null &&
                                                        item.invNo!.isNotEmpty
                                                    ? item.invNo!
                                                    : '',
                                              ),
                                              AppTitleValueRow(
                                                title: 'Entry Date',
                                                value: item.date != null &&
                                                        item.date!.isNotEmpty
                                                    ? item.date!
                                                    : '',
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  AppTitleValueRow(
                                                    title: 'Qty',
                                                    value: item.qty != null &&
                                                            item.qty!
                                                                .toString()
                                                                .isNotEmpty
                                                        ? item.qty!.toString()
                                                        : '0',
                                                  ),
                                                  AppTitleValueRow(
                                                    title: 'Weight',
                                                    value:
                                                        item.weight != null &&
                                                                item.weight!
                                                                    .toString()
                                                                    .isNotEmpty
                                                            ? item.weight!
                                                                .toString()
                                                            : '0.0',
                                                  ),
                                                ],
                                              ),
                                              AppTitleValueRow(
                                                title: 'Bill No.',
                                                value: item.billNo != null &&
                                                        item.billNo!.isNotEmpty
                                                    ? item.billNo!
                                                    : '',
                                              ),
                                              if (item.reason != null &&
                                                  item.reason!.isNotEmpty)
                                                AppTitleValueRow(
                                                  title: 'Reason',
                                                  value: item.reason!,
                                                ),
                                              AppTitleValueRow(
                                                title: 'Status',
                                                value: item.status != null &&
                                                        item.status!
                                                            .toString()
                                                            .isNotEmpty
                                                    ? item.statusText
                                                    : '',
                                              ),
                                              AppSpaces.v10,
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  AppButton(
                                                    buttonWidth:
                                                        0.25.screenWidth,
                                                    buttonHeight: 35,
                                                    buttonColor:
                                                        kColorSecondary,
                                                    title: 'Accept',
                                                    titleSize:
                                                        FontSizes.k16FontSize,
                                                    onPressed: () {
                                                      _controller.rateController
                                                          .clear();
                                                      _controller
                                                          .remarkController
                                                          .clear();
                                                      showDialog(
                                                        context: Get.context!,
                                                        builder: (BuildContext
                                                            context) {
                                                          return Dialog(
                                                            backgroundColor:
                                                                kColorWhite,
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                            ),
                                                            child: Padding(
                                                              padding:
                                                                  AppPaddings
                                                                      .p20,
                                                              child: Form(
                                                                key: _controller
                                                                    .approveAccountingFormKey,
                                                                child: Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    AppTextFormField(
                                                                      controller:
                                                                          _controller
                                                                              .rateController,
                                                                      hintText:
                                                                          'Percentage',
                                                                      keyboardType:
                                                                          TextInputType
                                                                              .number,
                                                                      validator:
                                                                          (value) {
                                                                        if (value ==
                                                                                null ||
                                                                            value.isEmpty) {
                                                                          return 'Please enter a rate';
                                                                        }
                                                                        return null;
                                                                      },
                                                                    ),
                                                                    AppSpaces
                                                                        .v10,
                                                                    AppTextFormField(
                                                                      controller:
                                                                          _controller
                                                                              .remarkController,
                                                                      hintText:
                                                                          'Remark',
                                                                    ),
                                                                    AppSpaces
                                                                        .v10,
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .end,
                                                                      children: [
                                                                        AppButton(
                                                                          buttonWidth:
                                                                              0.25.screenWidth,
                                                                          buttonHeight:
                                                                              35,
                                                                          buttonColor:
                                                                              kColorSecondary,
                                                                          title:
                                                                              'Save',
                                                                          titleSize:
                                                                              FontSizes.k16FontSize,
                                                                          onPressed:
                                                                              () async {
                                                                            if (_controller.approveAccountingFormKey.currentState!.validate()) {
                                                                              await _controller.approveAccounting(
                                                                                id: item.id!,
                                                                              );
                                                                            }
                                                                          },
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    },
                                                  ),
                                                ],
                                              ),
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

  void _showDockDetails(ItemForApprovalDm item) {
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: kColorWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(
              color: kColorTextPrimary,
            ),
          ),
          child: Padding(
            padding: AppPaddings.p20,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: 0.75 * Get.height,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dock Details',
                      style: TextStyles.kMediumFredoka(
                        fontSize: FontSizes.k18FontSize,
                        color: kColorSecondary,
                      ).copyWith(
                        decoration: TextDecoration.underline,
                        decorationColor: kColorSecondary,
                      ),
                    ),
                    AppSpaces.v10,

                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            showImagePreview(item.docImagePath!);
                          },
                          child: Material(
                            elevation: 5,
                            borderRadius: BorderRadius.circular(10),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                item.docImagePath!.startsWith('http')
                                    ? item.docImagePath!
                                    : 'http://${item.docImagePath!}',
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    kImageLogo,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        AppSpaces.h10,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppTitleValueRow(
                                title: 'Dock Date',
                                value: item.docDate?.isNotEmpty == true
                                    ? item.docDate!
                                    : 'N/A',
                              ),
                              AppTitleValueRow(
                                title: 'Dock Remark',
                                value: item.docRemark?.isNotEmpty == true
                                    ? item.docRemark!
                                    : 'N/A',
                              ),
                              AppTitleValueRow(
                                title: 'Dock Qty',
                                value:
                                    item.docQty?.toString().isNotEmpty == true
                                        ? item.docQty!.toString()
                                        : '0',
                              ),
                              AppTitleValueRow(
                                title: 'Dock Weight',
                                value: item.docWeight?.toString().isNotEmpty ==
                                        true
                                    ? item.docWeight!.toString()
                                    : '0',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    AppSpaces.v10,

                    Text(
                      'QC Details',
                      style: TextStyles.kMediumFredoka(
                        fontSize: FontSizes.k18FontSize,
                        color: kColorSecondary,
                      ).copyWith(
                        decoration: TextDecoration.underline,
                        decorationColor: kColorSecondary,
                      ),
                    ),
                    AppSpaces.v10,

                    AppTitleValueRow(
                      title: 'QC Date',
                      value: item.qcDate?.isNotEmpty == true
                          ? item.qcDate!
                          : 'N/A',
                    ),
                    AppTitleValueRow(
                      title: 'QC Status',
                      value: item.qcStatus != null
                          ? (item.qcStatus! ? 'Approved' : 'Rejected')
                          : 'N/A',
                      color: item.qcStatus != null
                          ? (item.qcStatus! ? kColorGreen : kColorRed)
                          : kColorTextPrimary,
                    ),
                    AppTitleValueRow(
                      title: 'QC Remark',
                      value: item.qcRemark?.isNotEmpty == true
                          ? item.qcRemark!
                          : 'N/A',
                    ),

                    InkWell(
                      onTap: () {
                        _controller.toggleVisibility();
                      },
                      child: Text(
                        'View QC details',
                        style: TextStyles.kRegularFredoka(
                          fontSize: FontSizes.k14FontSize,
                          color: kColorSecondary,
                        ).copyWith(
                          decoration: TextDecoration.underline,
                          decorationColor: kColorSecondary,
                        ),
                      ),
                    ),

                    Obx(
                      () => Visibility(
                        visible: _controller.showQcDetails.value,
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics:
                              NeverScrollableScrollPhysics(), // Prevent nested scrolling issues
                          itemCount: _controller.qcDetails.length,
                          itemBuilder: (context, index) {
                            final qcDetail = _controller.qcDetails[index];

                            return AppTitleValueRow(
                              title: qcDetail.testPara,
                              value: qcDetail.testResult,
                            );
                          },
                        ),
                      ),
                    ),

                    AppSpaces.v10,

                    /// 🔹 OK Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        AppButton(
                          title: 'OK',
                          titleSize: FontSizes.k16FontSize,
                          buttonWidth: 0.15 * Get.width,
                          buttonHeight: 30,
                          onPressed: () => Get.back(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
