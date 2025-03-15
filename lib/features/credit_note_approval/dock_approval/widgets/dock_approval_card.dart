import 'package:flutter/material.dart';
import 'package:shreeji_dairy/constants/image_constants.dart';
import 'package:shreeji_dairy/features/credit_note_approval/dock_approval/models/item_for_approval_dm.dart';
import 'package:shreeji_dairy/styles/font_sizes.dart';
import 'package:shreeji_dairy/styles/text_styles.dart';
import 'package:shreeji_dairy/utils/dialogs/app_dialogs.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_paddings.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_spacings.dart';
import 'package:shreeji_dairy/widgets/app_button.dart';
import 'package:shreeji_dairy/widgets/app_card1.dart';
import 'package:shreeji_dairy/widgets/app_title_value_row.dart';

class DockApprovalCard extends StatelessWidget {
  const DockApprovalCard({
    super.key,
    required this.item,
    required this.onApproved,
  });

  final ItemForApprovalDm item;
  final VoidCallback onApproved;

  @override
  Widget build(BuildContext context) {
    return AppCard1(
      child: Padding(
        padding: AppPaddings.p10,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AppButton(
                      buttonHeight: 35,
                      buttonWidth: 100,
                      title: 'Approve',
                      titleSize: FontSizes.k16FontSize,
                      onPressed: onApproved,
                    ),
                  ],
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
                    title: 'CRNT No',
                    value: item.invNo != null && item.invNo!.isNotEmpty
                        ? item.invNo!
                        : '',
                  ),
                  AppTitleValueRow(
                    title: 'Entry Date',
                    value: item.date != null && item.date!.isNotEmpty
                        ? item.date!
                        : '',
                  ),
                  AppTitleValueRow(
                    title: 'Bill No.',
                    value: item.billNo != null && item.billNo!.isNotEmpty
                        ? item.billNo!
                        : '',
                  ),
                  AppTitleValueRow(
                    title: 'Qty',
                    value: item.qty != null && item.qty!.toString().isNotEmpty
                        ? item.qty!.toString()
                        : '0',
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
