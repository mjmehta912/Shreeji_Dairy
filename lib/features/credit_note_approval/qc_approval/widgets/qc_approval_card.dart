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

class QcApprovalCard extends StatelessWidget {
  const QcApprovalCard({
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
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Dock Details',
                      style: TextStyles.kMediumFredoka(
                        fontSize: FontSizes.k20FontSize,
                        color: kColorSecondary,
                      ),
                    ),
                  ],
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
            AppSpaces.v10,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppButton(
                  buttonWidth: 0.4.screenWidth,
                  buttonHeight: 30,
                  title: 'Dock Details',
                  titleSize: FontSizes.k16FontSize,
                  onPressed: () {
                    _showDockDetails(item);
                  },
                ),
                AppButton(
                  buttonWidth: 0.2.screenWidth,
                  buttonHeight: 30,
                  buttonColor: kColorRed,
                  title: 'Reject',
                  titleSize: FontSizes.k16FontSize,
                  onPressed: () {},
                ),
                AppButton(
                  buttonWidth: 0.2.screenWidth,
                  buttonHeight: 30,
                  buttonColor: kColorBlue,
                  title: 'Accept',
                  titleSize: FontSizes.k16FontSize,
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
