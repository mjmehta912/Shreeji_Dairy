import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreeji_dairy/constants/color_constants.dart';
import 'package:shreeji_dairy/constants/image_constants.dart';
import 'package:shreeji_dairy/features/credit_note_approval/dock_approval/models/item_for_approval_dm.dart';
import 'package:shreeji_dairy/features/credit_note_status/controllers/credit_note_status_controller.dart';
import 'package:shreeji_dairy/features/credit_note_status/widgets/credit_note_status_card.dart';
import 'package:shreeji_dairy/styles/font_sizes.dart';
import 'package:shreeji_dairy/styles/text_styles.dart';
import 'package:shreeji_dairy/utils/dialogs/app_dialogs.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_paddings.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_spacings.dart';
import 'package:shreeji_dairy/widgets/app_appbar.dart';
import 'package:shreeji_dairy/widgets/app_button.dart';
import 'package:shreeji_dairy/widgets/app_loading_overlay.dart';
import 'package:shreeji_dairy/widgets/app_text_form_field.dart';
import 'package:shreeji_dairy/widgets/app_title_value_row.dart';

class CreditNoteStatusScreen extends StatefulWidget {
  const CreditNoteStatusScreen({
    super.key,
    required this.pCode,
    required this.pName,
  });

  final String pCode;
  final String pName;

  @override
  State<CreditNoteStatusScreen> createState() => _CreditNoteStatusScreenState();
}

class _CreditNoteStatusScreenState extends State<CreditNoteStatusScreen> {
  final CreditNoteStatusController _controller = Get.put(
    CreditNoteStatusController(),
  );

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  void _initialize() async {
    await _controller.getItemsForApproval(
      pCode: widget.pCode,
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
              title: 'Credit Note Status',
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
              padding: AppPaddings.p12,
              child: Column(
                children: [
                  AppTextFormField(
                    controller: _controller.searchController,
                    hintText: 'Search Credit Note',
                    onChanged: (value) {
                      _controller.getItemsForApproval(
                        pCode: widget.pCode,
                      );
                    },
                  ),
                  AppSpaces.v10,
                  Obx(
                    () => SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: _controller.statusOptions.map(
                          (status) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4.0,
                              ),
                              child: ChoiceChip(
                                showCheckmark: false,
                                label: Text(
                                  status["label"],
                                  style: TextStyles.kRegularFredoka(
                                    fontSize: FontSizes.k12FontSize,
                                  ),
                                ),
                                selected: _controller.selectedStatus.value ==
                                    status["value"],
                                onSelected: (selected) {
                                  if (selected) {
                                    _controller.setStatus(
                                      status["value"],
                                    );
                                  }
                                },
                                selectedColor: kColorPrimary,
                                backgroundColor: kColorWhite,
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

                            return CreditNoteStatusCard(
                              item: item,
                              onPressedApprovalHistory: () async {
                                _controller.showQcDetails.value = false;
                                await _controller.getQcDetails(
                                  id: item.id.toString(),
                                );
                                _showApprovalHistory(item);
                              },
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

  void _showApprovalHistory(
    ItemForApprovalDm item,
  ) {
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
            padding: AppPaddings.p14,
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

                    if (item.status != null && [2, 3, 4].contains(item.status))
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                            value:
                                item.qcStatus == true ? 'Approved' : 'Rejected',
                            color:
                                item.qcStatus == true ? kColorGreen : kColorRed,
                          ),
                          AppTitleValueRow(
                            title: 'QC Remark',
                            value: item.qcRemark?.isNotEmpty == true
                                ? item.qcRemark!
                                : 'N/A',
                          ),
                          Obx(
                            () => Visibility(
                              visible: _controller.qcDetails.isNotEmpty,
                              child: InkWell(
                                onTap: () => _controller.toggleVisibility(),
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
                            ),
                          ),
                          Obx(
                            () => Visibility(
                              visible: _controller.showQcDetails.value,
                              child: ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
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
                        ],
                      ),

                    if (item.status != null && [3, 4].contains(item.status))
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppSpaces.v10,
                          Text(
                            'Accounting Details',
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
                            title: 'Accounting Date',
                            value: item.accDate?.isNotEmpty == true
                                ? item.accDate!
                                : 'N/A',
                          ),
                          AppTitleValueRow(
                            title: 'Rate',
                            value: item.rate?.toString().isNotEmpty == true
                                ? item.rate!.toString()
                                : '0',
                          ),
                          AppTitleValueRow(
                            title: 'Accounting Remark',
                            value: item.accRemark?.isNotEmpty == true
                                ? item.accRemark!
                                : 'N/A',
                          ),
                        ],
                      ),

                    /// 🔹 Management Details (Only if status is 4)
                    if (item.status != null && item.status == 4)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppSpaces.v10,
                          Text(
                            'Management Details',
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
                            title: 'Approval Date',
                            value: item.approveDate?.isNotEmpty == true
                                ? item.approveDate!
                                : 'N/A',
                          ),
                          AppTitleValueRow(
                            title: 'Management Status',
                            value:
                                item.approve == true ? 'Approved' : 'Rejected',
                            color:
                                item.approve == true ? kColorGreen : kColorRed,
                          ),
                          AppTitleValueRow(
                            title: 'Approval Remark',
                            value: item.approveRemark?.isNotEmpty == true
                                ? item.approveRemark!
                                : 'N/A',
                          ),
                        ],
                      ),

                    AppSpaces.v10,
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
