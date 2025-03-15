import 'package:flutter/material.dart';
import 'package:shreeji_dairy/constants/color_constants.dart';
import 'package:shreeji_dairy/constants/image_constants.dart';
import 'package:shreeji_dairy/features/credit_note_approval/dock_approval/models/item_for_approval_dm.dart';
import 'package:shreeji_dairy/styles/font_sizes.dart';
import 'package:shreeji_dairy/styles/text_styles.dart';
import 'package:shreeji_dairy/utils/dialogs/app_dialogs.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_paddings.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_spacings.dart';
import 'package:shreeji_dairy/widgets/app_card1.dart';
import 'package:shreeji_dairy/widgets/app_title_value_row.dart';

class CreditNoteStatusCard extends StatelessWidget {
  const CreditNoteStatusCard({
    super.key,
    required this.item,
    required this.onPressedApprovalHistory,
  });

  final ItemForApprovalDm item;
  final VoidCallback onPressedApprovalHistory;

  @override
  Widget build(BuildContext context) {
    return AppCard1(
      child: Padding(
        padding: AppPaddings.p10,
        child: Row(
          children: [
            Column(
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
                AppSpaces.v10,
                Visibility(
                  visible: item.status != null &&
                      item.status!.toString().isNotEmpty &&
                      (item.status != 0),
                  child: InkWell(
                    onTap: onPressedApprovalHistory,
                    child: Text(
                      'Approval\nHistory',
                      style: TextStyles.kRegularFredoka(
                        fontSize: FontSizes.k16FontSize,
                        color: kColorSecondary,
                      ).copyWith(
                        height: 1,
                        decoration: TextDecoration.underline,
                        decorationColor: kColorSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
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
      ),
    );
  }
}
