import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreeji_dairy/constants/color_constants.dart';
import 'package:shreeji_dairy/constants/image_constants.dart';
import 'package:shreeji_dairy/features/credit_note_approval/dock_approval/models/item_for_approval_dm.dart';
import 'package:shreeji_dairy/features/credit_note_approval/qc_approval/screens/qc_approval_action_screen.dart';
import 'package:shreeji_dairy/styles/font_sizes.dart';
import 'package:shreeji_dairy/styles/text_styles.dart';
import 'package:shreeji_dairy/utils/dialogs/app_dialogs.dart';
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

  @override
  Widget build(BuildContext context) {
    return AppCard1(
      child: Padding(
        padding: AppPaddings.p10,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                showImagePreview(item.imagePath!);
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
                  Text(
                    item.iName != null && item.iName!.isNotEmpty
                        ? item.iName!
                        : '',
                    style: TextStyles.kMediumFredoka(
                      fontSize: FontSizes.k16FontSize,
                    ),
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
                    children: [
                      AppTitleValueRow(
                        title: 'Qty',
                        value:
                            item.qty != null && item.qty!.toString().isNotEmpty
                                ? item.qty!.toString()
                                : '0',
                      ),
                      AppSpaces.h10,
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
                  if (item.reason != null && item.reason!.isNotEmpty)
                    AppTitleValueRow(
                      title: 'Reason',
                      value: item.reason!,
                    ),
                  AppTitleValueRow(
                    title: 'Status',
                    value: item.status != null &&
                            item.status!.toString().isNotEmpty
                        ? item.statusText
                        : '',
                  ),
                  AppSpaces.v10,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppButton(
                        title: 'Dock Details',
                        titleSize: FontSizes.k16FontSize,
                        buttonHeight: 35,
                        buttonWidth: 0.3.screenWidth,
                        onPressed: () {
                          _showDockDetails(item);
                        },
                      ),
                      AppButton(
                        title: 'Action',
                        titleSize: FontSizes.k16FontSize,
                        buttonHeight: 35,
                        buttonWidth: 0.25.screenWidth,
                        onPressed: () {
                          Get.to(
                            () => QcApprovalActionScreen(
                              id: item.id!,
                              iCode: item.iCode!,
                            ),
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
            side: BorderSide(
              color: kColorTextPrimary,
            ),
          ),
          child: Padding(
            padding: AppPaddings.p10,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: 0.75 * Get.height,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
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
                      ],
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
