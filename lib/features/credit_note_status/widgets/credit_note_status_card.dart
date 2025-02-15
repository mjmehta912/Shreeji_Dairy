import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreeji_dairy/constants/color_constants.dart';
import 'package:shreeji_dairy/features/credit_note_approval/dock_approval/models/item_for_approval_dm.dart';
import 'package:shreeji_dairy/styles/font_sizes.dart';
import 'package:shreeji_dairy/styles/text_styles.dart';
import 'package:shreeji_dairy/utils/extensions/app_size_extensions.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_paddings.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_spacings.dart';
import 'package:shreeji_dairy/widgets/app_button.dart';
import 'package:shreeji_dairy/widgets/app_card1.dart';
import 'package:shreeji_dairy/widgets/app_title_value_row.dart';

class CreditNoteStatusCard extends StatelessWidget {
  const CreditNoteStatusCard({
    super.key,
    required this.item,
  });

  final ItemForApprovalDm item;

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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dock Details',
                  style: TextStyles.kMediumFredoka(
                    fontSize: FontSizes.k20FontSize,
                    color: kColorSecondary,
                  ),
                ),
                AppSpaces.v10,
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
                            value:
                                item.docDate != null && item.docDate!.isNotEmpty
                                    ? item.docDate!
                                    : '',
                          ),
                          AppTitleValueRow(
                            title: 'Dock Remark',
                            value: item.docRemark != null &&
                                    item.docRemark!.isNotEmpty
                                ? item.docRemark!
                                : '',
                          ),
                          AppTitleValueRow(
                            title: 'Dock Qty',
                            value: item.docQty != null &&
                                    item.docQty!.toString().isNotEmpty
                                ? item.docQty!.toString()
                                : '0',
                          ),
                          AppTitleValueRow(
                            title: 'Dock Weight',
                            value: item.docWeight != null &&
                                    item.docWeight!.toString().isNotEmpty
                                ? item.docWeight!.toString()
                                : '0',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (item.status != null &&
                    item.status!.toString().isNotEmpty &&
                    (item.status! == 2 ||
                        item.status! == 3 ||
                        item.status! == 4))
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
                        value: item.qcDate != null && item.qcDate!.isNotEmpty
                            ? item.qcDate!
                            : '',
                      ),
                      AppTitleValueRow(
                        title: 'QC Status',
                        value: item.qcStatus != null &&
                                item.qcStatus!.toString().isNotEmpty
                            ? item.qcStatus! == true
                                ? 'Approved'
                                : 'Rejected'
                            : '',
                        color: item.qcStatus != null &&
                                item.qcStatus!.toString().isNotEmpty
                            ? item.qcStatus! == true
                                ? kColorBlue
                                : kColorRed
                            : kColorTextPrimary,
                      ),
                      AppTitleValueRow(
                        title: 'QC Remark',
                        value:
                            item.qcRemark != null && item.qcRemark!.isNotEmpty
                                ? item.qcRemark!
                                : '',
                      ),
                    ],
                  ),
                if (item.status != null &&
                    item.status!.toString().isNotEmpty &&
                    (item.status! == 3 || item.status! == 4))
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
                        value: item.accDate != null && item.accDate!.isNotEmpty
                            ? item.accDate!
                            : '',
                      ),
                      AppTitleValueRow(
                        title: 'Rate',
                        value: item.rate != null &&
                                item.rate!.toString().isNotEmpty
                            ? item.rate!.toString()
                            : '0',
                      ),
                      AppTitleValueRow(
                        title: 'Accounting Remark',
                        value:
                            item.accRemark != null && item.accRemark!.isNotEmpty
                                ? item.accRemark!
                                : '',
                      ),
                    ],
                  ),
                if (item.status != null &&
                    item.status!.toString().isNotEmpty &&
                    (item.status! == 4))
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
                        value: item.approveDate != null &&
                                item.approveDate!.isNotEmpty
                            ? item.approveDate!
                            : '',
                      ),
                      AppTitleValueRow(
                        title: 'Management Status',
                        value: item.approve != null &&
                                item.approve!.toString().isNotEmpty
                            ? item.approve! == true
                                ? 'Approved'
                                : 'Rejected'
                            : '',
                        color: item.approve != null &&
                                item.approve!.toString().isNotEmpty
                            ? item.approve! == true
                                ? kColorBlue
                                : kColorRed
                            : kColorTextPrimary,
                      ),
                      AppTitleValueRow(
                        title: 'Approval Remark',
                        value: item.approveRemark != null &&
                                item.approveRemark!.isNotEmpty
                            ? item.approveRemark!
                            : '',
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
                      buttonWidth: 0.15.screenWidth,
                      buttonHeight: 30,
                      onPressed: () {
                        Get.back();
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
                    borderRadius: BorderRadius.circular(10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        item.imagePath!.startsWith('http')
                            ? item.imagePath!
                            : 'http://${item.imagePath!}',
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
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
                        title: 'Item',
                        value: item.iName != null && item.iName!.isNotEmpty
                            ? item.iName!
                            : '',
                      ),
                      AppTitleValueRow(
                        title: 'Party',
                        value: item.pName != null && item.pName!.isNotEmpty
                            ? item.pName!
                            : '',
                      ),
                      AppTitleValueRow(
                        title: 'Entry Date',
                        value: item.date != null && item.date!.isNotEmpty
                            ? item.date!
                            : '',
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppTitleValueRow(
                            title: 'Qty',
                            value: item.qty != null &&
                                    item.qty!.toString().isNotEmpty
                                ? item.qty!.toString()
                                : '0',
                          ),
                          AppTitleValueRow(
                            title: 'Weight',
                            value: item.weight != null &&
                                    item.weight!.toString().isNotEmpty
                                ? item.weight!.toString()
                                : '0.0',
                          ),
                        ],
                      ),
                      AppTitleValueRow(
                        title: 'Bill No.',
                        value: item.billNo != null && item.billNo!.isNotEmpty
                            ? item.billNo!
                            : '',
                      ),
                      AppTitleValueRow(
                        title: 'Status',
                        value: item.status != null &&
                                item.status!.toString().isNotEmpty
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
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      AppButton(
                        buttonWidth: 0.4.screenWidth,
                        buttonHeight: 30,
                        title: 'Approval History',
                        titleSize: FontSizes.k16FontSize,
                        onPressed: () {
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
  }
}
