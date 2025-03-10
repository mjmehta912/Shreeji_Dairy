import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreeji_dairy/constants/color_constants.dart';
import 'package:shreeji_dairy/constants/image_constants.dart';
import 'package:shreeji_dairy/features/credit_note_approval/dock_approval/models/item_for_approval_dm.dart';
import 'package:shreeji_dairy/features/credit_note_status/controllers/credit_note_status_controller.dart';
import 'package:shreeji_dairy/styles/font_sizes.dart';
import 'package:shreeji_dairy/styles/text_styles.dart';
import 'package:shreeji_dairy/utils/extensions/app_size_extensions.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_paddings.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_spacings.dart';
import 'package:shreeji_dairy/widgets/app_appbar.dart';
import 'package:shreeji_dairy/widgets/app_button.dart';
import 'package:shreeji_dairy/widgets/app_card1.dart';
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              child: ChoiceChip(
                                showCheckmark: false,
                                label: Text(
                                  status["label"],
                                  style: TextStyles.kRegularFredoka(
                                    fontSize: FontSizes.k14FontSize,
                                  ),
                                ),
                                selected: _controller.selectedStatus.value ==
                                    status["value"],
                                onSelected: (selected) {
                                  if (selected) {
                                    _controller.setStatus(status["value"]);
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

                            return AppCard1(
                              child: Padding(
                                padding: AppPaddings.p10,
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            _showImagePreview(item.imagePath!);
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
                                                errorBuilder: (context, error,
                                                    stackTrace) {
                                                  return Image.asset(
                                                    kImageLogo,
                                                    width: 80,
                                                    height: 80,
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
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              AppTitleValueRow(
                                                title: 'Item',
                                                value: item.iName != null &&
                                                        item.iName!.isNotEmpty
                                                    ? item.iName!
                                                    : '',
                                              ),
                                              AppTitleValueRow(
                                                title: 'Party',
                                                value: item.pName != null &&
                                                        item.pName!.isNotEmpty
                                                    ? item.pName!
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
                                              AppTitleValueRow(
                                                title: 'Status',
                                                value: item.status != null &&
                                                        item.status!
                                                            .toString()
                                                            .isNotEmpty
                                                    ? item.statusText
                                                    : '',
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Visibility(
                                      visible: item.status != null &&
                                          item.status!.toString().isNotEmpty &&
                                          (item.status != 0),
                                      child: Column(
                                        children: [
                                          AppSpaces.v10,
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              AppButton(
                                                buttonWidth: 0.4.screenWidth,
                                                buttonHeight: 30,
                                                title: 'Approval History',
                                                titleSize:
                                                    FontSizes.k16FontSize,
                                                onPressed: () async {
                                                  _controller.showQcDetails
                                                      .value = false;
                                                  await _controller
                                                      .getQcDetails(
                                                    id: item.id.toString(),
                                                  );
                                                  _showDockDetails(item);
                                                },
                                              ),
                                            ],
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

  void _showImagePreview(String imageUrl) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                width: 0.75.screenWidth,
                height: 0.75.screenWidth,
                child: Image.network(
                  imageUrl.startsWith('http') ? imageUrl : 'http://$imageUrl',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      kImageLogo,
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
            ),
            Positioned(
              top: -12.5,
              right: -12.5,
              child: GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: kColorBlackWithOpacity,
                  ),
                  padding: AppPaddings.p6,
                  child: Icon(
                    Icons.close,
                    color: kColorWhite,
                    size: 25,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
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
          ),
          child: Padding(
            padding: AppPaddings.p10,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: 0.75 * Get.height, // Ensures max height constraint
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize
                      .min, // Allows dialog to shrink if content is small
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// 🔹 Title: Dock Details
                    Text(
                      'Dock Details',
                      style: TextStyles.kMediumFredoka(
                        fontSize: FontSizes.k20FontSize,
                        color: kColorSecondary,
                      ),
                    ),
                    AppSpaces.v10,

                    /// 🔹 Dock Image & Info
                    Row(
                      children: [
                        Material(
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
                              fontSize: FontSizes.k20FontSize,
                              color: kColorSecondary,
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
                              fontSize: FontSizes.k20FontSize,
                              color: kColorSecondary,
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
                              fontSize: FontSizes.k20FontSize,
                              color: kColorSecondary,
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
